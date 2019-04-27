#lang scheme
; Chris McClure
; evenitems.scm
; 27 Apr 2019

; Seperates a list by evens and odds
; into two seperate lists.

; add element to the list
(define (addtolist l1 l2)
  (list l1 l2)
  )


;if even add item to new list and call evenitems with rest
;if odd add item to another new list and call evenitems with rest
; once there is no more elements in the list, return both lists
(define (evenitems lst)
  (cond
    [(empty? lst) lst]
    [(even? (first lst))
     (addtolist (first lst) (evenitems (rest lst)))
     ]
    [else
     (addtolist (evenitems (rest lst)) (first lst))
     ]
    )
  )
