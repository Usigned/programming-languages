(struct Const (e) #:transparent)
(struct Negate (e) #:transparent)
(struct Add (e1 e2) #:transparent)
(struct Multiply (e1 e2) #:transparent)


(define (eval-exp e)
    (cond
        [(Const? e) e]
        [(Negate? e) (Const (- (Const-e (eval-exp (Negate-e e)))))]
        [(Add? e) (let (
            [v1 (Const-e (eval-exp (Add-e1 e)))]
            [v2 (Const-e (eval-exp (Add-e2 e)))])
            (Const (+ v1 v2)))]
        [(Multiply? e) (let (
            [v1 (Const-e (eval-exp (Multiply-e1 e)))]
            [v2 (Const-e (eval-exp (Multiply-e2 e)))])
            (Const (* v1 v2)))]
        [#t (error "not a exp")]))

(define a-test (eval-exp (Multiply (Negate (Add (Const 2) (Const 2))) (Const 7))))