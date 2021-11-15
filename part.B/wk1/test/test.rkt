#lang racket

; this is a commmet

(provide (all-defined-out))

(define s "hello")

(define x 3)

(define y (+ x 2))

(define cube1
  (lambda (x)
    (* x (* x x))))

(define cube2
  (lambda (x)
    * x x x))

(define (cube3 x) (* x x x))

(define (sum xs)
  (if (null? xs) 0 (+ (car xs) (sum (cdr xs)))))

(sum (list 3 4 5 6))


(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))