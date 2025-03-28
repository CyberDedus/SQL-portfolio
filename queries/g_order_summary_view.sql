--Запросы на создание представлений (VIEW) по любому из запросов а-e
--Представление отображает сводную информацию о заказах, их стоимости и отзывах. 
--Представление выводит заказы с отзывами (если они есть), а также информацию о клиенте и товаре.

DROP VIEW IF EXISTS OrdersSummary; -- Удаляем представление, если оно существует
CREATE VIEW OrdersSummary AS
SELECT
    Orders.orderid AS "Идентификатор Заказа",
    Customer.fullname AS "ФИО клиента",
    Orders.orderdate AS "Дата заказа",
    Product.model AS "Модель товара",
    OrderDetails.quantity AS "Количество",
    OrderDetails.priceatorder AS "Цена товара",
    (OrderDetails.quantity * OrderDetails.priceatorder) AS "Общая стоимость заказа", 
    Review.reviewText AS "Текст отзыва", 
    Review.rating AS "Рейтинг отзыва"
FROM
    Orders
LEFT JOIN OrderDetails 
    ON Orders.orderid = OrderDetails.orderid
LEFT JOIN Product
    ON OrderDetails.productid = Product.productid
LEFT JOIN Review 
    ON Orders.orderid = Review.orderid
LEFT JOIN Customer 
    ON Orders.customerid = Customer.customerid;

SELECT*
FROM OrdersSummary
