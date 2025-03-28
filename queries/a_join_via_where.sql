--Запрос на извлечение данных из нескольких связанных таблиц с использованием соединения по равенству полей таблиц.  (“=” в условии WHERE);

--Данный запрос выводит информацию о заказах, клиентах и товарах из нескольких таблиц, используя соединение через операторы равенства (=) в условии WHERE. 
--Мы связываем таблицу заказов с клиентами через customerID, таблицу заказов с деталями заказа через orderID и связываем детали заказа с товарами через productID.

SELECT 
    Orders.orderID as "Идентификатор заказа", 
    Customer.fullName AS "ФИО клиента", 
    Product.model AS "Модель товара", 
    OrderDetails.quantity as "Количество", 
    OrderDetails.priceatorder * OrderDetails.quantity as "Стоимость" 
FROM 
    Orders, 
    Customer, 
    OrderDetails, 
    Product
WHERE 
    Orders.customerID = Customer.customerID 
    AND OrderDetails.orderID = Orders.orderID 
    AND OrderDetails.productID = Product.productID;
