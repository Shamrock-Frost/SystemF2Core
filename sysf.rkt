#lang turnstile/lang

(extends "stlc.rkt")

(provide (type-out ∀) Λ inst)

(define-binding-type ∀)

(define-typed-syntax (Λ (τvar:id ...) e) ≫
  [([τvar ≫ τvar- : #%type] ...) () ⊢ e ≫ e- ⇒ τ]
  --------
  [⊢ e- ⇒ (∀ (τvar- ...) τ)])

(define-typed-syntax inst
  [(_ e τ:type ...) ≫
                    [⊢ e ≫ e- ⇒ (~∀ τvars τbody)]
                    #:with τ_inst (substs #'(τ.norm ...) #'τvars #'τbody)
                    --------
                    [⊢ e- ⇒ τ_inst]]
  [(_ e) ≫
   --------
   [≻ e]])

(begin-for-syntax
  (require racket/match)
  (struct lambda-term (ident body))
  (struct let-term (ident expr body))
  (define (AST? val)
    (let ([safe-id? (λ[x] (and (syntax? x) (identifier? x)))])
      (or (safe-id? val)
          (and (integer? val) (>= val 0))
          (and (syntax? val) (type? val))
          (match val
            [(lambda-term ident body)  (and (safe-id? ident) (AST? body))]
            [(let-term ident exp body) (and (safe-id? ident) (AST? exp) (AST? body))]
            [_                         #f]))))
  (define test-ast (lambda-term #'x (let-term #'y 5 #'y)))
  #;(if (AST? test-ast)
        (displayln "yippee!")
        (error "test-ast wasn't an AST :(")))