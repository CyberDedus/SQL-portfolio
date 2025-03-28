--Запросы с использованием вложенного подзапроса (вложенный SELECT)
--Запрос извлекает все заказы, у которых стоимость больше средней стоимости всех заказов. 
--Вложенный запрос (подзапрос) сначала вычисляет среднюю стоимость всех заказов, а основной запрос выбирает только те заказы, у которых стоимость выше этого значения.

SELECT
	o.orderID as "Идеинтификатор заказа", 
  	o.customerID as "Идентификатор клиента", 
	od.priceatorder * od.quantity as "Сумма заказа"
FROM
	Orders AS o
INNER JOIN OrderDetails AS od
	ON o.orderid = od.orderid
WHERE
	od.priceatorder * od.quantity > (
		SELECT AVG(od.priceatorder * od.quantity)
		FROM OrderDetails AS od
	);
