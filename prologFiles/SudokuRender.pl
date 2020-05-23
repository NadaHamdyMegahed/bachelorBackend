:-module(SudokuRender,[]).


:- use_module(library(http/html_write)).
:- use_module(library(http/term_html)).

% return multiple sudoku arrays

%return html button/
returnButton-->
html(button([class('reload-button'),onclick="onClickNext()",id("button1")],"clickhere")).

% return multiple sudoku arrays 
returnSudokuArrays(X):-
http_handler(/, showSudokuArrays(X), []).

%/
showSudokuArrays(Arrs,_Request):-
renderSudokuArrays(Arrs).

renderSudokuArrays(Arrs):-
  reply_html_page(
    [],
   div([class("main-container")],[\sudokuArrays(Arrs,Arrs),\style,\script,\returnButton])
    ).
	

% return multiple sudoku arrays
sudokuArrays(_,[])-->[].

% if the input can be rendered that way 
sudokuArrays(L,Inp)-->
{Inp=[H|T],length(L,L1),length(Inp,L2),I is L1-L2},
html(
div([class("viusual-none-container"),id("div"+I)],\returnAsSudoku(H))),
sudokuArrays(L,T).



returnAsSudoku(Term)-->
	{ is_sudoku(Term)
	}, !,
	html(div([class(sudoku),
		  'data-render'('Sudoku matrix')
		 ],
		 [\rows(Term, 1), \sudoku_style])).
		 
returnAsSudoku(Term)-->
{\+is_sudoku(Term),term_string(Term,NewTerm)},
	html(div([],
		 NewTerm)).
returnAsSudoku([])-->[].

% all from swi prolog
rows([], _) --> [].
rows([H|T], I) -->
	{ I2 is I+1,
	  (   (I == 3 ; I == 6)
	  ->  Extra = [fat]
	  ;   Extra = []
	  )
	},
	html(div(class(['sudoku-row'|Extra]), \cells(H, 1))),
	rows(T, I2).

cells([], _) --> [].
cells([H|T], I) -->
	{ I2 is I+1,
	  (   (I == 3 ; I == 6)
	  ->  Extra = [fat]
	  ;   Extra = []
	  )
	},
	html(div(class(['sudoku-cell'|Extra]), \value(H))), cells(T, I2).

value(H) --> { var(H) }, !.
value(H) --> term(H, []).



is_sudoku(Term) :-
	is_list(Term),
	length(Term, 9),
	maplist(is_row, Term).

is_row(Row) :-
	is_list(Row),
	length(Row, 9),
	maplist(is_cell, Row).

is_cell(Var) :- var(Var).
is_cell(I)   :- integer(I), between(1, 9, I).



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
	margin-bottom:2px;
}
.reload-button{
background-color:red;
margin-top:5px;
cursor:pointer;
}
</style>
|}).

sudoku_style -->
	html({|html||
	      <style>
div.sudoku { vertical-align: top;
	     display:inline-block;
	     border: 3px solid black;
	     width: 220px;
	     height: 220px;
	     font-size: 0;
	   }
div.sudoku-row     { height: 11.11%; }
div.sudoku-row.fat { border-bottom: 2px solid black;}
div.sudoku-cell { width: 11.11%; height: 100%;
		  font-size: 12px;
		  font-weight: bold;
		  display: inline-block;
		  box-sizing: border-box;
		  border: 1px solid #888;
		  margin: 0px;
		  text-align: center;
		  vertical-align: middle;
		}
div.sudoku-cell.fat { border-right: 2px solid black;}
	      </style>
	     |}).

