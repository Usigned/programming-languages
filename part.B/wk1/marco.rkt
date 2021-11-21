; (my-if foo then bar else barz) -> (if foo bar baz)
(define-syntax my-if
    (syntax-rules (then else)
        [(my-if foo then bar else barz) (if foo bar barz)]))

; (comment-out trash rep) -> rep
(define-syntax comment-out
    (syntax-rules ()
        [(comment-out ignore rep) rep]))

; 使用宏实现promises
; (my-delay e) -> '(#f . lambda () e)
(define-syntax my-delay
    (syntax-rules ()
        [(my-delay e) (cons #f (lambda () e))]))