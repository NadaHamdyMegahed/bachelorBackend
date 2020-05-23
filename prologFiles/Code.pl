:-module(Code,[]).

insert(A,[B|C],[B|D]):-A@>B,!,insert(A,C,D).
insert(A,C,[A|C]).
sorting([A|B],S):-sorting(B,ST),insert(A,ST,S),visualize(S).
sorting([],[]).
nada(nada).
nada(sara).
