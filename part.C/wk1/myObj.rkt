; fields are list of (mcons fieldName val)
; methods are list of (cons funcName val)
(struct obj (fields methods))

(define (assoc-m v xs)
    (cond 
        [(null? xs) #f]
        [(equal? v (mcar (car xs))) (car xs)]
        [#t (assoc-m v (cdr xs))]))

(define (get obj fld)
    (let ([res (assoc-m fld (obj-fields obj))])
        (if res
            (mcdr res)
            (error "no such field" v))))

(define (set obj fld v)
    (let ([res (assoc-m fld (obj-fields obj))])
        (if res
            (set-mcdr! res v)
            (error "no such field" v))))

(define (send obj msg . args)
    (let ([res (assoc msg (obj-methods obj))])
        (if res
            ((cdr res) obj args)
            (error "no such method" msg))))

(define (make-point _x _y)
    (obj
        (list
            (mcons 'x _x)
            (mcons 'y _y))
        (list
            (cons 'get-x (lambda (self args) (get self 'x)))
            (cons 'get-y (lambda (self args) (get self 'y)))
            (cons 'set-x (lambda (self args) (set self 'x (car args))))
            (cons 'set-y (lambda (self args) (set self 'y (car args))))
            (cons 'distToOrigin 
                (lambda (self args)
                    (let (
                        [x (send self 'get-x)]
                        [y (send self 'get-y)]
                    )
                    (sqrt (+ (* x x) (* y y)))
                    )))    
        )))

(define (make-color-point _x _y _c)
    (let ([pt (make-point _x _y)])
        (obj
            (cons (mcons 'color _c) (obj-fields pt))
            (append (list
                        (cons 'get-color (lambda (self args) (get self 'color)))
                        (cons 'set-color (lambda (self args) (set self 'color (car args)))))
                    (obj-methods pt)))))


(define (make-polar-point _r _th)
    (let ([pt (make-point _r _th)])
        (obj
            (append (list
                        (mcons 'r _r)
                        (mcons 'theta _th))
                    (obj-fields pt))
            (append (list
                        (cons 'set-r-theta
                            (lambda (self args)
                                (begin
                                    (set self 'r (car args))
                                    (set self 'theta (cardr args)))))
                        (cons 'get-x
                            (lambda (self args)
                                (let (
                                    [r (get self 'r)]
                                    [theta (get self 'theta)])
                                    (* r (cos theta)))))
                        (cons 'get-y
                            (lambda (self args)
                                (let (
                                    [r (get self 'r)]
                                    [theta (get self 'theta)])
                                    (* r (sin theta)))))
                        (cons 'set-x
                            (lambda (self args)
                                (let* (
                                    [x (car args)]
                                    [y (send self 'get-y)]
                                    [r (sqrt (+ (* x x) (* y y)))]
                                    [theta (atan y x)])
                                    (send self 'set-r-theta r theta)
                                )))
                        (cons 'set-y
                            (lambda (self args)
                                (let* (
                                    [y (car args)]
                                    [x (send self 'get-x)]
                                    [r (sqrt (+ (* x x) (* y y)))]
                                    [theta (atan y x)])
                                    (send self 'set-r-theta r theta)
                                )))
                        )
                    (obj-methods pt)))))