/*====================Creating Bike Store Database====================*/
CREATE DATABASE BikeStores;

USE BikeStores;

/*====================Creating Database Schemas====================*/
CREATE SCHEMA Sales;
CREATE SCHEMA Production;

/*====================Creating Tables====================*/

CREATE TABLE Sales.Stores (
	Store_ID INT IDENTITY (1,1) PRIMARY KEY,
	Store_Name VARCHAR (255) NOT NULL,
	Phone VARCHAR (25),
	Email VARCHAR (255),
	Street VARCHAR (255),
	City VARCHAR (255),
	State VARCHAR (255),
	Zip_Code VARCHAR (25)
);

CREATE TABLE Sales.Staffs (
	Staff_ID INT IDENTITY (1,1) PRIMARY KEY,
	First_Name VARCHAR (255) NOT NULL,
	Last_Name VARCHAR (255) NOT NULL,
	Email VARCHAR (255) NOT NULL UNIQUE,
	Phone VARCHAR (25) NOT NULL,
	Active BIT NOT NULL,
	Store_ID INT NOT NULL,
	Manager_ID INT,
	FOREIGN KEY (Store_ID) REFERENCES Sales.Stores (Store_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Manager_ID) REFERENCES Sales.Staffs (Staff_ID)
	ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Sales.Customers (
	Customer_ID INT IDENTITY (1,1) PRIMARY KEY,
	First_Name VARCHAR (255) NOT NULL,
	Last_Name VARCHAR (255) NOT NULL,
	Phone VARCHAR (25),
	Email VARCHAR (255) NOT NULL,
	Street VARCHAR (255),
	City VARCHAR (255),
	State VARCHAR (255),
	Zip_Code VARCHAR (25)
);

CREATE TABLE Sales.Orders (
	Order_ID INT IDENTITY (1,1) PRIMARY KEY,
	Customer_ID INT NOT NULL,
	Order_Status TINYINT NOT NULL,
	Order_Date DATE NOT NULL,
	Required_Date DATE NOT NULL,
	Shipped_date DATE,
	Store_ID INT NOT NULL,
	Staff_ID INT NOT NULL,
	FOREIGN KEY (Customer_ID) REFERENCES Sales.Customers (Customer_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Staff_ID) REFERENCES Sales.Staffs (Staff_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Production.Categories (
	Category_ID INT IDENTITY (1,1) PRIMARY KEY,
	Category_Name VARCHAR (255) NOT NULL
);

CREATE TABLE Production.Brands (
	Brand_ID INT IDENTITY (1,1) PRIMARY KEY,
	Brand_Name VARCHAR (255) NOT NULL
);

CREATE TABLE Production.Products (
	Product_ID INT IDENTITY (1,1) PRIMARY KEY,
	Product_Name VARCHAR (255) NOT NULL,
	Brand_ID INT NOT NULL,
	Category_ID INT NOT NULL,
	Model_Year SMALLINT NOT NULL,
	List_Price DECIMAL (10,2) NOT NULL,
	FOREIGN KEY (Brand_ID) REFERENCES Production.Brands (Brand_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Category_ID) REFERENCES Production.Categories (Category_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Production.Stocks (
	Store_ID INT,
	Product_ID INT,
	Quantity INT NOT NULL,
	PRIMARY KEY (Store_ID, Product_ID),
	FOREIGN KEY (Store_ID) REFERENCES Sales.Stores (Store_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Product_ID) REFERENCES Production.Products (Product_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sales.Order_Items (
	Order_ID INT,
	Item_ID INT,
	Product_ID INT NOT NULL,
	Quantity INT NOT NULL,
	List_Price DECIMAL (10,2) NOT NULL,
	Discount DECIMAL (10,2) NOT NULL DEFAULT 0,
	PRIMARY KEY (Order_ID, Item_ID),
	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) 
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id)
	REFERENCES production.products (product_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sales.Order_Status_Definitions (
	Status_ID TINYINT IDENTITY (1,1) PRIMARY KEY,
	Definition VARCHAR(255) NOT NULL
);

SET IDENTITY_INSERT Sales.Order_Status_Definitions ON;  

INSERT INTO Sales.Order_Status_Definitions (Status_ID, Definition)
	VALUES
	(1, 'Pending'),
	(2, 'Processing'),
	(3, 'Rejected'),
	(4, 'Completed')
SET IDENTITY_INSERT Sales.Order_Status_Definitions OFF;