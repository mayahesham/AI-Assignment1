% Predicate to find cycles on the board
find_cycle(Board) :-
    length(Board, NRows),
    length(Board, NCols), 
    between(0, NRows, X), 
    between(0, NCols, Y), 
    getColor([X , Y] , Board , Color),
    search(Board, [X,Y], [X,Y] , [[X,Y]] , Color),
    fail. 

% Depth-first search predicate to find cycles
search(Board, Start, Current, Visited, Color) :-
    adjacent(Current , Next), 
    checkCell(Next , Board), 
    (
        Next == Start ,
        length(Visited, L),
        L >= 4 -> 
        reverse(Visited, Cycle),
        format("~w cycle found: ~w~n", [Color, [Cycle, Start]]) 
    ;
        \+ member(Next, Visited),
        getColor(Next , Board , C1), 
        Color == C1, 
        search(Board, Start, Next, [Next | Visited], Color) % Continue searching recursively
    ).

% Predicate to get the color of a cell
getColor([X,Y] , Board ,Color):-
   nth0(X, Board, Row),
   nth0(Y, Row, Color).

% Predicate to check If a cell is within the board boundaries
checkCell([X,Y] , Board):-
    length(Board, NRows),
    length(Board, NCols),
    X >= 0, X =< NRows,
    Y >= 0, Y =< NCols.

% Predicate to define adjacent cells
adjacent([X,Y], [X1,Y]) :- X1 is X+1. % move right
adjacent([X,Y], [X,Y1]) :- Y1 is Y+1. % move down
adjacent([X,Y], [X1,Y]) :- X1 is X-1, X1 >= 0. % move left
adjacent([X,Y], [X,Y1]) :- Y1 is Y-1, Y1 >= 0. % move up