(define mpr (mcons 1 (mcons 2 (mcons 3 null))))

(define (my-delay th)
    (mcons #f th))

(define (my-force mp)
    (if (mcar mp)
        (mcdr mp)
        (begin [set-mcar! mp #t] [set-mcdr! mp ((mcdr mp))] [(mcdr mp)]))

; count直到满足条件
(define (number-until stream tester)
    (define p (stream))
    (if (tester (car p))
        1
        (+ 1 (number-until (cdr p) tester))))

; tail-rec ver
(define (number-until stream tester)
    (define (f stream aux)
        (define p (stream))
        (if (tester (car p))
            aux
            (f (cdr p) (+ aux 1))))
    (f stream 1))


(define powers-of-two
    (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
        (lambda () (f 2))))