-- Запросы с использованием процедурных возможностей SQL (команда CASE)
-- Этот запрос использует команду CASE, чтобы классифицировать заказы по их стоимости (totalCost) на три категории: 
--"High", "Medium" и "Low". Классификация производится с использованием условий в блоке CASE, что позволяет динамически вычислить категорию для каждого заказа в зависимости от его стоимости.

SELECT 
    Orders.orderID as "Идентификатор заказа", 
    Customer.fullName AS "ФИО клиента", 
    OrderDetails.priceatorder * OrderDetails.quantity as "Сумма заказа",
    CASE
        WHEN  (OrderDetails.priceatorder * OrderDetails.quantity) > 150000 THEN 'High'
        WHEN  (OrderDetails.priceatorder * OrderDetails.quantity) BETWEEN 75000 AND 150000 THEN 'Medium'
        ELSE 'Low'
    END AS "Категория заказа"
FROM 
	Orders
INNER JOIN 
	Customer ON Orders.customerID = Customer.customerID
INNER JOIN
	OrderDetails ON OrderDetails.orderid = Orders.orderid
ORDER BY 
	OrderDetails.priceatorder * OrderDetails.quantity DESC
