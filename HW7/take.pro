% Chris McClure
% take.pro
% 28 Apr 2019
% CS331 HW7 Part D

take(_, [], []) :- !.
take(0, _, []) :- !.
take(N, [H|T], [H|E]) :-
  NN is N-1,
  take(NN, T, E).