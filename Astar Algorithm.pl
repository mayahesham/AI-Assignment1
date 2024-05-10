puzzle([
    [red, red, yellow, yellow],
    [red, blue, red, red],
    [red, red, red, yellow],
    [blue, red, blue, yellow]
]).

% Define colors
color(red).
color(blue).
color(yellow).

same_color((R1, C1), (R2, C2),Puzzle) :-
    nth0(R1, Puzzle, Row1),
    nth0(R2, Puzzle, Row2),
    nth0(C1, Row1, Color1),
    nth0(C2, Row2, Color2),
    Color1 = Color2.

left((R,C), (R,NewC),Puzzle):-
     NewC is C - 1,
     valid(R, NewC,Puzzle),
     same_color((R,C), (R,NewC),Puzzle).

right((R,C), (R,NewC),Puzzle):-
     NewC is C + 1,
     valid(R, NewC,Puzzle), same_color((R,C), (R,NewC),Puzzle).

up((R,C), (NewR,C),Puzzle):-
     NewR is R - 1,
     valid(NewR, C,Puzzle), same_color((R,C), (NewR,C),Puzzle).

down((R,C), (NewR,C),Puzzle):-
     NewR is R + 1,
     valid(NewR, C,Puzzle), same_color((R,C), (NewR,C),Puzzle).
valid(R, C,Puzzle) :-
    length(Puzzle, Height),
    nth0(R, Puzzle, Row),
    length(Row, Width),
    R >= 0,
    R < Height,
    C >= 0,
    C < Width.

move((R,C), (NewR,NewC), 1,Puzzle) :-
    left((R,C), (NewR,NewC),Puzzle);right((R,C), (NewR,NewC),Puzzle);
    up((R,C), (NewR,NewC),Puzzle);down((R,C), (NewR,NewC),Puzzle).

% Define the heuristic function
heuristic((R,C), (GR,GC), H) :-
    H is abs(GR-R) + abs(GC-C).


getNextState(State, Next, G, Goal, Open, Closed,Puzzle) :-
    [RCState, _, _, _, _] = State,
    move(RCState, RC, 1,Puzzle),
    heuristic(RC, Goal, NewH),
    NewG is G + 1,
    NewF is NewG + NewH,
    Next = [RC, NewG, NewH, NewF, RCState],
    ( not(member([RC,_,_,_,_], Open)) ; memberButBetter(RC, Open, NewF) ),
    ( not(member([RC,_,_,_,_], Closed)) ; memberButBetter(RC, Closed, NewF)).
   % Include current state as the parent


memberButBetter(Next, List, NewF):-
    findall(F, (member([Next, _, _, F,_], List)), Numbers),
    (Numbers = [] -> MinOldF is NewF ; min_list(Numbers, MinOldF)),
     MinOldF > NewF.


getAllValidChildren(BestState, Open, Close, Goal, NewOpen, NewClose,Puzzle) :-
    delete(Open, BestState, NewOpenTemp),
    BestState = [_, G, _, _, _], % Extract parent from the best state
    findall(Next, (getNextState(BestState, Next, G, Goal, Open, Close,Puzzle)), ChildrenToAdd),
    append(ChildrenToAdd, NewOpenTemp, NewOpen),
    append(Close, [BestState], NewClose).


getBestState(OpenList, BestState) :-
    map_list_to_pairs(extract_f, OpenList, NodesWithF),
    keysort(NodesWithF, SortedNodesWithF),
    pairs_values(SortedNodesWithF, SortedOpen),
    SortedOpen = [BestState|_].

extract_f([(_,_), _, _, F,(_,_)], F).



printSolution([State,_, _, _, Goal], _):-
     State = Goal.

printSolution([State, _, _, _, Parent], Closed):-
    member([Parent, PrevG, Ph, Pf, GrandParent], Closed),
    printSolution([Parent, PrevG, Ph, Pf, GrandParent], Closed),
    write(State), nl.

print(CurrentState,Closed):-
     [H|_] = Closed, [RC,_,_,_,_] = H,
    write(RC),nl,
    printSolution(CurrentState,Closed),
    !.

search(Open, Closed, Goal,_) :-
    getBestState(Open, CurrentState),
    CurrentState = [Goal,_,_,_,_],
    write("Search is complete!"), nl,
    print(CurrentState,Closed).

search([],_, _,_) :-
    write('No solution found!'), nl.

search(Open, Closed, Goal,Puzzle) :-
    getBestState(Open, BestState),
    getAllValidChildren(BestState, Open, Closed, Goal, NewOpen, NewClose,Puzzle),
    search(NewOpen, NewClose, Goal,Puzzle).


test_search(Puzzle):-
    Open = [[(0,0), 0, 4, 4,(0,0)]],
    search(Open,[],(1,3),Puzzle).
