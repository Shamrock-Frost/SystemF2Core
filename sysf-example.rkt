#lang s-exp "./sysf.rkt"
(define-type-alias Bool (∀[τ] (→ τ (→ τ τ))))
(define-type-alias BinaryBoolOperator (→ Bool (→ Bool Bool)))
(define-type-alias CNat (∀[τ] (→ (→ τ τ) (→ τ τ))))

(define to-bool : (→ Bool Nat) (λ[b : Bool] (((inst b Nat) 1) 0))) ; True -> 1, False -> 0
(define to-nat  : (→ CNat Nat) (λ[n : CNat] (((inst n Nat) S) 0)))
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

(define plus : (→ CNat (→ CNat CNat))
  (λ[m : CNat] (λ[n : CNat] (Λ[τ] (λ[f : (→ τ τ)] (λ[x : τ] (((inst m τ) f) (((inst n τ) f) x))))))))
(define zero : CNat (Λ[τ] (λ[f : (→ τ τ)] (λ[x : τ] x))))
(define succ : (→ CNat CNat) (λ[n : CNat] (Λ[τ] (λ[f : (→ τ τ)] (λ[x : τ] (f (((inst n τ) f) x)))))))

;The below will error with the message "define: Recursion isn't allowed in this λ Calculus! in: (define rec : (→ Bool Nat) (λ (b : Bool) (((inst b Nat) 1) (rec b))))"
#;(define rec : (→ Bool Nat)
    (λ[b : Bool] (((inst b Nat) 1) (rec b))))