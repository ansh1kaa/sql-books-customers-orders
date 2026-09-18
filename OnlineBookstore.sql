-- Create Books table
CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Book_Title VARCHAR(255),
    Author VARCHAR(255),
    Genre VARCHAR(100),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT
);


-- Create Customers table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(255),
    Email VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100)
);


-- Create Orders table
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);

--importing data for books table
COPY BOOKS (
	BOOK_ID,
	BOOK_TITLE,
	AUTHOR,
	GENRE,
	PUBLISHED_YEAR,
	PRICE,
	STOCK
)
FROM
	'C:\Users\pande\Downloads\Books.csv' CSV HEADER;
-- importing data for customers table
COPY Customers(
    CUSTOMER_ID,
    CUSTOMER_NAME,
    EMAIL,
    CITY,
    COUNTRY
)
FROM 'C:\Users\pande\Downloads\Customers.csv'
CSV HEADER;
-- importing data for orders table
COPY Orders(
    ORDER_ID,
    CUSTOMER_ID,
    BOOK_ID,
    ORDER_DATE,
    QUANTITY,
    TOTAL_AMOUNT
)
FROM 'C:\Users\pande\Downloads\Orders.csv'
CSV HEADER;



select * from Books;

select * from customers;

select * from orders;





-- Q1. Retrieve all books in the "Fiction" genre
SELECT book_id , book_title , author ,genre from Books 
where genre = 'Fiction';

-- Q2. Find books published after the year 1950
SELECT book_id, book_title, author, published_year
FROM Books
WHERE published_year > 1950  ;


-- Q3. List all customers from Kanpur
Select customer_id , customer_name , city from customers
where city LIKE 'Kanpur' ;


-- Q4. Show orders placed in Aug 2026

SELECT order_id, book_id, order_date 
FROM Orders
WHERE order_date >='2026-08-01' AND order_date<= '2026-08-30';

-- Q5. Retrieve the total stock of books available
SELECT sum(stock) from Books;


-- Q6. Find the details of the most expensive book
SELECT book_id , book_title , price from books 
where price = (SELECT MAX(price) from books);
--or 
select * from books order by price desc
limit 1;

-- Q7. Show all customers who ordered more than 1 quantity of a book
SELECT order_id, customer_id, book_id, order_date ,quantity
FROM Orders
WHERE quantity >1;



-- Q8. Retrieve all orders where the total amount exceeds $20
 SELECT order_id,book_id, customer_id,total_amount  FROM Orders
WHERE total_amount > 20;


-- Q9. List all genres available in the Books table
SELECT distinct genre
FROM Books;



-- Q10. Find the book with the lowest stock

select book_id ,book_title from books
where stock= (select min(stock) from books);

--or 
select * from books order by stock asc limit 1 ;

--calculate the totel revenue generated from all orders :
SELECT sum(total_amount) AS revenue from orders ;

--ADVANCE QUERIES


-- Q1. Retrieve the total number of books sold for each genre
SELECT b.genre,
       SUM(o.quantity) AS total_books
FROM books b
JOIN orders o
    ON b.book_id = o.book_id
GROUP BY b.genre;

-- Q2. Find the average price of books in the "Fantasy" genre

select  AVG(price) AS Avg_price from Books 
where genre = 'Fantasy';


-- Q3. List customers who have placed at least 2 orders
select  * from Customers;

SELECT customer_id , COUNT(order_id) AS order_count
from orders group by customer_id HAVING COUNT(order_id)>= 2;

--or 

select o.customer_id , c.customer_name , COUNT(o.order_id) AS order_count
from orders o join customers c on o.customer_id = c.customer_id 
group by o.customer_id , c.customer_name having count(order_id)>= 2;


-- Q4. Find the most frequently ordered book
SELECT
	BOOK_ID,
	COUNT(ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS
GROUP BY
	BOOK_ID
ORDER BY
	ORDER_COUNT DESC
LIMIT 3;

-- if we want to add extra things from another linked table then we can 
select o.book_id , b.book_title , count(o.order_id) AS order_count
from orders o join books b on o.book_id = b.book_id group by o.book_id , b.book_title
order by order_count desc limit 4 ; 

-- Q5. Show the top 3 most expensive books of the "Fantasy" genre
select * from Books 
where genre = 'Fantasy'
order by price desc limit 3;


-- Q6. Retrieve the total quantity of books sold by each author

select b.author ,SUM( o.quantity ) AS total_book_count from 
orders o join books b on o.book_id = b.book_id group by b.author;

-- Q7. List the cities where customers who spent over $30 are located
SELECT distinct c.city , total_amount
FROM orders o 
join customers c ON o.customer_id = o.customer_id where o.total_amount>30 ;

-- Q8. Find the customer who spent the most on orders
select c.customer_id , c.customer_name , sum(o.total_amount) as total_spent
from orders o join customers c on o.customer_id = c.customer_id
group by c.customer_id , c.customer_name order by total_spent desc ;

-- Q9. Calculate the stock remaining after fulfilling all orders
SELECT 
    b.book_id,
    b.book_title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS order_quantity
FROM books b
LEFT JOIN orders o 
    ON b.book_id = o.book_id
GROUP BY b.book_id;