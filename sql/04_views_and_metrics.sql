--      Buisness Logic views & Core Metrics        --
--      New vs Returning        --      
CREATE OR REPLACE VIEW vw_orders_enriched AS 
SELECT
    fo.order_key,
    fo.order_id,
    fo.customer_key,
    dc.customer_unique_id,
    dc.zip_code_prefix,
    dc.city,
    dc.state,
    fo.order_date_id,
    dd.year,
    dd.quarter,
    dd.month,
    dd.month_name,
    dd.week_of_year,
    dd.day_of_month,
    dd.day_of_week,
    dd.day_name,
    fo.order_status,
    fo.order_purchase_timestamp,
    fo.order_approved_at,
    fo.delivered_carrier_date,
    fo.delivered_customer_date,
    fo.estimated_delivery_date,
    dc.first_order_date,
    CASE 
        WHEN fo.order_purchase_timestamp::date = dc.first_order_date
            THEN 'NEW'
        ELSE 'RETURNING'
    END AS customer_order_type
FROM fact_orders fo 
LEFT JOIN dim_customer dc 
    ON fo.customer_key = dc.custoemr_key 
LEFT JOIN dim_date dd 
    ON fo.order_date_id = dd.date_id 

--      testing the above view      --

SELECT customer_order_type, COUNT(*)
FROM vw_orders_enriched
GROUP BY customer_order_type


--      Building revenue and profit per items       --
--      Simiply revenue/profit analysis from fact_order_items -- 

CREATE OR REPLACE VIEW vw_order_items_enriched AS
SELECT
    foi.order_item_key,
    foi.order_id,
    fo.order_key,
    fo.customer_key,
    dc.customer_unique_id,
    dc.city,
    dc.state,
    fo.order_date_id,
    dd.year,
    dd.quarter,
    dd.month,
    dd.month_name,
    dd.week_of_year,
    dd.day_of_month,
    dd.day_of_week,
    dd.day_name,
    foi.product_key,
    dp.product_id,
    dp.product_category_name,
    foi.seller_id,
    foi.shipping_limit_date,
    foi.quantity,
    foi.price,
    foi.freight_value,
    (foi.quantity * foi.price) AS gross_revenue,
    (foi.quantity * foi.price * 0.6) AS estimated_cost,
    (foi.quantity * foi.price
        - foi.freight_value
        - foi.quantity * foi.price * 0.6) AS gross_profit
FROM fact_order_items foi
JOIN fact_orders fo
    ON foi.order_id = fo.order_id
LEFT JOIN dim_customer dc
    ON fo.customer_key = dc.custoemr_key
LEFT JOIN dim_date dd
    ON fo.order_date_id = dd.date_id
LEFT JOIN dim_product dp
    ON foi.product_key = dp.product_key;


--      sanity-check        --
SELECT * FROM vw_order_items_enriched LIMIT 10

--      Revenue & Profit by Region (state)      --

SELECT 
    state,
    COUNT(DISTINCT customer_key)            AS num_customers,
    COUNT(DISTINCT order_id)                AS num_orders,
    SUM(gross_revenue)                      AS total_revenue,
    SUM(gross_profit)                       AS total_gross_profit,
    SUM(gross_revenue)/NULLIF(COUNT(DISTINCT customer_key),0)
                                    AS revenue_per_customer,
    SUM(gross_profit)/NULLIF(COUNT(DISTINCT customer_key), 0)
                                    AS profit_per_customer
FROM vw_order_items_enriched
GROUP BY state 
ORDER BY total_revenue DESC 
   
