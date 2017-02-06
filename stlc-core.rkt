#lang turnstile

(provide (rename-out [new-mb #%module-begin] [new-app #%app]) (type-out → Nat) λ #%datum (typed-out [[add1 : (→ Nat Nat)] S]) let define-type-alias ann define)

(struct lambda-term (ident ty body) #:transparent)
(struct let-term (ident ty expr body) #:transparent)
(struct big-lambda (bindTy body) #:transparent)
(struct apply-term (fn arg) #:transparent)
(struct top-level-def (ident ty body) #:transparent)
(struct type-alias (ident ty) #:transparent)

(define-type-constructor → #:arity = 2)
(define-base-type Nat)

(define-typed-syntax (λ[x:id : τ_in:type] e) ≫
  [[x ≫ x- : τ_in.norm] ⊢ e ≫ e- ⇒ τ_out]
  -----
  [⊢ (lambda-term #'x- τ_in.norm e-) ⇒ (→ τ_in.norm τ_out)])
(define-typed-syntax (let [(x:id : τ_in:type) e] body) ≫
  [[x ≫ x- : τ_in.norm] ⊢ body ≫ body- ⇒ τ_out]
  [⊢ e ≫ e- ⇐ τ_in]
  ------
  [⊢ (let-term #'x- τ_in.norm e- body-) ⇒ τ_out])
(define-typed-syntax (new-app e_fn e_arg) ≫
  [⊢ e_fn ≫ e_fn- ⇒ (~→ τ_in τ_out)]
  [⊢ e_arg ≫ e_arg- ⇐ τ_in]
  ------
  [⊢ (apply-term e_fn- e_arg-) ⇒ τ_out])

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
     #'(begin-
         (define-syntax- alias (make-variable-like-transformer #'τ))
         (type-alias #'alias #'τ))]))

(begin-for-syntax
  (define (mentioned name)
    (λ(stx)
      (or (and (identifier? stx) (free-identifier=? name stx))
          (let ([ls (syntax->list stx)])
               (and ls (ormap (mentioned name) ls)))))))

(define-typed-syntax define
  [(_ x:id : τ:type e:expr) ≫
   #:fail-when ((mentioned #'x) #'e) "Recursion isn't allowed in this λ Calculus!"
   [⊢ e ≫ e- ⇐ τ.norm]
   #:with y (generate-temporary #'x)
   --------
   [≻ (begin-
          (define-syntax x (make-rename-transformer (⊢ y : τ.norm)))
          (define- y e-)
          (top-level-def x τ.norm e-))]])

(define-syntax new-mb
  (syntax-parser
    [(_ x ...)
     #:with mb+ (local-expand #'(#%plain-module-begin x ...) 'module-begin '())
     #:do [(pretty-print (stx->datum #'mb+))]
     #:with ((~literal #%plain-module-begin) x+ ...) #'mb+
     #:do [(stx-map (compose pretty-print stx->datum) #'(x+ ...))]
     #'(#%module-begin x+ ...)]))