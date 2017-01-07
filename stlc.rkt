#lang turnstile/lang
(provide (type-out → Nat) λ #%app #%datum (typed-out [[add1 : (→ Nat Nat)] S]))

(define-type-constructor → #:arity = 2)
(define-typed-syntax (λ (x:id : τ_in:type) e) ≫
  [[x ≫ x- : τ_in.norm] ⊢ e ≫ e- ⇒ τ_out]
  ------
  [⊢ (λ- (x-) e-) ⇒ (→ τ_in.norm τ_out)])
(define-typed-syntax (#%app e_fn e_arg) ≫
  [⊢ e_fn ≫ e_fn- ⇒ (~→ τ_in τ_out)]
  [⊢ e_arg ≫ e_arg- ⇐ τ_in] 
  ------
  [⊢ (#%app- e_fn- e_arg-) ⇒ τ_out])
(define-base-type Nat)
(define-typed-syntax #%datum
  [(_ . n:nat) ≫
   ------
   [⊢ (#%datum- . n) ⇒ Nat]]
  [(_ . n:integer) ≫
   ------
   [_ #:error (type-error #:src #'n #:msg "Unsupported literal: ~v. Only natural numbers are supported" #'n)]]
  [(_ . x) ≫
   --------
   [_ #:error (type-error #:src #'x #:msg "Unsupported literal: ~v" #'x)]])