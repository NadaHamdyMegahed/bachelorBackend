:-module(ArrayRender,[]).

:- use_module(library(http/html_write)).




%return the visual render of array of arrays/
renderArrayAsBars(Arr):-
  reply_html_page(
    [],
   div([class("main-container")],[\array(Arr),\style])
    ).


% check if array of integers
checkIntArr([H|T]):-
integer(H),checkIntArr(T).
checkIntArr([]).

% return the height of each bar
returnBarHeight(V,H):-
H is V*5+10.

%return the array bars of one array 
arrayBars([]) --> [].
arrayBars([H|T])-->
{returnBarHeight(H,H2)},
html(div([class("visual-array-bar"),
 style(
'height:'+H2+'px;'
)],H)),
arrayBars(T).

array([]) --> [].
array(Term)-->
{\+checkIntArr(Term),term_string(Term,NewTerm)},
html(div([],NewTerm)).
array(Term)-->
{checkIntArr(Term)},
html(div([class("visual-array-conatainer")],[\arrayBars(Term)])).

style-->
html({|html||
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
background-color:black;
color:white;
}
</style>


	     |}).


%the needed code for now ends here

% check if array of arrays of integers
checkArrofIntArrs([H|T]):-
checkIntArr(H),checkArrofIntArrs(T).
checkArrofIntArrs([]).


% return multiple arrays
arrays(_,[])-->[].

% if the input can be rendered that way 
arrays(L,Inp)-->
{Inp=[H|T],length(L,L1),length(Inp,L2),I is L1-L2},
html(
div([class("viusual-none-container"),id("div"+I)],\array(H))),
arrays(L,T).



%return html button
returnButton-->
html(button([class('reload-button'),onclick="onClickNext()",id("button1")],"clickhere")).

showArrs(Arrs,_Request):-
renderArrays(Arrs).

renderArrays(Arrs):-
  reply_html_page(
    [],
   div([class("main-container")],[\arrays(Arrs,Arrs),\style,\script,\returnButton])
    ).
	
returnArrays(X):-
http_handler(/, showArrs(X), []).

%/
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
