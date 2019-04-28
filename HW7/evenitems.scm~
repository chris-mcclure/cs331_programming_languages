#lang scheme
; Chris McClure
; evenitems.scm
; 27 Apr 2019

; Returns a list of values that
; occupied even indices in a list that was passed.

; evenitems
; calls helper function assist
(define (evenitems lst)
  (assist lst 0)
  )

; assist
; takes a list and a number
; if the list is empty, it returns the empty list
; else if the number is even, then create a list and append the first
; element to the front of it, then increment the num and call assist again
; otherwise, the number is odd. only increment the number and call assist again.
(define (assist lst num)
  (cond
    [(empty? lst) null]
    [(even? num)
     (append (list (first lst)) (assist (rest lst) (+ 1 num)))]
    [else (assist (rest lst) (+ 1 num))]
    )
  )