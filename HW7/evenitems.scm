#lang scheme

(define (thing lst)
  (assist lst 0)
  )

(define (assist lst num)
  (cond
    [(empty? lst) 0]
    [(even? num)
     (list (first lst) (assist (rest lst) (+ 1 num)))
     ]
    [else (assist (rest lst) (+ 1 num))]
    )
  )