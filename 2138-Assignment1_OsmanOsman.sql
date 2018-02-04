/*

NAME: OSMAN OSMAN
ID: 100962928
CRN: 

*/

--#1
SELECT categories.category_name, COUNT(products.product_id) AS Count,
MAX(products.list_price) AS MostExpensive
FROM mgs.categories
JOIN mgs.products
ON categories.category_id = products.category_id
GROUP BY categories.category_name
ORDER BY COUNT(products.product_id) DESC;

--#2
SELECT customers.email_address,
SUM(order_items.item_price * order_items.quantity) AS item_price_total,
SUM(order_items.discount_amount * order_items.quantity) AS discount_amount_total
FROM mgs.customers JOIN mgs.order_items
ON customers.customer_id = order_items.order_id
GROUP BY customers.email_address
ORDER BY item_price_total DESC;

--#3
SELECT customers.email_address, COUNT(orders.order_id) AS OrderCount,
(SUM(order_items.item_price) - SUM(order_items.discount_amount)) *
SUM(order_items.quantity) AS TotalAmount
FROM mgs.customers
JOIN mgs.orders
ON customers.customer_id = orders.order_id
JOIN order_items
ON orders.order_id = order_items.order_id
GROUP BY customers.email_address
HAVING COUNT(orders.order_id) > 1
ORDER BY SUM(order_items.item_price) DESC;

--#4
SELECT products.product_name,
SUM(products.list_price - ( products.list_price * products.discount_percent ) * order_items.quantity) AS TotalAmount
FROM mgs.products
JOIN mgs.order_items
ON products.product_id = order_items.product_id
GROUP  BY Rollup(products.product_name);

--#5
SELECT customers.email_address,
COUNT(DISTINCT order_items.product_id) AS ProductCount
FROM mgs.customers
JOIN mgs.orders
ON customers.customer_id = orders.customer_id
JOIN mgs.order_items
ON orders.order_id = order_items.order_id
GROUP BY customers.email_address
HAVING COUNT(orders.customer_id) > 1;

--#6
SELECT DISTINCT category_name 
FROM categories 
WHERE category_name
IN(SELECT DISTINCT category_name FROM products)
ORDER BY category_name;

--#7
SELECT products.product_name, products.list_price
FROM products
WHERE products.list_price > (SELECT AVG(products.list_price)
FROM products
WHERE products.list_price > 0)
ORDER BY products.list_price DESC;

--#8
SELECT categories.category_name
FROM mgs.categories
WHERE NOT EXISTS(SELECT category_id FROM products);

--#9
/*
SELECT p1.product_name, p1.discount_percent
FROM mgs.products AS p1 
WHERE p1.discount_percent NOT IN
(SELECT p2.discount_percent
FROM mgs.products AS p2
WHERE p1.product_name < > p2.product_name)
ORDER BY products.product_name;
*/
SELECT a.product_name, a.discount_percent
FROM products a
JOIN (SELECT discount_percent
FROM products 
GROUP BY discount_percent
HAVING COUNT(discount_percent) = 1) b
ON a.discount_percent = b.discount_percent;

--#10
/*
SELECT customers.email_address, orders.order_id, orders.order_date
FROM mgs.customers
INNER JOIN mgs.orders
ON customers.customer_id = orders.customer_id
WHERE orders.order_date = (SELECT MIN(orders.order_date))
GROUP BY customers.customer_id;
*/

SELECT email_address, order_id, order_date
FROM customers c natural join orders
WHERE order_date = 
  (SELECT min(order_date)
  FROM orders o);
