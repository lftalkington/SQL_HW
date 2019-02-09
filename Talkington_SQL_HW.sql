-- first and last names of all actors from the table actor; smoosh together and rename Actor Name
SELECT first_name, last_name
From actor a
ORDER BY 1 ASC;

SELECT
 CONCAT (
 UPPER (first_name),
 UPPER (last_name)
 ) as Actor_Name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor a
WHERE a.first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT last_name
FROM actor a
WHERE a.last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name
FROM actor a
WHERE a.last_name LIKE '%LI%'
ORDER BY last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country
WHERE Country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
-- ALTER TABLE actor
-- ADD column actor_description BLOB;
-- 
-- SELECT * from actor;
-- 
-- -- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
-- ALTER TABLE actor
-- drop column actor_description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) as 'Last Name Count'
FROM actor a
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name) AS 'Last Name Similar'
FROM actor
GROUP BY last_name
HAVING `Last Name Similar` >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
-- UPDATE actor a
-- SET first_name = 'Harpo' and last_name = 'Williams'
-- WHERE first_name = 'Groucho' and last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
-- UPDATE actor
--  SET first_name = 
--  CASE 
--  WHEN first_name = 'HARPO' 
--  THEN 'GROUCHO'
-- END;
-- 
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;
-- 
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
-- 
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s 
JOIN address a ON s.address_id=a.address_id; 

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- SELECT s.staff_id, p.amount, count(p.amount)
-- FROM staff s 
-- JOIN payment p ON s.staff_id = p.staff_id
-- GROUP BY p.amount;

SELECT first_name, last_name, SUM(amount)
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id
ORDER BY last_name ASC;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT title, count(actor_id)
FROM film_actor fa
JOIN film ON film.film_id = fa.film_id
GROUP BY title;


-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT first_name ,last_name, SUM(amount)
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id=
	(SELECT language_id
    FROM language
    WHERE name= 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT fl.title, fl.category
FROM film_list fl
Where title = "family"; -- returns no data

SELECT fl.title, fl.category
FROM film_list fl
Where category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT title, COUNT(f.film_id) AS Rented_Movie_Count
FROM  film f
JOIN inventory i ON (f.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_id)
GROUP BY title 
ORDER BY Rented_Movie_Count DESC; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = st.store_id
GROUP BY s.store_id
ORDER BY 1 ASC;


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city_id, ct.country_id
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c on a.city_id = c.city_id
JOIN country ct ON c.country_id = ct.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name AS top_five, SUM(amount) AS gross_revenue
FROM category c JOIN film_category fc
ON  c.category_id = fc.category_id 
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY top_five 
ORDER BY gross_revenue  
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_gross AS

SELECT name AS top_five, SUM(amount) AS gross_revenue
FROM category c JOIN film_category fc
ON  c.category_id = fc.category_id 
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY top_five 
ORDER BY gross_revenue  
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_gross;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_gross;
-- 