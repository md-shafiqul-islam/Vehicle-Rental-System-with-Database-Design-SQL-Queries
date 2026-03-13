-- create users table
CREATE TABLE users (
  user_id serial PRIMARY KEY,
  role varchar(20) NOT NULL CHECK (role IN ('Admin', 'Customer')),
  user_name varchar(100) NOT NULL,
  email varchar(50) UNIQUE NOT NULL,
  phone_number varchar(20) NOT NULL
)
-- create vehicles table
CREATE TABLE vehicles (
  vehicle_id serial PRIMARY KEY,
  vehicle_name varchar(100) NOT NULL,
  type varchar(20) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
  model varchar(30) NOT NULL,
  registration_number varchar(30) UNIQUE NOT NULL,
  rent_price numeric(10, 2) NOT NULL,
  availability_status varchar(30) NOT NULL CHECK (
    availability_status IN ('available', 'rented', 'maintenance')
  )
)
-- create bookings table
CREATE TABLE bookings (
  booking_id serial PRIMARY KEY,
  customer_id int NOT NULL REFERENCES users (user_id) ON DELETE CASCADE,
  vehicle_id int NOT NULL REFERENCES vehicles (vehicle_id) ON DELETE CASCADE,
  rent_start_date date NOT NULL,
  rent_end_date date NOT NULL CHECK (rent_end_date > rent_start_date),
  booking_status varchar(30) NOT NULL CHECK (
    booking_status IN ('pending', 'confirmed', 'completed', 'cancelled')
  ),
  total_cost numeric(10, 2) NOT NULL CHECK (total_cost > 0)
)
-- insert data for users table
INSERT INTO
  users (role, user_name, email, phone_number)
VALUES
  (
    'Admin',
    'Rahim Uddin',
    'rahim.admin@example.com',
    '01711111111'
  ),
  (
    'Customer',
    'Karim Hasan',
    'karim@example.com',
    '01722222222'
  ),
  (
    'Customer',
    'Nusrat Jahan',
    'nusrat@example.com',
    '01733333333'
  ),
  (
    'Customer',
    'Tanvir Ahmed',
    'tanvir@example.com',
    '01744444444'
  ),
  (
    'Customer',
    'Mim Akter',
    'mim@example.com',
    '01755555555'
  );


-- insert data for vehicles table
INSERT INTO
  vehicles (
    vehicle_name,
    type,
    model,
    registration_number,
    rent_price,
    availability_status
  )
VALUES
  (
    'Toyota Corolla',
    'car',
    '2020',
    'DHK-1234',
    5000,
    'available'
  ),
  (
    'Honda Civic',
    'car',
    '2019',
    'DHK-5678',
    4500,
    'available'
  ),
  (
    'Yamaha R15',
    'bike',
    '2022',
    'DHK-9012',
    1500,
    'available'
  ),
  (
    'Suzuki Gixxer',
    'bike',
    '2021',
    'DHK-3456',
    1400,
    'maintenance'
  ),
  (
    'Tata Truck',
    'truck',
    '2018',
    'DHK-7890',
    8000,
    'available'
  );


-- insert data for bookings table
INSERT INTO
  bookings (
    customer_id,
    vehicle_id,
    rent_start_date,
    rent_end_date,
    booking_status,
    total_cost
  )
VALUES
  (
    2,
    1,
    '2026-03-01',
    '2026-03-03',
    'completed',
    10000
  ),
  (
    3,
    3,
    '2026-03-05',
    '2026-03-07',
    'completed',
    3000
  ),
  (
    4,
    2,
    '2026-03-10',
    '2026-03-12',
    'confirmed',
    9000
  ),
  (5, 1, '2026-03-15', '2026-03-16', 'pending', 5000),
  (
    2,
    5,
    '2026-03-18',
    '2026-03-20',
    'confirmed',
    16000
  );


-- Operations
-- Query 1: JOIN, Retrieve booking information along with: Customer name and Vehicle name
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
  JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id


-- Query 2: EXISTS
-- Find all vehicles that have never been booked.
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


-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).
SELECT
  *
FROM
  vehicles
WHERE
  type = 'car'
  AND availability_status = 'available'


-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
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