/*
Novasak, Ivan
2024-11-18
Southern New Hampshire University
IT 700: Capstone in Information Technology
New China Restaurant SQL Database Code - Querying with sample data
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

-- Sample table insertions to test queries

-- Customers
INSERT INTO Customers (surname, givenName, phoneNum, streetAddress, city, st, zip, email)
VALUES
('Smith', 'John', '555-1234', '123 Elm St', 'Springfield', 'IL', '62701', 'john.smith@example.com'),
('Johnson', 'Emily', '555-5678', '456 Oak St', 'Springfield', 'IL', '62702', 'emily.johnson@example.com'),
('Williams', 'Chris', '555-8765', '789 Pine St', 'Springfield', 'IL', '62703', 'chris.williams@example.com'),
('Brown', 'Sarah', '555-3456', '101 Maple St', 'Springfield', 'IL', '62704', 'sarah.brown@example.com'),
('Davis', 'Michael', '555-6789', '202 Birch St', 'Springfield', 'IL', '62705', 'michael.davis@example.com'),
('Miller', 'Anna', '555-2345', '303 Cedar St', 'Springfield', 'IL', '62706', 'anna.miller@example.com'),
('Wilson', 'Tom', '555-1122', '404 Walnut St', 'Springfield', 'IL', '62707', 'tom.wilson@example.com'),
('Moore', 'Jessica', '555-9988', '505 Oakwood Ave', 'Springfield', 'IL', '62708', 'jessica.moore@example.com');

-- Employees
INSERT INTO Employees (surname, givenName, role, phoneNum, streetAddress, city, st, zip, email, hireDate)
VALUES
('Brown', 'Michael', 'Manager', '555-2345', '789 Maple St', 'Springfield', 'IL', '62703', 'michael.brown@example.com', '2024-05-01 08:00:00'),
('Davis', 'Sarah', 'Chef', '555-6789', '101 Pine St', 'Springfield', 'IL', '62704', 'sarah.davis@example.com', '2024-06-15 08:00:00'),
('Taylor', 'James', 'Driver', '555-1234', '202 Birch St', 'Springfield', 'IL', '62705', 'james.taylor@example.com', '2024-07-10 08:00:00');

-- MenuItems
INSERT INTO MenuItems (itemID, itemName, category, spicy, description, price)
VALUES
('M001', 'Sweet and Sour Chicken', 'Main Dish', 'No', 'Crispy chicken in a tangy sweet and sour sauce', 9.99),
('M002', 'Kung Pao Chicken', 'Main Dish', 'Yes', 'Spicy chicken with peanuts and vegetables', 10.99),
('M003', 'Fried Rice', 'Side Dish', 'No', 'Stir-fried rice with vegetables and eggs', 4.99),
('M004', 'Egg Rolls', 'Appetizer', 'No', 'Crispy rolls filled with vegetables and meat', 3.99),
('M005', 'Hot and Sour Soup', 'Soup', 'Yes', 'A spicy and tangy soup with mushrooms and tofu', 5.99),
('M006', 'Beef with Broccoli', 'Main Dish', 'No', 'Tender beef with fresh broccoli in a savory sauce', 12.99),
('M007', 'General Tso\'s Chicken', 'Main Dish', 'Yes', 'Sweet and spicy battered chicken with vegetables', 11.99),
('M008', 'Orange Chicken', 'Main Dish', 'No', 'Crispy chicken with a tangy orange glaze', 10.49);

-- CustomerReviews
INSERT INTO CustomerReviews (reviewText, rating, reviewDate, customerID_FK)
VALUES
('Delicious food, would order again!', 9, '2024-11-10 18:30:00', 1),
('Very spicy, but tasty!', 7, '2024-11-11 12:00:00', 2),
('Great flavor and good portions!', 8, '2024-11-12 14:30:00', 3),
('Fast delivery, food was hot!', 9, '2024-11-13 11:00:00', 4),
('Good experience, will reorder.', 8, '2024-11-14 16:45:00', 5),
('The soup was amazing!', 10, '2024-11-15 18:00:00', 6),
('Loved the orange chicken, very crispy.', 9, '2024-11-16 13:00:00', 7),
('Very good service, delicious food!', 9, '2024-11-17 19:00:00', 8);

-- Drivers
INSERT INTO Drivers (carYear, carMake, carModel, carColour, employeeID_FK)
VALUES
(2020, 'Toyota', 'Corolla', 'Blue', 3),
(2021, 'Honda', 'Civic', 'Red', 2);

-- Orders
INSERT INTO Orders (orderStatus, totalPrice, deliveryAddress, orderDate, customerID_FK, driverID_FK)
VALUES
('Pending', 20.97, '123 Elm St, Springfield, IL, 62701', '2024-11-10 18:30:00', 1, 1),
('Completed', 21.98, '456 Oak St, Springfield, IL, 62702', '2024-11-11 12:00:00', 2, 2),
('Pending', 35.97, '789 Pine St, Springfield, IL, 62703', '2024-11-12 14:30:00', 3, 1),
('Completed', 50.96, '101 Maple St, Springfield, IL, 62704', '2024-11-13 11:00:00', 4, 2),
('Pending', 33.98, '202 Birch St, Springfield, IL, 62705', '2024-11-14 16:45:00', 5, 1),
('Completed', 41.95, '303 Cedar St, Springfield, IL, 62706', '2024-11-15 18:00:00', 6, 2),
('Pending', 29.48, '404 Walnut St, Springfield, IL, 62707', '2024-11-16 13:00:00', 7, 1),
('Completed', 42.97, '505 Oakwood Ave, Springfield, IL, 62708', '2024-11-17 19:00:00', 8, 2);

-- OrderItems
INSERT INTO OrderItems (quantity, price, orderID_FK, itemID_FK)
VALUES
(1, 9.99, 1, 'M001'),
(1, 10.99, 1, 'M002'),
(1, 9.99, 2, 'M003'),
(2, 3.99, 2, 'M004'),
(1, 5.99, 3, 'M005'),
(2, 12.99, 4, 'M006'),
(1, 11.99, 5, 'M007'),
(1, 10.49, 6, 'M008'),
(1, 9.99, 7, 'M001'),
(1, 4.99, 7, 'M003'),
(1, 10.99, 8, 'M002'),
(1, 5.99, 8, 'M005');

-- Payments
INSERT INTO Payments (paymentMethod, paymentDate, amount, orderID_FK)
VALUES
('Credit Card', '2024-11-10 19:00:00', 20.97, 1),
('Cash', '2024-11-11 12:15:00', 21.98, 2),
('Credit Card', '2024-11-12 15:00:00', 35.97, 3),
('Cash', '2024-11-13 12:00:00', 50.96, 4),
('Credit Card', '2024-11-14 17:00:00', 33.98, 5),
('Debit Card', '2024-11-15 19:30:00', 41.95, 6),
('Cash', '2024-11-16 14:00:00', 29.48, 7),
('Credit Card', '2024-11-17 20:00:00', 42.97, 8);

-- Queries

-- 1. Display a listing of all completed orders including the customer’s name, delivery address, phone number, and total price
SELECT surname AS 'Customer Surname', givenName AS 'Customer Given Name', deliveryAddress AS 'Delivery Address', phoneNum AS 'Customer Phone Nr', totalPrice AS 'Total Price'
FROM Customers
INNER JOIN Orders ON Orders.customerID_FK = Customers.customerID
WHERE orderStatus = 'Completed';

-- 2. Display the customer reviews showing the name of the customer, rating, review text, and review date
SELECT surname AS 'Customer Surname', givenName AS 'Customer Given Name', rating AS 'Review Rating', reviewDate AS 'Review Date', reviewText AS 'Review'
FROM CustomerReviews
INNER JOIN Customers ON Customers.CustomerID = CustomerReviews.CustomerID_FK;

-- 3. Display the average total order amount
SELECT AVG(totalPrice) AS 'Average Order Total'
FROM Orders;

-- 4. Display the names, categories, and prices of the items for order ID #1
SELECT itemName AS 'Item Name', category AS 'Category', menuItems.price AS 'Price'
FROM MenuItems
INNER JOIN OrderItems ON OrderItems.itemID_FK = menuItems.itemID
WHERE orderID_FK = 1;

-- 5. Write a query to add a new order to the database. Display the results.

-- 5a. Insert a new customer to the database
INSERT INTO Customers (surname, givenName, phoneNum, streetAddress, city, st, zip, email)
VALUES ('Doe', 'Jane', '555-0000', '789 Cypress St', 'Springfield', 'IL', '62709', 'jane.doe@example.com');

-- 5b. Add the new order data to the Orders table
INSERT INTO Orders (orderStatus, totalPrice, deliveryAddress, orderDate, customerID_FK, driverID_FK)
VALUES ('Pending', 25.97, '789 Cypress St, Springfield, IL, 62709', NOW(), LAST_INSERT_ID(), 1);

-- 5c. Insert the order items
INSERT INTO OrderItems (quantity, price, orderID_FK, itemID_FK)
VALUES
(1, 9.99, LAST_INSERT_ID(), 'M001'),
(1, 10.99, LAST_INSERT_ID(), 'M002'),
(1, 4.99, LAST_INSERT_ID(), 'M003');

-- 5d. Insert payment data
INSERT INTO Payments (paymentMethod, paymentDate, amount, orderID_FK)
VALUES ('Credit Card', NOW(), 25.97, (SELECT MAX(orderID) FROM Orders));
