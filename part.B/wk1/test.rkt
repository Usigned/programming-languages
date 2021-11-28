#lang racket

; this is a commmet

; (provide (all-defined-out))

(define s "hello")

(define x 3)

(define y (+ x 2))

(define cube1
  (lambda (x)
    (* x (* x x))))

(define cube2
  (lambda (x)
    (* x x x)))

(define (cube3 x) (* x x x))

(define (sum xs)
  (if (null? xs) 0 (+ (car xs) (sum (cdr xs)))))

(sum (list 3 4 5 6))


(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

(define (pow x y)
	(if (= y 0)
		1
		(* x (pow x (- y 1)))))


(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))

;append
(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))

;map
(define (map f xs)
  (if (null? xs)
      null
      (cons (f (car xs)) 
        (map f (cdr xs)))
  ))


(define (sum_nums xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum_nums (cdr xs)))
          (+ (sum_nums (car xs)) (sum_nums (cdr xs))))))


(define (count_false xs)
	(cond 
		[(null? xs) 0]
		[(car xs) (count_false (cdr xs))]
		[#t (+ 1 (count_false (cdr xs)))]))