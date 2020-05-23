full():-set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).

visualize(N):- term_string(N,X),   open('result.txt',read,Out1),
read_string(Out1, _, Y),  string_concat(Y,-,Z), string_concat(Z,X,M),
close(Out1),  open('result.txt',write,Out),  write(Out,M),  close(Out).
clear():-  open('result.txt',write,Out),  write(Out,''),close(Out).
insert(A,[B|C],[B|D]):-A@>B,!,insert(A,C,D).
insert(A,C,[A|C]).
sorting([A|B],S):-sorting(B,ST),insert(A,ST,S),visualize(ST).
sorting([],[]).


:- use_module(library(clpfd)).

queens(N, Queens) :-
    length(Queens, N),
	board(Queens, Board, 0, N, _, _),
	queens(Board, 0, Queens).

board([], [], N, N, _, _).
board([_|Queens], [Col-Vars|Board], Col0, N, [_|VR], VC) :-
	Col is Col0+1,
	functor(Vars, f, N),
	constraints(N, Vars, VR, VC),
	board(Queens, Board, Col, N, VR, [_|VC]).

constraints(0, _, _, _) :- !.
constraints(N, Row, [R|Rs], [C|Cs]) :-
	arg(N, Row, R-C),
	M is N-1,
	constraints(M, Row, Rs, Cs).

queens([], _, []).
queens([C|Cs], Row0, [Col|Solution]) :-
	Row is Row0+1,
	select(Col-Vars, [C|Cs], Board),
	arg(Row, Vars, Row-Row),
	queens(Board, Row, Solution).

sara(1).	
	nada([1,2,5,7]).
	nada([1,2,3,4]).
	nada([[9, 8, 7, 6, 5, 4, 3, 2, 1], [2, 4, 6, 1, 7, 3, 9, 8, 5], [3, 5, 1, 9, 2, 8, 7, 4, 6], [1, 2, 8, 5, 3, 7, 6, 9, 4], [6, 3, 4, 8, 9, 2, 1, 5, 7], [7, 9, 5, 4, 6, 1, 8, 3, 2], [5, 1, 9, 2, 8, 6, 4, 7, 3], [4, 7, 2, 3, 1, 9, 5, 6, 8], [8, 6, 3, 7, 4, 5, 2, 1, 9]]).




% Example by Markus Triska, taken from the SWI-Prolog manual.

sudoku(Rows) :-
        length(Rows, 9), maplist(same_length(Rows), Rows),
        append(Rows, Vs), Vs ins 1..9,
        maplist(all_distinct, Rows),
        transpose(Rows, Columns),
        maplist(all_distinct, Columns),
        Rows = [A,B,C,D,E,F,G,H,I],
        blocks(A, B, C), blocks(D, E, F), blocks(G, H, I).

blocks([], [], []).
blocks([A,B,C|Bs1], [D,E,F|Bs2], [G,H,I|Bs3]) :-
        all_distinct([A,B,C,D,E,F,G,H,I]),
        blocks(Bs1, Bs2, Bs3).

problem(1, [[,,, _,,, _,,_],
            [,,, _,,3, _,8,5],
            [,,1, ,2,, ,,_],

            [,,, 5,,7, ,,_],
            [,,4, ,,, 1,,_],
            [,9,, ,,, _,,_],

            [5,,, ,,_, _,7,3],
            [,,2, ,1,, ,,_],
            [,,, _,4,, ,,9]]).

sudoku2(Rows):-problem(1, Rows), sudoku(Rows).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

% start the server
server(Port) :-
    http_server(http_dispatch, [port(Port)]).


:- initialization(server(8000)).


showArr(Arr,_Request):-
  
  reply_html_page(
    [

      title('Dynamic HTML')
    ],

   [div([class("main-container")],[div([class("visual-array-conatainer")],\array(Arr)),\returnButton]),\style]
    ).
showArrs(Arr,_Request):-
  
  reply_html_page(
    [
      title('Dynamic HTML')
    ],
   [div([class("main-container")],[\arrays(Arr,Arr),\returnButton]),\style]
    ).

%reply html page
repArrs(Arr):-
  
  reply_html_page(
    [],
   [div([class("main-container")],[\arrays(Arr,Arr),\returnButton]),\style]
    ).


 

%pred that map one array
returnArray(X):-
http_handler(/, showArr(X), []).

%pred that map multiple arrays
returnArrays(X):-
http_handler(/, showArrs(X), []).


% get index of element in arr
indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.


% return multiple arrays
arrays(_,[])-->[].

arrays(L,[H|T])-->
{indexOf(L,H,I)},
html(
div([class("viusual-none-container"),id("div"+I)],div([class("visual-array-conatainer")],\array(H)))),
arrays(L,T).


%return the array bars
array([]) --> [].
array([H|T])-->
{returnBarHeight(H,H2)},
html(div([class("visual-array-bar"),
 style(
'background-color:black;color:white;'+
'height:'+H2+'px;'

)],H)),
array(T).

% return the height of each bar
returnBarHeight(V,H):-
H is V*5+10.

%return html button
returnButton-->
html(button([class('reload-button'),id("button1"),onclick="myFunction()"],"clickhere")).
    





style-->
html({|html||
<!--<button onclick="myFunction()">nada</button>-->
<script>
var x = 0;

function myFunction() {
  var y = document.getElementById("div"+x);

    y.style.display = "block";
    x=x+1;

}
</script>

  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- step by step rendering by delay -->
  <!--script>
            $(document).ready(function() {
             $("#div0").delay(500).fadeIn();
	  $("#div1").delay(1000).fadeIn();
    $("#div2").delay(1700).fadeIn();
	 $("#div3").delay(2400).fadeIn();
	 $("#div4").delay(3100).fadeIn();
            })
        </script-->


<body>

</body>


<style>

.main-container{
 display: flex;
    flex-direction: column;

    align-items: center;
}

.reload-button{
background-color:red;
margin-top:5px;
cursor:pointer;
}
.viusual-none-container{
	display:none;
}
.visual-array-conatainer{
    display: flex;
    flex-direction: row;

    align-items: flex-end;
    background-color:rgb(161, 187, 207);
    padding-right: 5px;
   
    margin-top: 5px;
	
    
   
}

.visual-array-bar{
margin-left: 7px;
width: 20px;
border: 1px solid grey;

}
</style>


	     |}).

nada(hamdy).
nada(megahed).
nada(ahmed).

karim(sara).

nada([1,2,3,4],[5,6,7,8]).
sara(X,Y):-nada(X,Y),visualize(X).
insert(A,[B|C],[B|D]):-A@>B,!,insert(A,C,D).
insert(A,C,[A|C]).
sorting([A|B],S):-sorting(B,ST),insert(A,ST,S),visualize(S).
sorting([],[]).
