#lang racket
(require racket/match)
(require turnstile)

(struct lambda-term (ident ty body) #:transparent)
(struct let-term (ident ty expr body) #:transparent)
(struct big-lambda (bindTy body) #:transparent)
(struct apply-term (fn arg) #:transparent)
(struct top-level-def (ident ty body) #:transparent)
(struct type-alias (ident ty) #:transparent)

(define (AST? val)
  (let ([safe-id? (λ[x] (and (syntax? x) (identifier? x)))]
        [safe-type? (λ[x] (and (syntax? x) (type? x)))])
    (or (safe-id? val)
        (and (integer? val) (>= val 0))
        (match val
          [(lambda-term ident ty body)   (and (safe-id? ident) (safe-type? ty) (AST? body))]
          [(let-term ident ty exp body)  (and (safe-id? ident) (safe-type? ty) (AST? exp) (AST? body))]
          [(big-lambda ty body)          (and (safe-type? ty) (AST? body))]
          [(apply-term fn arg)           (and (AST? fn) (AST? arg))]
          [(top-level-def ident ty body) (and (safe-id? ident) (safe-type? ty) (AST? body))]
          [(type-alias ident ty)         (and (safe-id? ident) (safe-type? ty))]
          [_                             #f]))))
#; (let [(add2 : NatFn) (λ[x : Nat] (S (S x)))] (let [(x : Nat) 5] (add2 x)))
#;(define test-ast (let-term #'add2 (mk-type #'(→ Nat Nat)) (lambda-term #'x (mk-type #'Nat) (apply-term #'S (apply-term #'S #'x)))
                           (let-term #'x (mk-type #'Nat) 5 (apply-term #'add2 #'x))))
#;(display (AST? test-ast))