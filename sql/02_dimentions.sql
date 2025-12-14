/* 
    The table dim_date acts as an official calendar for the whole warehouse
    it is added here just for reference. 
        first it creates an empty table (A calendar table to resuse everywhere)
        Than populate it one row per day
*/

--      Create the dim_date table       --

CREATE TABLE dim_date(
    date_id         DATE PRIMARY KEY,
    year            INT,
    quarter         INT,
    month           INT,
    month_name      TEXT,
    week_of_year    INT,
    day_of_month    INT,
    day_of_week     INT,
    day_name        TEXT
);

--      Populate dim_date from orders date range        --

INSERT INTO dim_date (
    date_id,
    year,
    quarter,
    month,
    month_name,
    week_of_year,
    day_of_month,
    day_of_week,
    day_name
)
SELECT
    d::DATE                             AS date_id,
    EXTRACT(YEAR    FROM d)::INT        AS year,
    EXTRACT(QUARTER FROM d)::INT        AS quarter,
    EXTRACT(MONTH FROM d)::INT          AS month,
    TO_CHAR(d, 'Mon')                   AS month_name,
    EXTRACT(WEEK    FROM d)::INT        AS week_of_year,
    EXTRACT(DAY     FROM d)::INT        AS day_of_month,
    EXTRACT(DOW     FROM d)::INT        AS day_of_week,
    TO_CHAR(d, 'Dy')                    AS day_name
FROM generate_series(
    (SELECT MIN(order_purchase_timestamp)::DATE FROM stg_orders),
    (SELECT MAX(order_purchase_timestamp)::DATE FROM stg_orders),
    INTERVAL '1 day'
)   AS d;


--      sanaty check        --

SELECT COUNT(*) FROM dim_date;
SELECT * FROM dim_date ORDER BY date_id LIMIT 5;
SELECT * FROM dim_date ORDER BY date_id DESC LIMIT 5;


--      Create and populate dim_customer Table      --

CREATE TABLE dim_customer(
    custoemr_key                SERIAL  PRIMARY KEY,
    customer_id                 TEXT UNIQUE,
    customer_unique_id          TEXT,
    zip_code_prefix             INT,
    city                        TEXT,
    state                       TEXT,
    first_order_date            DATE
);

INSERT INTO dim_customer (
    customer_id, 
    customer_unique_id,
    zip_code_prefix,
    city,
    state,
    first_order_date
)
SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    MIN(o.order_purchase_timestamp)::DATE AS first_order_date
FROM stg_customers c
LEFT JOIN stg_orders o 
    ON o.customer_id = c.customer_id 
GROUP BY 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state;

--      Sanity Check        --
SELECT COUNT(*) FROM dim_customer;
SELECT * FROM dim_customer LIMIT 5;
SELECT COUNT(*) FROM dim_customer WHERE first_order_date IS NULL;

--      Create and populate dim_product     __

CREATE TABLE dim_product (
    product_key                 SERIAL PRIMARY KEY,
    product_id                  TEXT UNIQUE,
    product_category_name       TEXT,
    product_name_length         INT,
    product_description_length  INT,
    product_photos_qty          INT,
    product_weight_g            NUMERIC(10, 2),
    product_length_cm           NUMERIC(10, 2),
    product_height_cm           NUMERIC(10, 2),
    product_width_cm            NUMERIC(10, 2)
);

--      Populate it from stg_products       --

INSERT INTO dim_product (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM stg_products;

--      Sanaty checks       --

SELECT COUNT(*) FROM dim_product;
SELECT * FROM dim_product LIMIT 5;
SELECT COUNT(*) FROM dim_product WHERE product_category_name IS NULL;
