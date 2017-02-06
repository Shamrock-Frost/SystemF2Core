#lang turnstile

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