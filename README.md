# PostgreSQL Practice Repository

This repository contains my hands-on SQL practice using **PostgreSQL** and **Visual Studio Code**.  
Each `.sql` file demonstrates a specific concept, query type, or database feature I practiced while learning relational database design and SQL query writing.

---

## 📘 Overview

The exercises in this repository cover:

- Basic and intermediate SQL commands (`SELECT`, `UPDATE`, `DELETE`, `INSERT`)
- Joins and set operations
- Mathematical, string, and date/time functions
- Views, indexes, and stored procedures
- Analytical (window) functions
- Role creation and permission management
- Environment setup for PostgreSQL and VS Code integration

All scripts were tested locally using a PostgreSQL instance connected through VS Code’s PostgreSQL extension.

---

## 🗂️ File Descriptions

| File | Description |
|------|--------------|
| **setup_sql_postgres_VScode.sql** | Initial setup connecting PostgreSQL to VS Code; creating and verifying connections. |
| **products_INSERT.sql** | Practice inserting sample data into tables. |
| **Update.sql** | Examples of `UPDATE` queries, modifying specific rows using `WHERE` conditions. |
| **DELETE.sql** | Demonstrates removing rows from tables safely with and without `WHERE` clauses. |
| **CASE_matching_multiple_conditions.sql** | Conditional logic using `CASE` expressions to categorize or transform data. |
| **all_4_joins.sql / all_4_joins.pgsql** | Practice using `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN` to combine tables. |
| **group_by.sql** | Aggregating data with `GROUP BY` and filtering grouped results with `HAVING`. |
| **UNION.sql** | Combining results from multiple queries using `UNION` and `UNION ALL`. |
| **mathmatical_functions.sql** | Practicing numeric and mathematical functions (`ABS`, `ROUND`, `FLOOR`, `CEIL`, `SQRT`, etc.). |
| **string_functions.sql** | Using text manipulation functions (`UPPER`, `LOWER`, `CONCAT`, `SUBSTRING`, etc.). |
| **Date_Time_functions.sql** | Extracting and manipulating dates and times (`NOW()`, `AGE()`, `EXTRACT()`, etc.). |
| **analytical_functions_windows.sql** | Advanced queries using window functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `SUM`, `AVG`, etc.). |
| **VIEWs.sql** | Creating and querying database views for simplified access to complex queries. |
| **Stored procedures.sql** | Writing stored procedures using `CREATE PROCEDURE` and calling them with `CALL`. |
| **index.sql** | Demonstrating how to improve performance using `CREATE INDEX`. |
| **creating_users_and_granting permissions.sql** | Creating roles, granting privileges, and experimenting with access control in PostgreSQL. |

---

## ⚙️ Environment

- **Database:** PostgreSQL 18 (Windows)
- **Editor:** Visual Studio Code  
  - Extension: *PostgreSQL* (by Chris Kolkman)
- **Connection:** Localhost (`localhost:5432`)
- **OS:** Windows 10/11

---

## 🧠 Concepts Practiced

- Creating and managing databases, schemas, and tables  
- Writing CRUD operations  
- Using aggregate, scalar, and analytical functions  
- Filtering, grouping, and joining data  
- Managing users and permissions  
- Defining and calling stored procedures  
- Performance tuning basics with indexes and views  

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
