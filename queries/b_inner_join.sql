--Данный запрос выводит такой же результат, как и в запросе «join_via_where.sql», но использование INNER JOIN позволяет яснее понять, какие именно таблицы соединяются. 
--Здесь мы указываем связь между таблицами через ON вместо условия в WHERE.

SELECT 
    Orders.orderID as "Идентификатор заказа", 
    Customer.fullName AS "ФИО клиента", 
    Product.model AS "Модель товара", 
    OrderDetails.quantity as "Количество", 
    OrderDetails.priceatorder * OrderDetails.quantity as "Стоимость" 
FROM
  Orders
INNER JOIN
  Customer ON Orders.customerID = Customer.customerID
INNER JOIN
  OrderDetails ON Orders.orderID = OrderDetails.orderID
INNER JOIN
  Product ON OrderDetails.productID = Product.productID;
