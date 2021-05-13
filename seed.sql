-- JOIN SECTION

SELECT * FROM invoice i 
JOIN invoice_line il ON il.invoice_id = i.invoice_id 
WHERE il.unit_price > 0.99;

SELECT i.invoice_date, c.first_name, c.last_nae, i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;

SELECT pt.track_id
FROM playlist_track pt
JOIN playlist pl ON pl.playlist_id = pt.playlist_id
WHERE pl.name = 'Music';

SELECT t.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

SELECT t.name, pl.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
JOIN playlist pl ON pl.playlist_id = pt.playlist_id;

SELECT t.name, a.title
FROM track t
JOIN album a ON a.album_id = t.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

-- NESTED QUERIES

SELECT *
FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);

SELECT *
FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE name = 'Music');

SELECT name
FROM track
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5);

SELECT *
FROM track
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy');

SELECT *
FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE title = 'Fireball');

SELECT *
FROM track 
WHERE album_id IN (
  SELECT album_id 
  FROM album 
  WHERE artist_id IN (
    SELECT artist_id
    FROM artist
    WHERE name = 'Queen'
  )
);

-- UPDATING ROWS

UPDATE customer
SET fax = null
WHERE fax IS NOT null;

UPDATE customer 
SET company = 'Self'
WHERE company IS null;

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

UPDATE tracks
SET composer = 'The darkness around us'
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS null;

-- GROUP BY

SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
WHERE  g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name; 

SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

-- USE DISTINCT

SELECT DISTINCT composer
FROM track;

SELECT DISTINCT billing_postal_code
FROM invoice;

SELECT DISTINCT company
FROM customer;

-- DELETE ROWS

DELETE 
FROM practice_delete
WHERE type = 'bronze';

DELETE
FROM practice_delete
WHERE type = 'silver';

DELETE
FROM practice_delete
WHERE value = 150;

-- ECOMMERCE SITUATION PRACTICE

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY, 
  name VARCHAR(100), 
  email VARCHAR(100)
);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY, 
  name VARCHAR(100), 
  price DECIMAL
);
  
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY, 
  product_id INTEGER,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO users (name, email)
VALUES ('Adam', 'email@gmail.com');

INSERT INTO users (name, email)
VALUES ('Apaul', 'something@gmail.com');

INSERT INTO users (name, email)
VALUES ('Pdam', 'placeholder@gmail.com');

INSERT INTO products (name, price) 
VALUES ('Blue Rupee', 5.00);

INSERT INTO products (name, price) 
VALUES ('Purple Rupee', 50.00);

INSERT INTO products (name, price) 
VALUES ('Gold Rupee', 300.00);

INSERT INTO orders (product_id) VALUES (1);

INSERT INTO orders (product_id) VALUES (2);

INSERT INTO orders (product_id) VALUES (3);

SELECT * 
FROM products
WHERE product_id IN (
  SELECT order_id
  FROM orders
  WHERE order_id = 1
);

SELECT *
FROM products
WHERE product_id IN (
  SELECT order_id
  FROM orders
);

SELECT SUM(price)
FROM products
WHERE product_id IN (
  SELECT order_id
  FROM orders
  WHERE order_id = 3;
);

ALTER TABLE orders
ADD user_id INTEGER;

ALTER TABLE orders
ADD FOREIGN KEY (user_id) REFERENCES users(user_id);

UPDATE orders
SET user_id = 1
WHERE order_id = 1;

UPDATE orders
SET user_id = 2
WHERE order_id = 2;

UPDATE orders
SET user_id = 3
WHERE order_id = 3;

SELECT u.name, p.name, p.price
FROM users u
JOIN products p ON p.product_id = o.product_id
JOIN orders o ON u.user_id = o.user_id;

SELECT u.name, COUNT(*)
FROM users u
JOIN orders o ON o.user_id = u.user_id
WHERE u.name = 'Pdam'
GROUP BY u.name;