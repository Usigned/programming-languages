
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
    (if (> low high)
        null
        (cons low (sequence (+ low stride) high stride))))


(define (string-append-map xs suffix)
    (map (lambda (x) (string-append x suffix)) xs))


(define (list-nth-mod xs n)
    (cond 
        [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: negative number")]
        [#t (car (list-tail xs (remainder n (length xs))))]))


(define (stream-for-n-steps s n)
    (if (= n 0)
        null
        (let ([p (s)]) (cons (car p) (stream-for-n-steps (cdr p) (- n 1))))))


(define funny-number-stream
    (letrec ([f (lambda (x) (cons (if (= (remainder x 5) 0) (- 0 x) x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))


(define dan-then-dog
    (letrec (
        [f-dan (cons "dan.jpg" (lambda () f-dog))]
        [f-dog (cons "dog.jpg" (lambda () f-dan))])
    (lambda () f-dan)))


(define (stream-add-zero s) (lambda () (let ([p (s)]) (cons (cons 0 (car p)) (stream-add-zero (cdr p))))))