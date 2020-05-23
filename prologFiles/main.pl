 :-  use_module('ArrayRender',[returnArrays/1,renderArrays/1]).
 :-  use_module('SudokuRender',[returnSudokuArrays/1,renderSudokuArrays/1]).
 :-  use_module('ChessRender',[returnChessArrays/1,renderChessArrays/1]).
 :-  use_module('Code',[]).
 
 :- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).




:-dynamic visualizeArr/1.
visualizeArr([]).

 % start the server
server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- initialization(server(9000)).

%/
noVisual(_Request):-
  reply_html_page(title('Nothing visual'),
                        [ h1('Nothing visual to show')]).

full():-set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).


visualize(Y):-
visualizeArr(X),
append(X,[Y],X2),
    replace_existing_fact(visualizeArr(X),visualizeArr(X2)).
replace_existing_fact(OldFact, NewFact) :-
    call(OldFact),
    retract(OldFact),
    assertz(NewFact).

% different renders

% visual Array
renderVisualArrays:-
visualizeArr(X),renderArrays(X).
% visual chess
renderVisualChess:-
visualizeArr(X),renderChessArrays(X).
% visual Sudoku
renderVisualSudoku:-
visualizeArr(X),renderSudokuArrays(X).