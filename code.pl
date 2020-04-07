visualize(N):- term_string(N,X),   open('result.txt',read,Out1),
read_string(Out1, _, Y),  string_concat(Y,-,Z), string_concat(Z,X,M),
close(Out1),  open('result.txt',write,Out),  write(Out,M),  close(Out).
clear():-  open('result.txt',write,Out),  write(Out,''),close(Out).
insert(X,[],[X]).
insert(X,[Y|T],[X,Y|T]):-X=<Y.
insert(X,[Y|T],[Y|T2]):-insert(X,T,T2),X>Y,visualize(T2).
nada(X):-X=sara,visualize(X).
