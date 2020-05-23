
:-module(ChessRender,[]).

:- use_module(library(http/html_write)).

%return html button/
returnButton-->
html(button([class('reload-button'),onclick="onClickNext()",id("button1")],"clickhere")).

% return multiple arrays as chess 
returnChessArrays(X):-
http_handler(/, showChessArrays(X), []).
%/

showChessArrays(Arrs,_Request):-
renderChessArrays(Arrs).

renderChessArrays(Arrs):-
  reply_html_page(
    [],
   div([class("main-container")],[\chessArrays(Arrs,Arrs),\style,\script,\returnButton])
    ).
	


returnArrayAsChess(Term)-->
{ is_nqueens(Term),
	  length(Term, N),
	  LineHeight is 200/N
	},
	html(div([ style('display:inline-block;'+
			 'line-height:'+LineHeight+'px;'+
			 'font-size:'+LineHeight+'px;'
			),
		   'data-render'('Chess board')
		 ],
		 [ table(class('chess-board'),
			 \nqueens(Term, N)),
		   \chess_style
		 ])).
		 
returnArrayAsChess(Term)-->
{\+ is_nqueens(Term),term_string(Term,NewTerm)},
	html(div([],NewTerm)).
returnArrayAsChess([])-->[].


% return multiple chess arrays
chessArrays(_,[])-->[].

% if the input can be rendered that way 
chessArrays(L,Inp)-->
{Inp=[H|T],length(L,L1),length(Inp,L2),I is L1-L2},
html(
div([class("viusual-none-container"),id("div"+I)],\returnArrayAsChess(H))),
chessArrays(L,T).



% all from swi prolog
is_nqueens(Term) :-
	is_list(Term),
	maplist(integer, Term),
	length(Term, N),
	numlist(1, N, All),
	sort(Term, All).

nqueens([], _) --> [].
nqueens([H|T], N) -->
	html(tr(\nrow(0, N, H))),
	nqueens(T, N).

nrow(N, N, _) --> !.
nrow(I, N, At) -->
	{ I2 is I+1 },
	(   { I2 == At }
	->  html(td(&('#9819')))
	;   html(td([]))
	),
	nrow(I2, N, At).


script-->
html({|html||

<script>
var x = 0;

function onClickNext() {
  var y = document.getElementById("div"+x);

    y.style.display = "block";
    x=x+1;

}
</script>

|}).

style-->
html({|html||
<style>

.main-container{
 display: flex;
    flex-direction: column;

    align-items: center;
}
.viusual-none-container{
	display:none;
}
.reload-button{
background-color:red;
margin-top:5px;
cursor:pointer;
}

</style>
|}).

chess_style-->
html({|html||
<style>
.chess-board {
  border:2px solid #333; width:200px; height:200px;
}
.chess-board td {
  background:#fff;
  background:-moz-linear-gradient(top, #fff, #eee);
  background:-webkit-gradient(linear,0 0, 0 100%, from(#fff), to(#eee));
  box-shadow:inset 0 0 0 1px #fff;
  -moz-box-shadow:inset 0 0 0 1px #fff;
  -webkit-box-shadow:inset 0 0 0 1px #fff;
  text-align:center;
  vertical-align:middle;
}
.chess-board tr:nth-child(odd) td:nth-child(even),
.chess-board tr:nth-child(even) td:nth-child(odd) {
  background:#ccc;
  background:-moz-linear-gradient(top, #ccc, #eee);
  background:-webkit-gradient(linear,0 0, 0 100%, from(#ccc), to(#eee));
  box-shadow:inset 0 0 10px rgba(0,0,0,.4);
  -moz-box-shadow:inset 0 0 10px rgba(0,0,0,.4);
  -webkit-box-shadow:inset 0 0 10px rgba(0,0,0,.4);
}
</style>


	     |}).


