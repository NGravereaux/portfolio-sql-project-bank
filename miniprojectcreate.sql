CREATE DATABASE IF NOT EXISTS miniproject_mysql;
USE miniproject_mysql;

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Cards;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Branches;

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    Firstname VARCHAR(255),
    Lastname VARCHAR(255),
    Email VARCHAR(255)
);

CREATE TABLE Branches (
    BranchId INT PRIMARY KEY,
    Branchname VARCHAR(255),
    Branchaddress VARCHAR(255),
    Branchmail VARCHAR(255)
);

CREATE TABLE Accounts (
    AccountId INT PRIMARY KEY,
    CustomerId INT,
    Accountname VARCHAR(255),
    Balance INT,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE Cards (
    CardId INT PRIMARY KEY,
    CustomerId INT,
    Cardlimit INT,
    Debt INT,
    Cardtype VARCHAR(255),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE Employees (
    StaffId INT PRIMARY KEY,
    BranchId INT,
    Empname VARCHAR(255),
    Empsurname VARCHAR(255),
    Email VARCHAR(255),
    Position VARCHAR(255),
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);

CREATE TABLE Transactions (
    TransactionId INT PRIMARY KEY,
    AccountId INT,
    Amount INT,
    FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
);