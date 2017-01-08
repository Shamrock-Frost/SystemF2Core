#lang s-exp "./sysf.rkt"
(define-type-alias Bool (∀[τ] (→ τ (→ τ τ))))
(define-type-alias BinaryBoolOperator (→ Bool (→ Bool Bool)))

(let [(to-bool : (→ Bool Nat)) (λ[b : Bool] (((inst b Nat) 1) 0))] ; True -> 1, False -> 0
(let [(⊤ : Bool) (Λ[τ] (λ[then : τ] (λ[else : τ] then)))] ; True
(let [(⊥ : Bool) (Λ[τ] (λ[then : τ] (λ[else : τ] else)))] ; False
(let [(∧ : BinaryBoolOperator) ; And
      (λ[b1 : Bool] (λ[b2 : Bool] (((inst b1 Bool) b2) ⊥)))]
(let [(∨ : BinaryBoolOperator) ; Or
           (λ[b1 : Bool] (λ[b2 : Bool] (((inst b1 Bool) ⊤) b2)))]
   (to-bool ((∧ ⊥) ⊤))))))) ; I'm too lazy to try this for every single combination, but I did it in the repl
                             ; The truth tables are correct