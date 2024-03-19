:-consult(data).
getCustomerID(CustomerName, CustomerID) :-
    customer(CustomerID, CustomerName).
%predicate1
list_orders(CustomerName, Orders) :-
    getCustomerID(CustomerName, CustomerID),
    list_ordersID(CustomerID, 1, Orders).

list_ordersID(CustomerID, N,[Head|Tail]) :-
    order(CustomerID, N, OrderItems),
    Head = order(CustomerID, N, OrderItems),
    NextN is N + 1,
    list_ordersID(CustomerID, NextN, Tail).
list_ordersID(_, _, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate2
countOrdersOfCustomer(CustomerName, Count) :-
    getCustomerID(CustomerName, CustomerID),
    countOrdersOfCustomerID(CustomerID, 1, Count).

countOrdersOfCustomerID(CustomerID, Acc, Count) :-
    order(CustomerID, Acc, _),
    NewAcc is Acc + 1,
    countOrdersOfCustomerID(CustomerID, NewAcc, Count).

countOrdersOfCustomerID(_, Count, Res) :-
  Res is Count - 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate3
getItemsInOrderById(CustomerName, OrderID, Items) :-
    getCustomerID(CustomerName, CustomerID),
    listItems(CustomerID, OrderID, Items).

listItems(CustomerID, OrderID, Items) :-
    order(CustomerID, OrderID, Items).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate4
getNumOfItems(CustomerName, OrderID, Count) :-
    getCustomerID(CustomerName, CustomerID),
    order(CustomerID, OrderID, Items),
    countItems(Items, Count).

countItems([_|Tail], Count):-
    countItems(Tail, Count1),
    Count is Count1 + 1.
countItems([], 0).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate6
isBoycott(Name):-
 alternative(Name,_).
