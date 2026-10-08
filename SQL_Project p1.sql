DROP TABLE IF EXISTS books;
CREATE TABLE `books` (
  `Book_ID` serial PRIMARY KEY, 
  `Title` varchar(100),
  `Author` varchar(100),
  `Genre` varchar(50),
  `Published_Year` int,
  `Price` double,
  `Stock` int
);

DROP TABLE IF EXISTS customers;
CREATE TABLE `customers` (
  `Customer_ID` serial 	PRIMARY KEY,
  `Name` varchar(100),
  `Email` varchar(100),
  `Phone` varchar(15),
  `City` varchar(50),
  `Country` varchar(150) 
);

DROP TABLE IF EXISTS orders;
CREATE TABLE `orders` (
  `Order_ID` SERIAL PRIMARY KEY,
  `Customer_ID` int REFERENCES customers(customer_id),
  `Book_ID` int REFERENCES books(book_id),
  `Order_Date` date,
  `Quantity` int,
  `Total_Amount` double
);

select * from sql_projects.books;

select * from sql_projects.customers;

select * from sql_projects.orders;

-- Basic Querries:

-- 1) Retrieve all books in the "Fiction" genre
select * from sql_projects.books
where genre = 'Fiction';

-- 2) Find books published after the year 1950
select * from sql_projects.books
where Published_Year > 1950;

-- 3) List all customers from the Canada
select * from sql_projects.customers
where country = 'Canada';

-- 4) Show orders placed in November 2023
select * from sql_projects.orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available
select sum(Stock) as Total_Stock 
from sql_projects.books;

-- 6) Find the details of the most expensive book
select * from sql_projects.books
order by Price desc 
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
select * from sql_projects.orders
where Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20
select * from sql_projects.orders
where Total_Amount > 20;

-- 9) List all genres available in the Books table
select  distinct genre from sql_projects.books;

-- 10) Find the book with the lowest stock
select * from sql_projects.books
order by Stock
 limit 1;

-- 11) Calculate the total revenue generated from all orders
select sum(Total_Amount) as Total_Revenue from sql_projects.orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre
select b.Genre, sum(o.Quantity) as Total_Books_Sold 
from sql_projects.books b 
join sql_projects.orders o 
on b.Book_ID = o.Book_ID
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre
select  avg(Price) as Avg_Price
from sql_projects.books 
where Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders
select o.Customer_ID, c.Name, count(o.Order_ID) as Order_Count
from sql_projects.customers c
join sql_projects.orders o 
on c.Customer_ID = o.Customer_ID
group by o.Customer_ID, c.name
having count(o.Order_ID) >= 2;

-- 4) Find the most frequently ordered book
select o.Book_ID, count(o.Order_ID) as Order_Count, b.Title
from sql_projects.orders o 
join sql_projects.books b 
on o.Book_ID = b.Book_ID 
group by o.Book_ID, b.Title 
order by  count(o.Order_ID) desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre
select * from sql_projects.books 
where Genre = 'Fantasy'
order by Price desc
limit 3 ;

-- 6) Retrieve the total quantity of books sold by each author
select b.Author, sum(o.Quantity) as Total_Quantity_Sold
from sql_projects.books b
join sql_projects.orders o
on b.Book_ID = o.Book_ID
group by b.Author;

-- 7) List the cities where customers who spent over $30 are located
select distinct c.City , o.Total_Amount
from sql_projects.orders o
join sql_projects.customers c
on o.Customer_ID = c.Customer_ID
where o.Total_Amount > 30;

-- 8) Find the customer who spent the most on orders
select c.Customer_ID, c.Name, sum(o.Total_Amount) as Total_Spent
from sql_projects.customers c
join sql_projects.orders o 
on c.Customer_ID = o.Customer_ID
group by c.Customer_ID, c.Name
order by Total_Spent desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM sql_projects.books b
LEFT JOIN sql_projects.orders o
 ON b.book_id = o.book_id
GROUP BY b.book_id 
ORDER BY b.book_id;