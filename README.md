# Vehicle Rental System – Database Design & SQL

## Project Overview
This project demonstrates the design and implementation of a relational database for a **Vehicle Rental System**. The goal is to model real-world rental operations using proper database structure and SQL queries.

The system manages three main entities:

- **Users**
- **Vehicles**
- **Bookings**

The database schema is designed using an **Entity Relationship Diagram (ERD)** and implemented with SQL queries that demonstrate key database concepts such as joins, filtering, grouping, and subqueries.

---

## Objectives
The main objectives of this project are:

- Design a relational database using **ERD**
- Implement **Primary Keys and Foreign Keys**
- Model **1:1, 1:N, and N:1 relationships**
- Write SQL queries using:
  - `JOIN`
  - `WHERE`
  - `EXISTS / NOT EXISTS`
  - `GROUP BY`
  - `HAVING`

---

## Database Structure

### 1. Users Table
Stores information about system users.

**Fields**

| Column | Description |
|------|-------------|
| user_id (PK) | Unique user identifier |
| user_name | User full name |
| email | Unique email address |
| password | Encrypted password |
| phone | Contact number |
| role | User role (Admin / Customer) |

**Constraints**
- `email` must be **unique**
- `user_id` is the **primary key**

---

### 2. Vehicles Table
Stores all vehicles available for rent.

**Fields**

| Column | Description |
|------|-------------|
| vehicle_id (PK) | Unique vehicle identifier |
| vehicle_name | Name of vehicle |
| type | Type (car / bike / truck) |
| model | Vehicle model |
| registration_number | Unique registration number |
| rental_price | Daily rental cost |
| availability_status | available / rented / maintenance |

**Constraints**
- `registration_number` must be **unique**
- `vehicle_id` is the **primary key**

---

### 3. Bookings Table
Stores all rental bookings.

**Fields**

| Column | Description |
|------|-------------|
| booking_id (PK) | Unique booking identifier |
| customer_id (FK) | References Users table |
| vehicle_id (FK) | References Vehicles table |
| rent_start_date | Rental start date |
| rent_end_date | Rental end date |
| booking_status | pending / confirmed / completed / cancelled |
| total_cost | Total rental cost |

**Constraints**
- `customer_id` → **Foreign Key referencing Users**
- `vehicle_id` → **Foreign Key referencing Vehicles**

---

## Entity Relationships

**One → Many:** Users → Bookings  
A single user can make multiple bookings.

**Many → One:** Bookings → Vehicles  
Many bookings can refer to the same vehicle.

**Logical One → One:** Each booking references exactly one user and one vehicle.

---

## ERD Diagram

The full **Entity Relationship Diagram** was created using **drawsql.app**.  

ERD Link:  
[https://drawsql.app/teams/md-shafiqul/diagrams/vehicle-rental-system]

The ERD includes:

- Primary Keys
- Foreign Keys
- Relationship Cardinality
- Status fields

---

## SQL Queries

### Query 1 – Booking Information with Customer and Vehicle

Retrieve booking details with the customer and vehicle name.

```sql
SELECT
  booking_id,
  user_name AS customer_name,
  vehicle_name,
  rent_start_date AS start_date,
  rent_end_date AS end_date,
  booking_status AS status
FROM
  bookings
  JOIN users ON bookings.customer_id = users.user_id
  JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;
```

### Query 2 – Vehicles Never Booked

Find vehicles that have never been booked.

```sql
SELECT
  *
FROM
  vehicles
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      bookings
    WHERE
      bookings.vehicle_id = vehicles.vehicle_id
  );
```

### Query 3 – Available Vehicles by Type

Retrieve all available vehicles of a specific type.

```sql
SELECT
  *
FROM
  vehicles
WHERE
  type = 'car'
  AND availability_status = 'available'
```

### Query 4 – Vehicles with More Than 2 Bookings

Find vehicles that have more than 2 bookings.

```sql
SELECT
  vehicle_name,
  count(*)
FROM
  bookings
  JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id
GROUP BY
  vehicle_name
HAVING
  count(*) > 2
```
