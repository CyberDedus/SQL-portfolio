--Запросы с использованием группировок, группировочных функций и условий на группы (HAVING)
--Запрос группирует данные по моделям товаров и считает количество заказов и общее количество товара для каждой модели. 
--Затем с помощью условия HAVING фильтруются только те товары, которые были заказаны более одного раза. 

SELECT
	Product.model,
	COUNT(OrderDetails.OrderId) AS "Количество заказов с данным товаром", 
	SUM(OrderDetails.quantity) AS "Количество проданных устройств"
FROM
	OrderDetails
INNER JOIN
	Product ON OrderDetails.Productid = Product.productid
GROUP BY
	Product.model
HAVING
	COUNT(OrderDetails.orderid)>1