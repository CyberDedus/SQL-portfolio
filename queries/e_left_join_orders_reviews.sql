--Запросы с использованием левого/правого соединения (LEFT/RIGHT JOIN)
--Запрос выведет все заказы, включая те, которые не имеют отзывов.
--В этом случае мы будем использовать LEFT JOIN, чтобы включить все записи из таблицы Order, даже если для некоторых из них нет записей в таблице Review.


SELECT
	Orders.orderid AS "Идентификатор заказа", 
	Customer.fullName AS "ФИО клиента", 
	Orders.orderdate AS "дата заказа",
	Review.reviewText AS "Текст отзыва", 
	Review.rating AS "Рейтинг отзыва"
FROM
	ORDERS
LEFT JOIN
	Review ON Orders.orderid = Review.orderID
LEFT JOIN
	Customer ON Orders.customerid = Customer.customerid;
