-- Total Revenue
SELECT ROUND(SUM(Amount), 2) AS TotalRevenue
FROM Payments
WHERE PaymentStatus = 'Paid';
-- Monthly Revenue Trend
SELECT 
    DATE_FORMAT(PaidAt, '%Y-%m') AS Month,
    ROUND(SUM(Amount), 2) AS MonthlyRevenue
FROM Payments
WHERE PaymentStatus = 'Paid'
GROUP BY Month
ORDER BY Month;
-- Average Order Value
SELECT ROUND(AVG(Amount), 2) AS AvgOrderValue
FROM Payments
WHERE PaymentStatus = 'Paid';
-- Top 3 Customers by Total Spend
SELECT C.FirstName, C.LastName, SUM(P.Amount) AS TotalSpend
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Payments P ON O.OrderID = P.OrderID
WHERE P.PaymentStatus = 'Paid'
GROUP BY C.CustomerID
ORDER BY TotalSpend DESC
LIMIT 3;
-- Number of Orders per Customer
SELECT C.FirstName, C.LastName, COUNT(O.OrderID) AS OrderCount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID;
-- Top Selling Products (by quantity)
SELECT P.ProductName, SUM(OI.Quantity) AS TotalQuantity
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
GROUP BY P.ProductID
ORDER BY TotalQuantity DESC
LIMIT 5;
-- Total Revenue per Product
SELECT P.ProductName, ROUND(SUM(OI.Quantity * OI.UnitPrice), 2) AS Revenue
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
GROUP BY P.ProductID
ORDER BY Revenue DESC;
-- Number of Returns by Product
SELECT P.ProductName, COUNT(R.ReturnID) AS TotalReturns
FROM Returns R
JOIN Products P ON R.ProductID = P.ProductID
GROUP BY R.ProductID
ORDER BY TotalReturns DESC;
-- Return Rate (%)
SELECT 
    ROUND((SELECT COUNT(*) FROM Returns) / (SELECT COUNT(*) FROM OrderItems) * 100, 2) AS ReturnRatePercentage;
-- Seller-wise Revenue
SELECT S.SellerName, ROUND(SUM(P.Amount), 2) AS Revenue
FROM Sellers S
JOIN Orders O ON S.SellerID = O.SellerID
JOIN Payments P ON O.OrderID = P.OrderID
WHERE P.PaymentStatus = 'Paid'
GROUP BY S.SellerID;
-- Average Product Rating by Seller
SELECT S.SellerName, ROUND(AVG(R.Rating), 2) AS AvgRating
FROM Reviews R
JOIN Products P ON R.ProductID = P.ProductID
JOIN Sellers S ON P.SellerID = S.SellerID
GROUP BY S.SellerID;
-- Average Delivery Time (in days)
SELECT 
    ROUND(AVG(DATEDIFF(S.DeliveryDate, O.OrderDate)), 2) AS AvgDeliveryDays
FROM Shipments S
JOIN Orders O ON S.OrderID = O.OrderID
WHERE S.Status = 'Delivered';
-- Orders Currently In Transit
SELECT O.OrderID, C.FirstName, C.LastName, S.ShippingProvider
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Shipments S ON O.OrderID = S.OrderID
WHERE S.Status = 'In Transit';
