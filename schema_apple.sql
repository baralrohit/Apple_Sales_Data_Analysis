-- Apple Retails Millions Rows Sales Schemas

-- =========================
-- DROP TABLES IF THEY EXIST
-- =========================

DROP TABLE IF EXISTS warranty;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category; --parent
DROP TABLE IF EXISTS stores;  --parent

-- =========================
-- CREATE STORES TABLE
-- =========================

CREATE TABLE stores (
    store_id VARCHAR(5) PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

-- =========================
-- CREATE CATEGORY TABLE
-- =========================

CREATE TABLE category (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(20) NOT NULL
);

-- =========================
-- CREATE PRODUCTS TABLE
-- =========================

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    launch_date DATE,
    price float,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

-- =========================
-- CREATE SALES TABLE
-- =========================

CREATE TABLE sales (
    sale_id VARCHAR(15) PRIMARY KEY,
    sale_date DATE NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_sales_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- =========================
-- CREATE WARRANTY TABLE
-- =========================

CREATE TABLE warranty (
    claim_id VARCHAR(10) PRIMARY KEY,
    claim_date DATE NOT NULL,
    sale_id VARCHAR(15) NOT NULL,
    repair_status VARCHAR(50) NOT NULL,

    CONSTRAINT fk_warranty_sale
        FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id)
);
