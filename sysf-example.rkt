#lang s-exp "./sysf.rkt"
(define-type-alias Bool (∀ (τ) (→ τ (→ τ τ))))
;Not sure why this doesn't work 

; True
(Λ τ (λ [true : τ] (λ [false : τ] true)))
; False
(Λ τ (λ [true : τ] (λ [false : τ] false)))
And/Conjunction
(λ [b1 : Bool] (λ [b2 : Bool] ((λ (false : Bool) (((inst b1 Bool) b2) false))
                               (Λ τ (λ [true : τ] (λ [false : τ] false)))))) ; this is just for simulating a let binding
; Or/Disjunction
;(λ [b1 : Bool] (λ [b2 : Bool] ((λ [true : Bool] (((inst b1 Bool) true) b2))
;                               (Λ τ (λ [true : τ] (λ [false : τ] true))))))

; "foldl: given list does not have the same size as the first list: '(#<syntax:C:\Users\Brendan\Dev\Lisp\Racket\turnstile-workspace\SystemF2Core\sysf-example.rkt:15:13 τ>)"
;((λ[id : (∀ (τ) (→ τ τ))]
;   ((inst ((inst id (∀ (τ) (→ τ τ))) id) Nat) ((inst id Nat) 5)))
; (Λ τ (λ[x : τ] x)))