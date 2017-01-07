#lang turnstile/lang

(extends "stlc.rkt")

(provide (type-out ∀) Λ inst define-type-alias)

(define-binding-type ∀)

(define-typed-syntax (Λ τvar:id e) ≫
  [[τvar ≫ τvar- : #%type] ⊢ e ≫ e- ⇒ τ]
  --------
  [⊢ e- ⇒ (∀ (τvar-) τ)])

(define-typed-syntax inst
  [(_ e τ:type) ≫
   [⊢ e ≫ e- ⇒ (~∀ τvar τbody)]
   #:with τ_inst (substs #'τ.norm #'τvar #'τbody)
   --------
   [⊢ e- ⇒ τ_inst]]
  [(_ e) ≫
   --------
   [≻ e]])

(define-syntax define-type-alias
  (syntax-parser
    [(_ alias:id τ:any-type)
     #'(define-syntax- alias
         (make-variable-like-transformer #'τ))]))