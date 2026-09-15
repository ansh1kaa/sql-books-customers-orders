# 📚 SQL Bookstore Analysis Project

## 📌 Project Overview

This project is a SQL-based analysis of a bookstore database containing information about books, customers, and orders.

The goal of this project is to practice SQL concepts by answering real-world business questions using multiple related tables.

## 🗂️ Dataset

The project contains three tables:

### 1. Books
Contains information about books available in the bookstore.

- Book_ID
- Book_Title
- Author
- Genre
- Published_Year
- Price
- Stock

### 2. Customers
Contains information about bookstore customers.

- Customer_ID
- Customer_Name
- Email
- City
- Country

### 3. Orders
Contains information about customer orders.

- Order_ID
- Customer_ID
- Book_ID
- Order_Date
- Quantity
- Total_Amount

## 🔗 Table Relationships

```text
Books
  |
  | Book_ID
  |
Orders
  |
  | Customer_ID
  |
Customers 
