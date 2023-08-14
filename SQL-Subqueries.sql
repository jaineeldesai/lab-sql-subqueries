-- LAB | SQL Subqueries

USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT 
    film_id, COUNT(film_id) AS copies
FROM
    sakila.inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film
        WHERE
            title = 'Hunchback Impossible')
GROUP BY film_id;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
 
 SELECT 
    *
FROM
    sakila.film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            sakila.film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT 
    actor_id, first_name, last_name
FROM
    sakila.actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            sakila.film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title = 'Alone Trip'));
                    
                    
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
 
SELECT 
    film_id, title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    sakila.category
                WHERE
                    name = 'Family'));
 
 -- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
 
 -- using subquery
 SELECT first_name,last_name,email FROM sakila.customer
 WHERE address_id IN (
  SELECT address_id FROM sakila.address
  WHERE city_id IN(
   SELECT city_id FROM sakila.city
   WHERE country_id IN(
    SELECT country_id FROM sakila.country
    WHERE country='Canada') ) );
 
 -- using join
 
 SELECT first_name,last_name,email 
 FROM sakila.customer c
 JOIN sakila.address a
 ON c.address_id=a.address_id
 JOIN sakila.city ci
 ON a.city_id=ci.city_id
 JOIN sakila.country co
 ON ci.country_id=co.country_id
 WHERE co.country='Canada';
 
 -- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
 -- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT title FROM sakila.film
WHERE film_id IN (
 SELECT film_id FROM sakila.film_actor
 WHERE actor_id IN (
  SELECT actor_id FROM (
   SELECT actor_id, COUNT(film_id) as film_count 
   FROM sakila.film_actor
   GROUP BY actor_id
   ORDER by film_count DESC
   LIMIT 1) ct ) );
 

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- Can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT title FROM sakila.film
WHERE film_id IN  (
 SELECT film_id FROM sakila.inventory 
 WHERE inventory_id IN (
  SELECT inventory_id FROM sakila.rental
  WHERE customer_id IN (
   SELECT customer_id FROM (
    SELECT customer_id, SUM(amount) as total_amount
    FROM  sakila.payment
    GROUP BY customer_id
    ORDER BY total_amount DESC
    LIMIT 1) amt ) ) );

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) as total_amt
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > (
 SELECT AVG(total_amt) FROM (
  SELECT customer_id, SUM(amount) as total_amt
  FROM sakila.payment
  GROUP BY customer_id) amt );
  