/*
for each pair of city and product , return the names of the city and product, 
as well as the total amount spent on the product to 2 decimal places. order the
result by amount spent from high to low then by city name and product name in ascending order.

So, for each city and product, we want:

city_name

product_name

total_amount_spent = SUM of the total spent on that product in that city.

We’ll need to join tables that can link customers → city → invoices → invoice_items → products.

To get total spent per city and product:

Start from invoice_item (since total_price is there)

Join back step by step to reach city and product

Group by city_name and product_name

Aggregate using SUM(total_price)
*/

SELECT 
    c.city_name,
    p.product_name,
    ROUND(SUM(ii.total_price), 2) AS total_amount_spent
FROM invoice_item ii
JOIN invoice i ON ii.invoice_id = i.invoice_id
JOIN customer cu ON i.customer_id = cu.customer_id
JOIN city c ON cu.city_id = c.city_id
JOIN product p ON ii.product_id = p.product_id
GROUP BY c.city_name, p.product_name
ORDER BY total_amount_spent DESC, c.city_name ASC, p.product_name ASC;
