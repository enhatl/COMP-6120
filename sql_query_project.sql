CREATE TABLE Book(
	BookID char(1),
    Title char(5),
    UnitPrice decimal(4,2),
    Author char(7),
    Quantity varchar(2),
    SupplierID char(1),
    SubjectID char(1),
    PRIMARY KEY (BookID)
);
CREATE TABLE Customer(
	CustomerID char(1),
    LastName char(9),
    FirstName char(10),
    Phone char(12),
    PRIMARY KEY (CustomerID)
);
CREATE TABLE Employee(
	EmployeeID char(1),
    LastName char(9),
    FirstName char(10),
    PRIMARY KEY (EmployeeID)
);
CREATE TABLE Orderr(
	OrderID char(1),
    CustomerID char(1),
    EmployeeID char(1),
    OrderDate date,
    ShippedDate date,
    ShipperID char(1),
    PRIMARY KEY (OrderID)
);
CREATE TABLE Order_Detail(
	BookID char(1),
    OrderID char(1),
    Quantity char(1)
);
CREATE TABLE Shipper(
	ShipperID char(1),
    ShipperName char(8),
    PRIMARY KEY (ShipperID)
);
CREATE TABLE Subjectt(
	SubjectID char(1),
    CategoryName char(9),
    PRIMARY KEY (SubjectID)
);
CREATE TABLE Supplier(
	SupplierID char(1),
    CompanyName char(9),
    ContactLastName char(8),
    ContactFirstName char(8),
    Phone char(12),
    PRIMARY KEY (SupplierID)
);

/*************************************** 
				Queries 
****************************************/

/* Show the subject names of books supplied by 'supplier2' */
SELECT Sub.CategoryName
FROM Book B, Subjectt Sub, Supplier Supp
WHERE B.SupplierID = Supp.SupplierID AND B.SubjectID = Sub.SubjectID AND Supp.CompanyName = 'supplier2';

/* Show the name and price of the most expensive book supplied by 'supplier3' */
SELECT B.Title, B.UnitPrice
FROM Book B, Supplier Supp
WHERE B.SupplierID = Supp.SupplierID AND B.UnitPrice = (select MAX(B2.UnitPrice) 
	From Book B2, Supplier Supp2 
	Where B2.SupplierID = Supp2.SupplierID AND B2.UnitPrice AND Supp2.CompanyName = 'supplier3');
    
/* Show the unique names of all books ordered by 'lastname1 firstname1' */
SELECT Distinct B.Title
FROM Book B, Orderr O, Order_Detail OD, Customer C
WHERE B.BookID = OD.BookID AND OD.OrderID = O.OrderID AND O.CustomerID = C.CustomerID AND C.LastName = 'lastname1' AND C.FirstName = 'firstname1';

/* Show the title of books which have more than 10 units in stock */
SELECT B.Title 
FROM Book B 
WHERE B.Quantity > 10;

/* Show the total price *lastname1 firstname1* has paid for the books. */
SELECT SUM(OD.Quantity*B.UnitPrice) 
FROM Book B, Order_Detail OD, Orderr O, Customer C 
WHERE OD.BookID = B.BookID AND O.OrderID = OD.OrderID AND C.CustomerID = O.CustomerID AND C.FirstName = "firstname1" AND C.LastName="lastname1";

/* Show the names of the customers who have paid less than $80 in totals. */
SELECT FirstName, LastName from (SELECT C.FirstName as FirstName, C.LastName as LastName, SUM(OD.Quantity*B.UnitPrice) AS PurchaseTotal 
FROM Book B, Order_Detail OD, Orderr O, Customer C 
WHERE OD.BookID = B.BookID AND O.OrderID = OD.OrderID AND C.CustomerID = O.CustomerID GROUP BY C.CustomerID HAVING PurchaseTotal < 80) as temporary;

/* Show the name of books supplied by *supplier2*. */
SELECT B.Title 
FROM Book B, Supplier Supp 
WHERE B.SupplierID = Supp.SupplierID AND Supp.CompanyName = 'supplier2';

/* Show the total price each customer paid and their names.  List the result in descending price. */
SELECT C.FirstName, C.LastName, SUM(OD.Quantity*B.UnitPrice) AS PurchaseTotal 
FROM Book B, Order_Detail OD, Orderr O, Customer C  
WHERE OD.BookID = B.BookID AND O.OrderID = OD.OrderID AND C.CustomerID = O.CustomerID GROUP BY C.CustomerID ORDER BY PurchaseTotal DESC;

/* Show the names of all the books shipped on 08/04/2016 and their shippers' names. */
SELECT B.Title, Shp.ShipperName 
FROM Book B, Shipper Shp, Orderr O, Order_Detail OD 
WHERE B.BookID = OD.BookID AND OD.OrderID = O.OrderID AND O.ShipperID = Shp.ShipperID AND O.ShippedDate = "8/4/2016";

/* Show the unique names of all the books *lastname1 firstname1* and *lastname4 firstname4* *both* ordered. */
SELECT Distinct B.Title 
FROM Book B, Orderr O, Order_Detail OD, Customer C 
WHERE B.BookID = OD.BookID AND OD.OrderID = O.OrderID AND O.CustomerID = C.CustomerID AND C.FirstName='firstname1' AND C.LastName='lastname1' AND B.BookID in (SELECT B1.bookID 
	FROM Book B1, Orderr O1, Order_Detail OD1, Customer C1 
    WHERE B1.BookID = OD1.BookID AND OD1.OrderID = O1.OrderID AND O1.CustomerID = C1.CustomerID AND C1.FirstName='firstname4' AND C1.LastName='lastname4');

/* Show the names of all the books *lastname6 firstname6* was responsible for. */
SELECT B.Title 
FROM Book B, Employee E, Orderr O, Order_Detail OD 
WHERE OD.BookID = B.BookID AND OD.OrderID = O.OrderID AND O.EmployeeID = E.EmployeeID AND E.FirstName = 'firstname6' AND LastName='lastname6';

/* Show the names of all the ordered books and their total quantities.  List the result in ascending quantity. */
SELECT B.Title, OD.Quantity 
FROM Book B, Order_Detail OD 
WHERE B.BookID = OD.BookID ORDER BY OD.Quantity ASC;

/* Show the names of the customers who ordered at least 2 books. */
SELECT FirstName, LastName from (select C.FirstName as FirstName, C.LastName as LastName, SUM(OD.Quantity) AS TotalBooksOrdered 
FROM Customer C, Orderr O, Order_Detail OD 
WHERE OD.OrderID = O.orderID AND O.CustomerID = C.CustomerID GROUP BY C.CustomerID HAVING TotalBooksOrdered >= 2) as Temp;

/* Show the name of the customers who have ordered at least a book in *category3* or *category4* and the book names. */
SELECT C.FirstName, C.LastName, B.Title 
FROM Customer C, Subjectt Sub, Book B, Orderr O, Order_Detail OD 
WHERE O.OrderID = OD.OrderID AND B.BookID = OD.BookID AND O.CustomerID = C.CustomerID AND B.SubjectID = Sub.SubjectID AND (Sub.CategoryName = 'category3' OR Sub.CategoryName = 'category4');

/* Show the name of the customer who has ordered at least one book written by *author1*. */
SELECT C.FirstName, C.LastName 
FROM Orderr O, Order_Detail OD, Customer C, Book B
WHERE O.OrderID = OD.OrderID AND O.CustomerID = C.CustomerID AND OD.BookID = B.BookID AND B.Author = 'author1';

/* Show the name and total sale (price of orders) of each employee. */
SELECT E.FirstName, E.LastName, SUM(B.UnitPrice * OD.Quantity) AS PriceOfOrder 
FROM Book B, Employee E, Orderr O, Order_Detail OD 
WHERE O.OrderID = OD.OrderID AND B.BookID = OD.BookID AND O.EmployeeID = E.EmployeeID GROUP BY E.EmployeeID;

/* Show the book names and their respective quantities for open orders (the orders which have not been shipped) at midnight 08/04/2016. */
SELECT B.Title, sum(OD.Quantity) as Total 
FROM Book B, Orderr O, Order_Detail OD  
WHERE B.BookID = OD.BookID AND O.OrderID = OD.OrderID AND (O.ShippedDate is null or O.ShippedDate > '8/4/2016') group by B.Title;

/* Show the names of customers who have ordered more than 1 book and the corresponding quantities.  List the result in the descending quantity. */
SELECT C.FirstName, C.LastName, SUM(OD.Quantity) AS TotalBooksOrdered 
FROM Customer C, Orderr O, Order_Detail OD 
WHERE OD.OrderID = O.orderID AND O.CustomerID = C.CustomerID GROUP BY C.CustomerID HAVING TotalBooksOrdered > 1 ORDER BY TotalBooksOrdered DESC;

/* Show the names of customers who have ordered more than 3 books and their respective telephone numbers. */
SELECT C.FirstName, C.LastName, C.Phone, SUM(OD.Quantity) AS TotalBooksOrdered 
FROM Customer C, Orderr O, Order_Detail OD 
WHERE OD.OrderID = O.orderID AND O.CustomerID = C.CustomerID GROUP BY C.CustomerID HAVING TotalBooksOrdered >3;
