#lang s-exp "./sysf.rkt"
(define-type-alias Bool (∀[τ] (→ τ (→ τ τ))))
(define-type-alias BinaryBoolOperator (→ Bool (→ Bool Bool)))

(define to-bool (λ[b : Bool] (((inst b Nat) 1) 0))) ; True -> 1, False -> 0
(define ⊤ : Bool (Λ[τ] (λ[then : τ] (λ[else : τ] then)))) ; True
(define ⊥ : Bool (Λ[τ] (λ[then : τ] (λ[else : τ] else)))) ; False
(define ∧ : BinaryBoolOperator (λ[p : Bool] (λ[q : Bool] (((inst p Bool) q) ⊥)))) ; And
(define ∨ : BinaryBoolOperator (λ[p : Bool] (λ[q : Bool] (((inst p Bool) ⊤) q)))) ; Or

(to-bool ((∧ ⊤) ⊤))
(to-bool ((∧ ⊤) ⊥))
(to-bool ((∧ ⊥) ⊤))
(to-bool ((∧ ⊥) ⊥))

(to-bool ((∨ ⊤) ⊤))
(to-bool ((∨ ⊤) ⊥))
(to-bool ((∨ ⊥) ⊤))
(to-bool ((∨ ⊥) ⊥))