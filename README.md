# SQL Portfolio: Аналитика для интернет-магазина электроники

Это портфолио демонстрирует навыки работы с SQL на примере базы данных интернет-магазина электроники `online_electronics_shop`.  

**Цель**: Показать умение работать с основными типами запросов, включая JOIN, CASE, GROUP BY, подзапросы, оконные функции и представления.

---

## 📁 Структура проекта  
my_sql_project/  
├── database/  
│ └── schema.sql # Дамп структуры БД (таблицы и связи)  
└── queries/  
├── a_join_via_where.sql # Пример A: Соединение через WHERE  
├── b_inner_join.sql # Пример B: INNER JOIN с ON  
├── c_case_classification.sql # Пример C: Классификация через CASE  
├── d_group_having.sql # Пример D: Группировка и HAVING  
├── e_left_join_reviews.sql # Пример E: LEFT JOIN с отзывами  
├── f_subquery_avg_cost.sql # Пример F: Подзапрос для фильтрации  
├── g_order_summary_view.sql # Пример G: VIEW для сводной информации  
└── h_window_time_series.sql # Пример H: Оконные функции для временных рядов  

---

## 🛠️ Технологии
- **СУБД**: PostgreSQL
- **Инструменты**: psql, pgAdmin

---

## 📊 Примеры запросов

### **A. Соединение таблиц через WHERE**  
**Файл**: [a_join_via_where.sql]  
**Цель**: Получить данные из `Orders`, `Customers` и `Products` через неявное соединение.  
**Навыки**:  
- Соединение таблиц через `WHERE` и `=`.
  
```sql
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
```


### **B. INNER JOIN с явным указанием связи**  
**Файл**: [b_inner_join.sql]  
**Цель**: Улучшить читаемость запроса A через INNER JOIN.  
**Навыки**:  
- Явные соединения с ON.  

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



### **C. Классификация заказов через CASE**  
**Файл**: [c_case_classification.sql]  
**Цель**: Сегментировать заказы по стоимости на High/Medium/Low.  
**Навыки**:  
- Условная логика с CASE.  

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



### **D. Группировка и фильтрация через HAVING**  
**Файл**: d_group_having.sql  
**Цель**: Выявить популярные товары (заказанные > 1 раза).  
**Навыки**:  
- GROUP BY, агрегатные функции (COUNT, SUM), HAVING.  

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



### **E. LEFT JOIN для включения всех заказов**  
**Файл**: e_left_join_reviews.sql  
**Цель**: Получить все заказы, включая те, у которых нет отзывов.  
**Навыки**:  
- LEFT JOIN, работа с NULL.  

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



### **F. Подзапрос для фильтрации по средней стоимости**  
**Файл**: f_subquery_avg_cost.sql  
**Цель**: Найти заказы дороже среднего.  
**Навыки**:  
- Вложенные подзапросы, WHERE с подзапросом.  

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



### **G. Создание представления (VIEW)**  
**Файл**: g_order_summary_view.sql  
**Цель**: Упростить доступ к сводной информации о заказах.  
**Навыки**:  
- Создание VIEW, комбинирование JOIN.  

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



### **H. Оконные функции для анализа временных рядов**  
**Файл**: h_window_time_series.sql  
**Цель**: Рассчитать накопленную выручку по месяцам.  
**Навыки**:  
- Оконные функции (SUM() OVER), временные интервалы (DATE_TRUNC).  

SELECT  
    "Месяц",  
    SUM(monthly_revenue) OVER (ORDER BY "Месяц") AS "Накопленная выручка"  
FROM (  
    SELECT  
        DATE_TRUNC('month', o.orderdate) AS "Месяц",  
        SUM(od.quantity * od.priceatorder) AS monthly_revenue  
    FROM OrderDetails od  
    JOIN Orders o ON od.orderid = o.orderid  
    GROUP BY DATE_TRUNC('month', o.orderdate)  
) AS monthly_data  
ORDER BY "Месяц";  
  

---

### **Запуск**  
1. Восстановите БД из дампа:  

psql -U ваш_пользователь -d online_electronics_shop -f database/schema.sql  

2. Выполните запросы через pgAdmin или командную строку.  

---

### **Контакты**
**Автор**: Федоров Василий Александрович  

**Email**: vasiliy.fedorov.01@mail.ru  

---

### **Примечание**: Все запросы проверены на PostgreSQL 17. Для работы требуется установленный PostgreSQL и права на создание БД.  

