\ Chris McClure 
\ collcount.fs
\ 27 Apr 2019
\ CS331 HW7 Part B

\ Calculates the amount of times
\ collcount needs to be called in 
\ order for a passed number to 
\ be reduced to 1.

\ collstep
\ defines one step in the collatz sequence
: collstep ( n -- n )
  dup 2 mod
  0 = if   \ if n is even, divide by 2
    2 /
  else  \ if n is odd, mult by 3 and add 1
    3 * 1 +
  endif
;

\ collcount
\ takes a number n, returns length of collatz sequence
: collcount ( n -- c )
  dup 1 > if
    collstep recurse 1+ \ increment by 1 each iteration
  else
    1- \ offset for starting count at 1, instead of 0
  endif
;