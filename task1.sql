-- 
-- Схема базы данных онлайн-магазина
-- 
-- 1. Таблица product_groups (Товарные группы)
--    group_id (PK), group_name
-- 2. Таблица products (Товары)
--    product_id (PK), product_name, group_id (FK, может быть NULL)
-- 3. Таблица orders (Заказы)
--    order_id (PK), order_date
-- 4. Таблица order_items (Позиции заказов)
--    order_item_id (PK), order_id (FK), product_id (FK), quantity, price_at_moment

-- 
-- SQL-запрос для отчета по продажам
-- 

SELECT 
    DATE_TRUNC('month', o.order_date) AS sale_month, -- Месяц продажи
    COALESCE(pg.group_name, 'Без группы') AS product_group, -- Название группы или 'Без группы'
    p.product_name, -- Название товара
    SUM(oi.quantity) AS total_quantity, -- Общее количество проданных единиц
    SUM(oi.quantity * oi.price_at_moment) AS total_revenue -- Общая выручка
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
LEFT JOIN 
    product_groups pg ON p.group_id = pg.group_id
GROUP BY 
    DATE_TRUNC('month', o.order_date),
    pg.group_name,
    p.product_name
ORDER BY 
    sale_month DESC, 
    total_revenue DESC;
