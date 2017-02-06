#lang turnstile/lang
(provide (type-out → Nat) λ #%app #%datum (typed-out [[add1 : (→ Nat Nat)] S]) let define-type-alias ann define)

(define-type-constructor → #:arity = 2)
(define-typed-syntax (λ (x:id : τ_in:type) e) ≫
  [[x ≫ x- : τ_in.norm] ⊢ e ≫ e- ⇒ τ_out]
  ------
  [⊢ (λ- (x-) e-) ⇒ (→ τ_in.norm τ_out)])
(define-typed-syntax (let [(x:id : τ_in:type) e] body) ≫
  [[x ≫ x- : τ_in.norm] ⊢ body ≫ body- ⇒ τ_out]
  [⊢ e ≫ e- ⇐ τ_in]
  ------
  [⊢ (let- [(x- e-)] body-) ⇒ τ_out])
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
(define-typed-syntax (ann e (~datum :) τ:type) ≫
  [⊢ e ≫ e- ⇐ τ.norm]
  --------
  [⊢ e- ⇒ τ.norm])

(define-syntax define-type-alias
  (syntax-parser
    [(_ alias:id τ:any-type)
     #'(define-syntax- alias
         (make-variable-like-transformer #'τ))]))

(begin-for-syntax
  (define (mentioned name)
    (λ(stx)
      (or (and (identifier? stx) (free-identifier=? name stx))
          (let ([ls (syntax->list stx)])
               (and ls (ormap (mentioned name) ls)))))))

(define-typed-syntax define
  [(_ x:id : τ:type e:expr) ≫
   #:fail-when ((mentioned #'x) #'e) "Recursion isn't allowed in this λ Calculus!"
   #:with y (generate-temporary)
   --------
   [≻ (begin-
        (define-syntax x (make-rename-transformer (⊢ y : τ.norm)))
        (define- y (ann e : τ.norm)))]])