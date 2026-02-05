-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: dwh_dim
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer_dim`
--

DROP TABLE IF EXISTS `customer_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_dim` (
  `Customer_Id` char(5) NOT NULL,
  `Customer_Name` varchar(40) NOT NULL,
  `Contact_Name` varchar(30) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Customer_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_dim`
--

DROP TABLE IF EXISTS `employee_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_dim` (
  `Employee_Id` smallint NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `First_Name` varchar(20) NOT NULL,
  `Title` varchar(30) DEFAULT NULL,
  `Hire_Date` date DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Employee_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_dim`
--

DROP TABLE IF EXISTS `product_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_dim` (
  `Product_Id` smallint NOT NULL,
  `Product_Name` varchar(40) NOT NULL,
  `Category_Id` int DEFAULT NULL,
  `Category_Name` varchar(15) NOT NULL,
  `Supplier_Id` int DEFAULT NULL,
  `Supplier_Name` varchar(40) DEFAULT NULL,
  `Unit_Price` float(12,0) DEFAULT NULL,
  PRIMARY KEY (`Product_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesfact`
--

DROP TABLE IF EXISTS `salesfact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesfact` (
  `SalesID` int NOT NULL AUTO_INCREMENT,
  `ProductID` smallint DEFAULT NULL,
  `CustomerID` char(5) DEFAULT NULL,
  `SupplierID` smallint DEFAULT NULL,
  `EmployeeID` smallint DEFAULT NULL,
  `TimeID` varchar(20) DEFAULT NULL,
  `UnitPrice` float DEFAULT NULL,
  `QuantitySold` smallint DEFAULT NULL,
  `TotalSalesAmount` float DEFAULT NULL,
  `Discount` float DEFAULT NULL,
  `NetSales` float DEFAULT NULL,
  `Cost` float DEFAULT NULL,
  `Profit` float DEFAULT NULL,
  `ProfitMargin` float DEFAULT NULL,
  PRIMARY KEY (`SalesID`),
  KEY `ProductID` (`ProductID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `SupplierID` (`SupplierID`),
  KEY `EmployeeID` (`EmployeeID`),
  KEY `TimeID` (`TimeID`),
  CONSTRAINT `salesfact_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product_dim` (`Product_Id`),
  CONSTRAINT `salesfact_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer_dim` (`Customer_Id`),
  CONSTRAINT `salesfact_ibfk_3` FOREIGN KEY (`SupplierID`) REFERENCES `supplier_dim` (`Supplier_Id`),
  CONSTRAINT `salesfact_ibfk_4` FOREIGN KEY (`EmployeeID`) REFERENCES `employee_dim` (`Employee_Id`),
  CONSTRAINT `salesfact_ibfk_5` FOREIGN KEY (`TimeID`) REFERENCES `time_dim` (`Time_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=13281 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier_dim`
--

DROP TABLE IF EXISTS `supplier_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_dim` (
  `Supplier_Id` smallint NOT NULL,
  `Supplier_Name` varchar(40) DEFAULT NULL,
  `Contact_Name` varchar(30) DEFAULT NULL,
  `Region` varchar(8) DEFAULT NULL,
  `Product_Type` varchar(14) DEFAULT NULL,
  `Service_Region` varchar(6) DEFAULT NULL,
  `Reliability_Score` float(3,2) DEFAULT NULL,
  `Avg_Delivery_Time_Days` int DEFAULT NULL,
  `Notes` varchar(33) DEFAULT NULL,
  PRIMARY KEY (`Supplier_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_dim`
--

DROP TABLE IF EXISTS `time_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_dim` (
  `Time_Id` varchar(20) NOT NULL,
  `order_date` date DEFAULT NULL,
  `Month` int DEFAULT NULL,
  `Year` int DEFAULT NULL,
  `Quarter` int DEFAULT NULL,
  `MonthName` varchar(20) DEFAULT NULL,
  `DayOfWeek` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Time_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-24  1:40:02
