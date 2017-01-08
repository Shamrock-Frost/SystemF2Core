#lang s-exp "./stlc.rkt"
(define-type-alias NatFn (→ Nat Nat))

(let [(add2 : NatFn) (λ[x : Nat] (S (S x)))]
  (let [(x : Nat) 5]
   (add2 x)))