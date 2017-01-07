#lang s-exp "./stlc.rkt"
((λ[add2 : (→ Nat Nat)] (add2 5)) ;equivalent to (let [add2 ...] (add2 5))
 (λ[x : Nat] (S (S x)))) ;adds two to its argument
