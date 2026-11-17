SELECT 
    DATE_TRUNC('month', o.order_date) AS sale_month,
    COALESCE(pg.group_name, 'Без группы') AS product_group,
    p.product_name,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.price_at_moment) AS total_revenue
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
    sale_date DESC, 
    total_revenue DESC;