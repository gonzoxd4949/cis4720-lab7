/* ==========================================================================
   lab6_backup.sql - completed for CIS 4720 Lab 7
   Run this after the original PRODUCT table (four rows) and PRODUCT_PRICES
   view have already been created in your MySQL database.

   This completed exercise rebuilds only the LAB 7 practice table and views
   when you run it, so previous practice runs won't cause duplicate errors.
   WARNING: PRODUCT_COPY and the two LAB 7 views are practice objects;
   their prior contents/changes will be replaced on each full run.

   To demonstrate intentional errors for Steps 14 and 16, select and run
   the commented test statements separately (after temporarily removing --).
   Comment them again before saving/uploading the final file.
   ========================================================================== */

-- ======================================================================
-- SECTION 1. The schema
-- ======================================================================

-- Makes the lab schema if it hasn't been created yet.
CREATE DATABASE IF NOT EXISTS cis4720_yourname;

-- Chooses the lab schema for all of the following statements.
USE cis4720_yourname;

-- ======================================================================
-- SECTION 2. The table (already created in Lab 6/Step 8)
-- Leave the original one-time setup statements commented out.
-- ======================================================================

-- CREATE TABLE PRODUCT (
--     prod_id     INT          NOT NULL,
--     prod_name   VARCHAR(40)  NOT NULL,
--     unit_price  DECIMAL(7,2),
--     added_on    DATE,
--     roast_level VARCHAR(10),
--     PRIMARY KEY (prod_id)
-- );

-- ======================================================================
-- SECTION 3. The data (already inserted in Lab 6/Step 8)
-- ======================================================================

-- INSERT INTO PRODUCT VALUES (1,'Yirgacheffe',    18.50,'2026-01-15','Light');
-- INSERT INTO PRODUCT VALUES (2,'Huila Supremo',  15.25,'2026-03-02','Medium');
-- INSERT INTO PRODUCT VALUES (3,'Cerrado Daily',  12.60,'2026-05-20','Medium');
-- INSERT INTO PRODUCT VALUES (4,'Antigua Classic',16.80,'2026-07-04','Medium');

-- ======================================================================
-- SECTION 4. The view (already created in Lab 6/Step 8)
-- ======================================================================

-- CREATE VIEW PRODUCT_PRICES AS
-- SELECT prod_name, unit_price
-- FROM PRODUCT;

-- ======================================================================
-- SECTION 5. Checks
-- ======================================================================

-- Show the four products stored in the og table.
SELECT * FROM PRODUCT;

-- List names and prices from the og view highest price first
SELECT * FROM PRODUCT_PRICES ORDER BY unit_price DESC;

-- Check that PRODUCT has four products with a total price of 63.15.
SELECT COUNT(*) AS products, SUM(unit_price) AS total_price FROM PRODUCT;

-- Distinguishes tables from views in this database.
SHOW FULL TABLES;

-- ######################################################################
-- CHAPTER 5 LAB 7 EXERCISES
-- ######################################################################

-- STEP 11. Section 5.1, look at your schema

-- Shows which database the connection is being used
SELECT DATABASE() AS my_schema;

-- Lists the tables and views and identifies their types.
SHOW FULL TABLES;

-- STEP 12. Section 5.2, look at the data types

-- Show the column names data types and keys in PRODUCT.
DESCRIBE PRODUCT;

-- STEP 13. Section 5.3, create a table by copying with a subquery

-- Remove the lab practice views so PRODUCT_COPY can be recreated
DROP VIEW IF EXISTS CHEAP_PRODUCTS;

-- Removes the summary practice view from an earlier run
DROP VIEW IF EXISTS PRICE_SUMMARY;

-- Clears the existing practice copy to start the exercise fresh.
DROP TABLE IF EXISTS PRODUCT_COPY;

-- Copies the id name and price from PRODUCT into a new table.
CREATE TABLE PRODUCT_COPY AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT;

-- Displays all the copied products
SELECT * FROM PRODUCT_COPY;

-- Shows how the copy was defined
SHOW CREATE TABLE PRODUCT_COPY;

-- STEP 14. Section 5.4, change the structure of the copy

-- Adds a one character sale indicator to the copied table.
ALTER TABLE PRODUCT_COPY ADD COLUMN on_sale CHAR(1);

-- Allows longer product names while requiring the name to be filled in.
ALTER TABLE PRODUCT_COPY MODIFY COLUMN prod_name VARCHAR(60) NOT NULL;

-- Protects the copy against duplicate product IDs by adding a primary key.
ALTER TABLE PRODUCT_COPY ADD PRIMARY KEY (prod_id);

-- Shows the new columns types, and the primary key.
DESCRIBE PRODUCT_COPY;


-- Remove the temporary sale indicator after testing the primary key.
ALTER TABLE PRODUCT_COPY DROP COLUMN on_sale;

-- STEP 15. Section 5.5, insert, update and delete a row

-- Adds a fifth coffee product to the practice copy.
INSERT INTO PRODUCT_COPY VALUES (5,'Kenya Peaberry',21.40);

-- Confirm new coffee product was added.
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;

-- Changes the fifth products price to $22.95
UPDATE PRODUCT_COPY SET unit_price = 22.95 WHERE prod_id = 5;

-- Confirms that the price was saved.
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;

-- Removes only the new practice product with ID 5.
DELETE FROM PRODUCT_COPY WHERE prod_id = 5;

-- Confirms the four original products remain in the copy.
SELECT COUNT(*) AS rows_left FROM PRODUCT_COPY;

-- STEP 16. Section 5.6, create a view and update through it

-- Build a view that shows only products priced below $16.
CREATE VIEW CHEAP_PRODUCTS AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT_COPY
WHERE unit_price < 16.00;

-- Show the two products that meet the views price condition.
SELECT * FROM CHEAP_PRODUCTS;

-- Checks the original price of product 3 before the change.
SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;

-- Changes product 3 through the view rather than the underlying table.
UPDATE CHEAP_PRODUCTS SET unit_price = 13.99 WHERE prod_id = 3;

-- Prove the underlying copy also contains the new price.
SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;

-- Create a summary view using the count and sum of the copied products.
CREATE VIEW PRICE_SUMMARY AS
SELECT COUNT(*) AS n, SUM(unit_price) AS total
FROM PRODUCT_COPY;

-- Displays the totals calculated by the summary
SELECT * FROM PRICE_SUMMARY;

