/*
Novasak, Ivan
2024-11-18
Southern New Hampshire University
IT 700: Capstone in Information Technology
New China Restaurant SQL Database Code - Querying with real menu data
*/

--  Drop (if exists), Create (if not exist), and Use the database.

DROP DATABASE IF EXISTS newchina_DB;
CREATE DATABASE IF NOT EXISTS newchina_DB;
USE newchina_DB;

-- Create the tables without foreign key references first

-- Create the Customers table

CREATE TABLE IF NOT EXISTS Customers (
	customerID INT NOT NULL AUTO_INCREMENT,
	surname VARCHAR(100) NOT NULL,
	givenName VARCHAR(100) NOT NULL,
        phoneNum VARCHAR(30) NOT NULL,
        streetAddress VARCHAR(100) NOT NULL,
        city VARCHAR(100) NOT NULL,
        st CHAR(2) NOT NULL,
        zip CHAR(5) NOT NULL,
        email VARCHAR(100),
	
    CONSTRAINT Customers_PK PRIMARY KEY (customerID)
);

-- Create the Employees table
CREATE TABLE IF NOT EXISTS Employees (
	employeeID INT NOT NULL AUTO_INCREMENT,
	surname VARCHAR(100) NOT NULL,
	givenName VARCHAR(100) NOT NULL,
        role VARCHAR(20) NOT NULL,
        phoneNum VARCHAR(30) NOT NULL,
        streetAddress VARCHAR(100) NOT NULL,
        city VARCHAR(100) NOT NULL,
        st CHAR(2) NOT NULL,
        zip CHAR(5) NOT NULL,
        email VARCHAR(100) NOT NULL,
        hireDate DATETIME NOT NULL,
	
    CONSTRAINT Employees_PK PRIMARY KEY (employeeID)
);

-- Create the MenuItems table
CREATE TABLE IF NOT EXISTS MenuItems (
	itemID VARCHAR(30) NOT NULL,
	itemName VARCHAR(100) NOT NULL,
	category VARCHAR(100) NOT NULL,
        spicy VARCHAR(10) NOT NULL,
        description VARCHAR(255) NOT NULL,
        price DECIMAL(8, 2) NOT NULL,

	
    CONSTRAINT MenuItems_PK PRIMARY KEY (itemID)
);

-- Now, create the tables with foreign key references

-- Create the CustomerReviews table
CREATE TABLE IF NOT EXISTS CustomerReviews (
	reviewID INT NOT NULL AUTO_INCREMENT,
        reviewText VARCHAR(255),
        rating INT NOT NULL CHECK (rating BETWEEN 1 AND 10),
        reviewDate DATETIME NOT NULL,
    
        customerID_FK INT NOT NULL, 

    CONSTRAINT CustomerReviews_PK PRIMARY KEY (reviewID),
    CONSTRAINT CustomerReviews_FK1 FOREIGN KEY (customerID_FK)
            REFERENCES Customers(customerID)
            ON DELETE CASCADE

);

-- Create the Drivers table
CREATE TABLE IF NOT EXISTS Drivers (
	driverID INT NOT NULL AUTO_INCREMENT,
        carYear INT NOT NULL,
        carMake VARCHAR(50) NOT NULL,
        carModel VARCHAR(50) NOT NULL,
        carColour VARCHAR(50) NOT NULL,
    
        employeeID_FK INT NOT NULL, 

    CONSTRAINT Drivers_PK PRIMARY KEY (driverID),
    CONSTRAINT Drivers_FK1 FOREIGN KEY (employeeID_FK)
            REFERENCES Employees(employeeID)
            ON DELETE CASCADE

);

-- Create the Orders table
CREATE TABLE IF NOT EXISTS Orders (
	orderID INT NOT NULL AUTO_INCREMENT,
        orderStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',
        totalPrice DECIMAL(8, 2) NOT NULL,
        deliveryAddress VARCHAR(100) NOT NULL,
        orderDate TIMESTAMP NOT NULL,

        customerID_FK INT DEFAULT NULL,
        driverID_FK INT DEFAULT NULL,

    CONSTRAINT Orders_PK PRIMARY KEY (orderID),

    CONSTRAINT Orders_FK1 FOREIGN KEY (customerID_FK)
            REFERENCES Customers(customerID)
            ON DELETE SET NULL,

    CONSTRAINT Orders_FK2 FOREIGN KEY (driverID_FK)
            REFERENCES Drivers(driverID)
            ON DELETE SET NULL    

);

-- Create the OrderItems table
CREATE TABLE IF NOT EXISTS OrderItems (
	orderItemID INT NOT NULL AUTO_INCREMENT,
        quantity INT NOT NULL CHECK (quantity > 0),
        price DECIMAL(8, 2) NOT NULL,
        
        orderID_FK INT NOT NULL,
        itemID_FK VARCHAR(30) NOT NULL,

        

    CONSTRAINT OrderItems_PK PRIMARY KEY (orderItemID),

    CONSTRAINT OrderItems_FK1 FOREIGN KEY (orderID_FK)
            REFERENCES Orders(orderID)
            ON DELETE CASCADE,

    CONSTRAINT OrderItems_FK2 FOREIGN KEY (itemID_FK)
            REFERENCES MenuItems(itemID)
            ON DELETE CASCADE    

);

-- Create the Payments table
CREATE TABLE IF NOT EXISTS Payments (
	paymentID INT NOT NULL AUTO_INCREMENT,
        paymentMethod ENUM('Cash', 'Credit Card', 'Debit Card', 'Online') NOT NULL,
        paymentDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        amount DECIMAL(8, 2) NOT NULL,
    
        orderID_FK INT NOT NULL, 

    CONSTRAINT Payments_PK PRIMARY KEY (paymentID),
    CONSTRAINT Payments_FK1 FOREIGN KEY (orderID_FK)
            REFERENCES Orders(orderID)
            ON DELETE CASCADE

);

-- Load menu data from NewChinaFullMenu.csv file using £ as the field delimiter and enclosed with ' and lines terminated by \n also ignore 1 row
-- Using manual table insertion sample data; to use the menu data from the CSV file instead, uncomment the next 6 lines and rerun this file up to the 'IGNORE 1 ROWS' line

LOAD DATA INFILE 'NewChinaFullMenu.csv'
INTO TABLE MenuItems
FIELDS TERMINATED BY '£'
ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Queries

-- 1. Display the average item price
SELECT AVG(price) AS 'Average Item Price'
FROM MenuItems;

-- 2. Display a list of all menu items that are not spicy (item ID, name, category, price) that also cost less than $20. Sort on category.
SELECT itemID AS 'Item ID', itemName AS 'Item Name', category AS 'Category', price AS 'Price'
FROM MenuItems
WHERE spicy = 'FALSE' AND price < 20.00
ORDER BY category;

-- 3. Display the number of items that are spicy
SELECT COUNT(*) AS 'Number of Spicy Items'
FROM MenuItems
WHERE spicy = 'TRUE';

-- 4. Display the most expensive item (ID, name, category) and its price
SELECT itemID AS 'Item ID', itemName AS 'Item Name', category AS 'Category', price AS 'Price'
FROM MenuItems
WHERE price = (SELECT MAX(price) FROM MenuItems);

