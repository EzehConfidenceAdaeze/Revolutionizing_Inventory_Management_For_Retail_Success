## Inventory Management Data Cleaning Using MySQL

This project focused on cleaning and standardizing an inventory management dataset using MySQL to ensure data accuracy, consistency, 
and readiness for analysis. The dataset included multiple tables: stores, products_table, sales, restocks, inventory, and suppliers. 
The data cleaning tasks involved identifying and handling duplicates, null values, invalid entries, and inconsistencies across all tables. 

# Key steps included:
- Standardizing Data: Ensured uniformity by converting store and supplier names to uppercase and normalizing categories.
- Handling Duplicates: Used ROW_NUMBER() to identify and remove duplicate records in products_table, sales, restocks, and inventory tables.
- Validating Data Integrity: Checked for null, empty, or invalid entries in key columns like product_id, sale_id, quantity_sold, and restock_date. Invalid records were either corrected or deleted.
- Data Type Optimization: Modified column types to match data characteristics (e.g., converting quantity_sold to INT and restock_date to DATE).
- Improving Accuracy: Addressed inconsistencies in category names and product pricing, ensuring all data aligned with predefined standards.
- Enhancing Readability: Reformatted tables for easier interpretation, removing irrelevant columns like row_num post-cleaning.
