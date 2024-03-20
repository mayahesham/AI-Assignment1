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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate5

orderPrice([], 0).
orderPrice([H|T], Total):-
    item(H, _, Price),
    orderPrice(T, SubTotal),
    Total is SubTotal + Price.

calcPriceOfOrder(CustomerName, OrderID, TotalPrice):-
    customer(CustomerID, CustomerName),
    order(CustomerID, OrderID, Items),
    orderPrice(Items, TotalPrice).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate6
isBoyCott(ItemName):-
    alternative(ItemName,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate7
whyToBoycott(ItemName, Justification) :-
    item(ItemName, CompanyName,_),
    boycott_company(CompanyName, Justification).

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate10
%lesa ha test b3d ma al replace tt3ml

calcPriceAfterReplacingBoycottItemsFromAnOrder(CustomerName, OrderID, NewItems, TotalPrice):-
    replaceBoycottItemsFromAnOrder(CustomerName, OrderID, NewItems),
    orderPrice(NewItems,TotalPrice).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%predicate11
getTheDifferenceInPriceBetweenItemAndAlternative(ItemName, Alternative, DiffPrice):-
    alternative(ItemName,Alternative),
    item(ItemName,_,P),
    item(Alternative,_,A),
    DiffPrice is P-A.
