--      create fact_orders Table        --

CREATE TABLE fact_orders(
    order_key                   SERIAL PRIMARY KEY,
    order_id                    TEXT UNIQUE,
    customer_key                INT REFERENCES dim_customer(custoemr_key),
    order_date_id               DATE REFERENCES dim_date(date_id),
    order_status                TEXT,
    order_purchase_timestamp    TIMESTAMP,
    order_approved_at           TIMESTAMP,
    delivered_carrier_date      TIMESTAMP,
    delivered_customer_date     TIMESTAMP,
    estimated_delivery_date     TIMESTAMP
);

INSERT INTO fact_orders (
    order_id,
    customer_key,
    order_date_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    delivered_carrier_date,
    delivered_customer_date,
    estimated_delivery_date
)
SELECT
    o.order_id,
    dc.custoemr_key,
    o.order_purchase_timestamp::DATE AS order_date_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM stg_orders o 
LEFT JOIN dim_customer dc 
    ON o.customer_id = dc.customer_id 


--      Quick Checks        --

SELECT COUNT(*) FROM fact_orders;
SELECT COUNT(*) FROM stg_orders;
SELECT COUNT(*) FROM fact_orders WHERE customer_key IS NULL;
SELECT * FROM fact_orders LIMIT 5


--      Create fact_order_items     --

CREATE TABLE fact_order_items(
    order_item_key          SERIAL PRIMARY KEY,
    order_id                TEXT REFERENCES fact_orders(order_id),
    product_key             INT REFERENCES dim_product(product_key),
    seller_id               TEXT,
    shipping_limit_date     TIMESTAMP,
    quantity                INT,
    price                   NUMERIC(10, 2),
    freight_value         NUMERIC(10, 2)
);



--      Populate the table      --
INSERT INTO fact_order_items (
    order_id,
    product_key,
    seller_id,
    shipping_limit_date,
    quantity,
    price,
    freight_value
)
SELECT
    oi.order_id,
    dp.product_key,
    oi.seller_id,
    oi.shipping_limit_date,
    1 AS quantity,
    oi.price,
    oi.freight_value
FROM stg_order_items oi 
LEFT JOIN dim_product dp
    ON oi.product_id = dp.product_id 

--      Quick checks        --

SELECT COUNT(*) FROM fact_order_items;
SELECT COUNT(*) FROM stg_order_items;
SELECT COUNT(*) FROM fact_order_items WHERE product_key IS NULL;
SELECT * FROM fact_order_items LIMIT 5;

--      Create table fact_order_payments        --

CREATE TABLE fact_order_payments (
    payment_key         SERIAL PRIMARY KEY,
    order_id            TEXT REFERENCES fact_orders(order_id),
    payment_sequential  INT,
    payment_type        TEXT,
    payment_installments INT,
    payment_value       NUMERIC(10, 2)
);

--      Populate the Table      --

INSERT INTO fact_order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM stg_order_payments;


--      Quick Checks        --

SELECT COUNT(*) FROM fact_order_payments;
SELECT COUNT(*) FROM stg_order_payments;
SELECT * FROM fact_order_payments LIMIT 5;


--      Checking for any typos      --

CREATE INDEX idx_fact_orders_order_date_id
    ON fact_orders(order_date_id);

CREATE INDEX idx_fact_orders_customer_key
    ON fact_orders(customer_key);

CREATE INDEX idx_fact_order_items_order_id
    ON fact_order_items(order_id);

CREATE INDEX idx_fact_order_items_product_key
    ON fact_order_items(product_key);

CREATE INDEX idx_fact_order_payments_order_id
    ON fact_order_payments(order_id);
