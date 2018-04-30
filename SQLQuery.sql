USE AdventureWorks2

--Return all rows and only a subset of the columns (Name, ProductNumber, ListPrice) from
--the Product table. Change ListPrice column heading to ‘Price’.
SELECT Name 
	,ProductNumber 
	,ListPrice as Price 
FROM Production.Product

--Find all the employees from HumanResources.Employee table who were hired after
--2009-01-01.
SELECT *
FROM HumanResources.Employee
WHERE HireDate > '2009-01-01'

--Return only the rows for Product from Production.Product table that have a product
--line of ‘S’ and that have days to manufacture that is less than 5. Sort by ascending order
SELECT * FROM Production.Product
WHERE ProductLine = 'S' AND 
	DaysToManufacture < 5
ORDER BY DaysToManufacture

--Retrieve employees job titles from HumanResources.Employee table without
--duplicates.
SELECT DISTINCT JobTitle 
FROM  HumanResources.Employee 

--Find the total order quantity of each sales order from Sales.SalesOrderDetail table.
SELECT SalesOrderID
	,SUM(OrderQty) AS Total
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

--Put the results into groups after retrieving only the rows with list prices greater than
--$900.
SELECT ProductModelID
FROM Production.Product
WHERE ListPrice > 900
GROUP BY ProductModelID

--By using HAVING clause group the rows in the Sales.SalesOrderDetail table by product
--ID and eliminate products whose average order quantities are more than 4.
SELECT ProductID
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(OrderQty) < 4

--Write uspGetEmployeeManagersPerDepartment stored procedure that returns direct
--managers of employees who work at specified department.
GO
CREATE PROCEDURE uspGetEmployeeManagersPerDepartment(@BusinessEntityID int)
AS
BEGIN
	DECLARE @entityID INT = 
		(SELECT BusinessEntityID 
		FROM HumanResources.Employee
		WHERE OrganizationNode = (SELECT OrganizationNode
								  FROM HumanResources.Employee
								  WHERE BusinessEntityID = @BusinessEntityID).GetAncestor(1)
		)


	SELECT emp.BusinessEntityID
		,p.FirstName
		,p.LastName
		,emp.JobTitle
		,(SELECT emp.Gender 
			FROM HumanResources.Employee emp
			WHERE emp.BusinessEntityID = @entityID) 
			AS  ManagerGender
		,(SELECT p.FirstName
			FROM Person.Person p
			WHERE p.BusinessEntityID = @entityID)
			AS  ManagerFirstName
		,(SELECT p.LastName
			FROM Person.Person p
			WHERE p.BusinessEntityID = @entityID)
			AS ManagerLastName
	FROM HumanResources.Employee emp
    INNER JOIN Person.Person p 
    ON p.BusinessEntityID = emp.BusinessEntityID
	WHERE emp.BusinessEntityID = @BusinessEntityID
END

EXEC uspGetEmployeeManagersPerDepartment 7