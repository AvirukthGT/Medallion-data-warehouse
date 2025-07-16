# Data Catalog — Gold Layer (Medallion Architecture)

## Overview
The **Gold Layer** presents clean, enriched data ready for reporting, dashboarding, and analytical use. It includes **dimension** and **fact views**, built by integrating and transforming data from the Silver Layer.

---

## `gold.dim_customers`

**Purpose:** Enriched customer profile with CRM and segmentation data.

| Column Name       | Data Type | Description                                                  |
|-------------------|-----------|--------------------------------------------------------------|
| `customer_key`    | INT       | Surrogate key uniquely identifying each customer record.     |
| `cst_id`          | INT       | Original customer ID from CRM.                               |
| `cst_firstname`   | NVARCHAR  | Customer's first name.                                       |
| `cst_lastname`    | NVARCHAR  | Customer's last name.                                        |
| `cst_email`       | NVARCHAR  | Cleaned customer email (may be null if missing).             |
| `cst_phone`       | NVARCHAR  | Standardized phone number with only digits or null.          |
| `cst_create_date` | DATE      | Date when the customer joined.                               |
| `segment_name`    | NVARCHAR  | Customer segment (e.g., Regular, Silver).                    |
| `discount_percent`| FLOAT     | Associated discount percentage for the segment.              |

---

## 🔷 `gold.dim_products`

**Purpose:** Unified product information with category and margin details.

| Column Name       | Data Type | Description                                                   |
|-------------------|-----------|---------------------------------------------------------------|
| `product_key`     | INT       | Surrogate key uniquely identifying each product record.       |
| `prd_id`          | INT       | Original product ID from ERP.                                 |
| `prd_name`        | NVARCHAR  | Product name.                                                 |
| `prd_category`    | NVARCHAR  | Product category string (may be 'Unknown' if missing).        |
| `prd_price`       | FLOAT     | Product price (0.0 for FREE items).                           |
| `prd_create_date` | DATE      | Product creation date in proper format.                       |
| `category_name`   | NVARCHAR  | Clean category name from category table.                      |
| `margin_percent`  | FLOAT     | Profit margin percentage of the product category.             |

---

## `gold.fact_sales`

**Purpose:** Transaction-level sales data with customer and product dimension mapping.

| Column Name     | Data Type | Description                                                  |
|-----------------|-----------|--------------------------------------------------------------|
| `sale_id`       | INT       | Unique sales transaction ID.                                 |
| `customer_key`  | INT       | FK to `dim_customers`.                                       |
| `product_key`   | INT       | FK to `dim_products`.                                        |
| `sale_date`     | DATE      | Date of the sale.                                            |
| `quantity`      | INT       | Number of units sold.                                        |
| `unit_price`    | FLOAT     | Unit price at the time of sale.                              |
| `sale_amount`   | FLOAT     | Total transaction amount (`quantity * unit_price`).          |
| `channel`       | NVARCHAR  | Sales channel (e.g., Online, Retail).                        |

---

## `gold.fact_feedback`

**Purpose:** Customer feedback records with link to dimension.

| Column Name      | Data Type | Description                               |
|------------------|-----------|-------------------------------------------|
| `feedback_id`    | INT       | Unique feedback ID.                       |
| `customer_key`   | INT       | FK to `dim_customers`.                    |
| `feedback_test`  | NVARCHAR  | Free-text feedback.                       |
| `feedback_date`  | DATE      | Date of feedback submission.             |
| `rating`         | INT       | Numeric rating (0–5, cleaned).           |

---

## `gold.agg_feedback_metrics`

**Purpose:** Aggregated feedback KPIs per customer.

| Column Name      | Data Type | Description                                |
|------------------|-----------|--------------------------------------------|
| `customer_key`   | INT       | FK to `dim_customers`.                     |
| `feedback_count` | INT       | Number of feedback records per customer.   |
| `avg_rating`     | FLOAT     | Average rating received by customer.       |
