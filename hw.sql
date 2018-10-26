USE sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

#Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(concat(first_name, ' ', last_name)) AS "Actor Name" FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
#What is one query would you use to obtain this information?

SELECT * FROM actor
WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, 
#in that order:
SELECT * FROM actor
WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country, country_id FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name varchar(30) AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
#Blob is a binary large object that can hold a variable amount of data
ALTER TABLE actor MODIFY COLUMN middle_name BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) 
FROM actor 
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) FROM actor
GROUP BY last_name HAVING COUNT(last_name) >= 2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's 
#husband's yoga teacher. Write a query to fix the record.
#select * from actor
#where first_name = 'Groucho';

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = "WILLIAMS";

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the 
#first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor 
#will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record 
#using a unique identifier.)
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

select * from actor where last_name = "WILLIAMS";

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, staff.address_id, address.address_id, address.address, address.address2, address.city_id
FROM staff
JOIN address 
ON staff.address_id = address.address_id; 

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with 
#the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters
#K and Q whose language is English.
SELECT title FROM film
WHERE title LIKE 'Q%' OR title LIKE'K%';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id 
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = "Alone Trip")
)
;

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
#addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, 
address.address_id, address.address
FROM customer
JOIN address
on customer.address_id = address.address_id; 

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT title,name
FROM film
JOIN film_category
ON film_category.film_id = film.film_id
JOIN category 
ON category.category_id = film_category.category_id
WHERE name = 'family';

#7e. Display the most frequently rented movies in descending order.
SELECT film.title, COUNT(film.title) AS "Rental Totals"
FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY title 
ORDER BY COUNT(film.title) DESC; 

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT staff_id AS "Store", (concat('$', format(sum(amount), 2))) AS "Revenue"
FROM payment
GROUP BY staff_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
GROUP BY country;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name AS "Genre", sum(amount) AS "Gross Revenue" 
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film_category.film_id = film.film_id
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment. rental_id
GROUP BY name
ORDER BY sum(amount) DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_view AS
SELECT name AS "Genre", sum(amount) AS "Gross Revenue" 
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film_category.film_id = film.film_id
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment. rental_id
GROUP BY name
ORDER BY sum(amount) DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * 
FROM genre_view;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW genre_view;