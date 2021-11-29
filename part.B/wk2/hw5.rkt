;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

;; CHANGE (put your solutions here)

;; Env: Racket list, (racket string, value)

(define (racketlist->mupllist rls)
    (if (null? rls)
        (aunit)
        (apair (car rls) (racketlist->mupllist (cdr rls)))))


(define (mupllist->racketlist mls)
    (if (aunit? mls)
        null
        (cons (apair-e1 mls) (mupllist->racketlist (apair-e2 mls)))))

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; helper func: add bindings to env and return a new env
;; var = value
;; var is a racket string, value is a MUPL value, env is a racket list
(define (add-to-env var value env) (cons (cons var value) env))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(aunit? e) e]
        [(int? e) e]
        [(closure? e) e]
        [(ifgreater? e) 
            (let (
                [v1 (eval-under-env (ifgreater-e1 e) env)]
                [v2 (eval-under-env (ifgreater-e2 e) env)]
            )
            (cond 
                [(and (int? v1) (int? v2)) (if (> (int-num v1) (int-num v2)) 
                                                (eval-under-env (ifgreater-e3 e) env) 
                                                (eval-under-env (ifgreater-e4 e) env))]
                [#t (error "MUPL comparasion between non-numbers")]))]
        [(mlet? e) 
            (letrec (
                [v (eval-under-env (mlet-e e) env)]
                [new-env (add-to-env (mlet-var e) v env)])
            (eval-under-env (mlet-body e) new-env))]
        [(fun? e) (closure env e)]
        [(call? e) 
            (let (
                [e1 (eval-under-env (call-funexp e) env)]
                [e2 (eval-under-env (call-actual e) env)]
            )
            (cond
                [(closure? e1) 
                    (let* (
                        [fun (closure-fun e1)]
                        [fun-name (fun-nameopt fun)]
                        [env (closure-env e1)]
                        [new-env (if fun-name (add-to-env fun-name e1 env) env)]
                        [new-env (add-to-env (fun-formal fun) e2 new-env)]
                    )
                    (eval-under-env (fun-body fun) new-env))]
                [#t (error "not a closure" e1)]))]
        [(fst? e)
            (let ([p (eval-under-env (fst-e e) env)])
                (cond
                    [(apair? p) (apair-e1 p)]
                    [#t (error "fst not a pair ~v" p)]))]
        [(snd? e)
            (let ([p (eval-under-env (snd-e e) env)])
                (cond
                    [(apair? p) (apair-e2 p)]
                    [#t (error "snd not a pair ~v" p)]))]
        [(apair? e)
            (let (
                [v1 (eval-under-env (apair-e1 e) env)]
                [v2 (eval-under-env (apair-e2 e) env)]
            )
            (apair v1 v2))]
        [(isaunit? e) 
            (if (aunit? (eval-under-env (isaunit-e e) env)) 
                (eval-under-env (int 1) env)   ; can be replaced with (int 1)
                (eval-under-env (int 0) env))] ; can be replaced with (int 0)
        [#t (error (format "bad MUPL expression: ~v" e))]))


;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3) (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2) 
    (cond
        [(null? lstlst) e2]
        [#t 
            (let (
                [var (car (car lstlst))]
                [ei (cdr (car lstlst))])
            (mlet var ei (mlet* (cdr lstlst) e2)))]))


;; r1 = if x > y then 0 else 1
;; r2 = if y > x then 1 else 0
;; x > y => r1 = 0, r2 = 0
;; x < y => r1 = 1, r2 = 1
;; x = y => r1 = 1, r2 = 0
;; r1 > r2 => x = y
(define (ifeq e1 e2 e3 e4)
    (mlet "_x" e1 
        (mlet "_y" e2 
            (ifgreater
                (ifgreater (var "_x") (var "_y") (int 0) (int 1))
                (ifgreater (var "_y") (var "_x") (int 1) (int 0))
                e3
                e4))))

;; Problem 4

(define mupl-map
    (fun #f "f"
        (fun "rec" "xs"
            (ifaunit 
                (var "xs")
                (aunit)
                (apair
                    (call (var "f") (fst (var "xs")))
                    (call (var "rec") (snd (var "xs"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i"
            (call (var "map") (fun #f "x" (add (var "x") (var "i")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
