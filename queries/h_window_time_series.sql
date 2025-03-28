--Использование оконных функций (SUM() OVER) и вложенных запросов для анализа временных рядов.
--Запрос используется для анализ динамики накопленной выручки по месяцам для выявления трендов и стратегического планирования.

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
