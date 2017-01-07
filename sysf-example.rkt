#lang s-exp "./sysf.rkt"
; True
(Λ τ (λ [true : τ] (λ [false : τ] true)))
; False
(Λ τ (λ [true : τ] (λ [false : τ] false)))