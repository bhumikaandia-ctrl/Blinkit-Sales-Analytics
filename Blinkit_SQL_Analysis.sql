--BLINKIT SALES ANALYTICS PROJECT
--SQL QUERIES

--1.ORDER ANALYSIS

--Total revenue
SELECT SUM(order_total) AS total_revenue
FROM order_items;

--Total orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_items;

--Average order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM order_items;

--Orders by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    SUM(order_total) AS revenue
FROM order_items
GROUP BY payment_method
ORDER BY revenue DESC;

--Revenue by store
SELECT
    store_id,
    COUNT(*) AS total_orders,
    SUM(order_total) AS revenue
FROM order_items
GROUP BY store_id
ORDER BY revenue DESC;


--2.PRODUCT ANALYSIS

--Top 10 products by revenue
SELECT
    p.product_name,
    SUM(o.quantity * o.unit_price) AS revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

--Revenue by category
SELECT
    p.category,
    SUM(o.quantity * o.unit_price) AS revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--Revenue by brand
SELECT
    p.brand,
    SUM(o.quantity * o.unit_price) AS revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.brand
ORDER BY revenue DESC;

--Quantity sold by category
SELECT
    p.category,
    SUM(o.quantity) AS units_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY units_sold DESC;


--3.CUSTOMER ANALYSIS

--Customer segment performance
SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(oi.order_id) AS orders,
    SUM(oi.order_total) AS revenue,
    ROUND(AVG(o.order_total), 2) AS average_order_value
FROM customers c
LEFT JOIN order_items oi
    ON c.customer_id = oi.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;

--Revenue by area
SELECT
    c.area,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(oi.order_id) AS orders,
    SUM(oi.order_total) AS revenue
FROM customers c
LEFT JOIN order_items oi
    ON c.customer_id = oi.customer_id
GROUP BY c.area
ORDER BY revenue DESC;


--4.DELIVEY

--Delivery status performance
SELECT
    delivery_status,
    COUNT(*) AS deliveries
FROM delivery_performance
GROUP BY delivery_status
ORDER BY deliveries DESC;

--Average delivery delay
SELECT
    ROUND(AVG(delivery_delay_minutes), 2) AS average_delay_minutes
FROM delivery_performance;

--Delay reasons
SELECT
    reasons_if_delayed,
    COUNT(*) AS delayed_deliveries
FROM delivery_performance
WHERE reasons_if_delayed IS NOT NULL
GROUP BY reasons_if_delayed
ORDER BY delayed_deliveries DESC;

--Delivery partner performance
SELECT
    delivery_partner_id,
    COUNT(*) AS deliveries,
    ROUND(AVG(delivery_delay_minutes), 2) AS average_delay
FROM delivery_performance
GROUP BY delivery_partner_id
ORDER BY average_delay;


--5.CUSTOMER SATISFACTION

--Rating distribution
SELECT
    rating,
    COUNT(*) AS feedback_count
FROM customer_feedback
GROUP BY rating
ORDER BY rating;

--Sentiment distribution
SELECT
    sentiment,
    COUNT(*) AS feedback_count
FROM customer_feedback
GROUP BY sentiment
ORDER BY feedback_count DESC;

--Average rating by feedback category
SELECT
    feedback_category,
    ROUND(AVG(rating), 2) AS average_rating,
    COUNT(*) AS feedback_count
FROM customer_feedback
GROUP BY feedback_category
ORDER BY average_rating;

--Rating vs delivery status 
SELECT
    d.delivery_status,
    ROUND(AVG(f.rating), 2) AS average_rating,
    COUNT(*) AS feedback_count
FROM customer_feedback f
JOIN delivery_performance d
    ON f.order_id = d.order_id
GROUP BY d.delivery_status
ORDER BY average_rating;


--6.MARKETING PERFORMANCE

--Marketing channel performance
SELECT
    channel,
    SUM(spend) AS total_spend,
    SUM(revenue_generated) AS revenue,
    ROUND(AVG(roas), 2) AS average_roas,
    SUM(conversions) AS conversions
FROM marketing_performance
GROUP BY channel
ORDER BY revenue DESC;

--Top campaigns
SELECT
    campaign_name,
    channel,
    SUM(spend) AS spend,
    SUM(revenue_generated) AS revenue,
    ROUND(AVG(roas), 2) AS roas
FROM marketing_performance
GROUP BY campaign_name, channel
ORDER BY revenue DESC
LIMIT 10;


--7.INVENTORY

--Overall inventory damage
SELECT
    SUM(stock_received) AS total_stock_received,
    SUM(damaged_stock) AS total_damaged_stock,
    ROUND(
        SUM(damaged_stock) * 100.0 /
        NULLIF(SUM(stock_received), 0),
        2
    ) AS damage_rate
FROM inventory;

--Products with highest damaged stock
SELECT
    i.product_id,
    p.product_name,
    SUM(i.damaged_stock) AS damaged_stock
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
GROUP BY i.product_id, p.product_name
ORDER BY damaged_stock DESC
LIMIT 10;