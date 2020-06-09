:-module(Code,[]).
insert(A,[B|C],[B|D]):-A@>B,!,insert(A,C,D).
insert(A,C,[A|C]).
sorting([A|B],S):-sorting(B,ST),insert(A,ST,S),visualize(S).
sorting([],[]).

tran([],0).
tran([X],0).
tran([X,Y|T],N2):-
X<Y,tran([Y|T],N1),
N2 is N1+1.
tran([X,Y|T],N2):-
Y=<X,tran([Y|T],N2).

