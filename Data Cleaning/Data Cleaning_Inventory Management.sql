#crosschecking the stores data
SELECT *
FROM stores;

SELECT *
FROM stores
WHERE store_id IS NULL OR store_id = ''; #no empty spaces and no nulls

SELECT *
FROM stores
WHERE store_name IS NULL OR store_name = ''; #no empty spaces and no nulls

SELECT *
FROM stores
WHERE location IS NULL OR location = ''; #no empty spaces and no nulls

SELECT DISTINCT store_id
FROM stores; #id is distinct

SELECT DISTINCT store_name
FROM stores; #some store names are in capital letter while others are in lower cases

SELECT UPPER(store_name)
FROM stores; #data standardization/normalization

UPDATE inventory_management.stores
SET store_name = UPPER(store_name); #Converted all letters to uppercase 

SELECT DISTINCT location
FROM stores;

#crosschecking products data
SELECT *
FROM products_table;

SELECT DISTINCT(product_id)
FROM products_table;#4 product id are mentioned twice and they hve the same value.

WITH duplicates AS (
SELECT product_id, ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY product_id) AS row_num
FROM products_table
)
SELECT *
FROM duplicates
WHERE row_num > 1;

SELECT TRIM(product_id), TRIM(product_name), TRIM(category), TRIM(price)
FROM products_table
WHERE product_id IN (112,197,23,89);

SELECT DISTINCT(product_id)
FROM products_table;

SELECT *
FROM products_table
JOIN sales
USING(product_id)
WHERE product_id = 23; #it is giving duplicate vales since the product id has duplicate values.

CREATE TABLE products_table1 (
  product_id int DEFAULT NULL,
  product_name text,
  category text,
  price bigint DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM products_table1;

INSERT INTO products_table1
SELECT *, ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY product_id) AS row_num
FROM products_table;

SELECT * 
FROM products_table1
WHERE row_num != 1;

DELETE FROM products_table1
WHERE row_num != 1; #delete duplicates

SELECT DISTINCT product_name
FROM products_table1; #the product name contains invalid data so it was suggested that i delete it

ALTER TABLE products_table1
DROP COLUMN product_name; #delete the product_name column

ALTER TABLE products_table1
DROP COLUMN row_num; #delete the row_num column

SELECT DISTINCT category
FROM products_table1; #too many incorrect names

UPDATE products_table1
SET category = 'Grocery'
WHERE category IN ('groceries', 'groceri');

UPDATE products_table1
SET category = 'Toy'
WHERE category IN ('toy', 'toys');

UPDATE products_table1
SET category = 'Electronic'
WHERE category IN ('electronic', 'electonic', 'electron');

UPDATE products_table1
SET category = 'Furniture'
WHERE category = 'furniture';

SELECT *
FROM products_table1
WHERE price IS NULL OR price = '' OR price < 1; #no empty spaces and no nulls

ALTER TABLE products_table1
MODIFY COLUMN product_id TEXT;

#crosschecking the sales table
SELECT *
FROM sales;

SELECT DISTINCT sale_id
FROM sales;

WITH duplicates AS (
SELECT sale_id, store_id, product_id, quantity_sold,
sale_date, ROW_NUMBER() OVER(PARTITION BY sale_id ORDER BY sale_id) AS row_num
FROM sales
)
SELECT *
FROM duplicates
JOIN sales
USING (sale_id)
WHERE row_num > 1
ORDER BY sale_id;

SELECT *
FROM sales
WHERE sale_id IN (1982, 1986); #this confirms that the values with row_num > 1 are duplicates

CREATE TABLE sales1 (
  sale_id text,
  store_id text,
  product_id text,
  quantity_sold text,
  sale_date text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO sales1
SELECT *, ROW_NUMBER() OVER(PARTITION BY sale_id ORDER BY sale_id) AS row_num
FROM sales;

SELECT *
FROM sales1
WHERE row_num != 1;

DELETE
FROM sales1
WHERE row_num != 1; #delete duplicates

SELECT *
FROM sales1
WHERE quantity_sold = '' OR quantity_sold IS NULL OR quantity_sold < 1;

DELETE
FROM sales1
WHERE quantity_sold = '' OR quantity_sold IS NULL OR quantity_sold < 1; 
#deleting rows with whitespaces and invalid values in the quantity column

SELECT *
FROM sales1
WHERE sale_date = '' OR sale_date IS NULL OR sale_date < 1;

UPDATE sales1
SET sale_date = null
WHERE sale_date = '' OR sale_date IS NULL OR sale_date < 1;
#updating whitespaces and invalid values to null

SELECT *
FROM sales1;

ALTER TABLE sales1
DROP COLUMN row_num;

ALTER TABLE sales1
MODIFY COLUMN quantity_sold INT;

UPDATE sales1
SET sale_date = DATE(sale_date);

ALTER TABLE sales1
MODIFY COLUMN sale_date DATE;

#crosschecking the restocks data
SELECT *
FROM restocks;

SELECT ROUND(restock_id), ROUND(product_id), ROUND(store_id), ROUND(supplier_id)
FROM restocks;

UPDATE restocks
SET restock_id = ROUND(restock_id);

SELECT DISTINCT restock_id
FROM restocks;

UPDATE restocks
SET product_id = ROUND(product_id);

SELECT DISTINCT product_id
FROM restocks;

SELECT *
FROM restocks
WHERE product_id = 0;

DELETE
FROM restocks
WHERE product_id = 0;

UPDATE restocks
SET store_id = ROUND(store_id);

SELECT DISTINCT store_id
FROM restocks;

UPDATE restocks
SET supplier_id = ROUND(supplier_id);

SELECT DISTINCT supplier_id
FROM restocks;

WITH duplicates AS (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY restock_id, product_id,
store_id, quantity_restocked, restock_date,  supplier_id) AS row_num
FROM restocks
)
SELECT *
FROM duplicates
WHERE row_num != 1;

CREATE TABLE restocks1 (
  restock_id text,
  product_id text,
  store_id text,
  quantity_restocked text,
  restock_date text,
  supplier_id text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO restocks1
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY restock_id, product_id,
store_id, quantity_restocked, restock_date,  supplier_id) AS row_num
FROM restocks;

SELECT *
FROM restocks1
WHERE row_num != 1;

DELETE
FROM restocks1
WHERE row_num != 1;

SELECT *
FROM restocks1
WHERE restock_id = '' OR restock_id IS NULL;

SELECT *
FROM restocks1
WHERE product_id = '' OR product_id IS NULL;

SELECT *
FROM restocks1
WHERE store_id = '' OR store_id IS NULL;

SELECT *
FROM restocks1
WHERE supplier_id = '' OR supplier_id IS NULL;

SELECT *
FROM restocks1
WHERE quantity_restocked = '' OR quantity_restocked IS NULL OR quantity_restocked < 1;
#the spaces need to be investigated

DELETE
FROM restocks1
WHERE quantity_restocked = '' OR quantity_restocked IS NULL OR quantity_restocked < 1;

SELECT *
FROM restocks1
WHERE restock_date = '' OR restock_date IS NULL OR restock_date < 1;

UPDATE restocks1
SET restock_date = null
WHERE restock_date = '' OR restock_date IS NULL OR restock_date < 1;

ALTER TABLE restocks1
DROP COLUMN row_num;

ALTER TABLE restocks1
MODIFY COLUMN quantity_restocked DECIMAL(10,2);

ALTER TABLE restocks1
MODIFY COLUMN restock_date DATE;


#crosschecking the inventory data
SELECT *
FROM inventory;

UPDATE inventory
SET inventory_id = ROUND(inventory_id);

UPDATE inventory
SET store_id = ROUND(store_id);

UPDATE inventory
SET product_id = ROUND(product_id);

SELECT DISTINCT inventory_id
FROM inventory;

SELECT *
FROM inventory
WHERE inventory_id = 0;

DELETE
FROM inventory
WHERE inventory_id = 0;

SELECT *
FROM inventory
WHERE store_id = '' OR store_id IS NULL;

SELECT *
FROM inventory
WHERE product_id = '' OR product_id IS NULL;

SELECT *
FROM inventory
WHERE inventory_id = '' OR inventory_id IS NULL;

SELECT *
FROM inventory
WHERE stock_level REGEXP '^-?[0-9]+(\.[0-9]+)?$';

DELETE
FROM inventory
WHERE stock_level NOT REGEXP '^-?[0-9]+(\.[0-9]+)?$' OR stock_level IS NULL OR stock_level = '';


WITH duplicates AS (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY inventory_id, store_id, product_id, stock_level) AS row_num
FROM inventory
)
SELECT *
FROM duplicates
WHERE row_num != 1;

SELECT *
FROM inventory
WHERE inventory_id IN (1032, 1063, 1072, 1209, 1212)
ORDER BY inventory_id;

CREATE TABLE inventory1 (
  inventory_id text,
  store_id text,
  product_id text,
  stock_level text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO inventory1
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY inventory_id, store_id, product_id, stock_level) AS row_num
FROM inventory;

SELECT *
FROM inventory1
WHERE row_num != 1;

DELETE
FROM inventory1
WHERE row_num != 1;

SELECT *
FROM inventory1
ORDER BY inventory_id ASC;

ALTER TABLE inventory1
DROP COLUMN row_num;

ALTER TABLE inventory1
MODIFY COLUMN stock_level INT;

#crosschecking the suppliers data
SELECT *
FROM suppliers;

UPDATE suppliers
SET supplier_name = UPPER(supplier_name);

SELECT *
FROM suppliers
WHERE supplier_id = '' OR supplier_id IS NULL;

SELECT *
FROM suppliers
WHERE supplier_name = '' OR supplier_name IS NULL;

SELECT DISTINCT supplier_id
FROM suppliers;

ALTER TABLE suppliers
MODIFY COLUMN supplier_id TEXT;

SELECT *
FROM inventory
WHERE stock_level =0;