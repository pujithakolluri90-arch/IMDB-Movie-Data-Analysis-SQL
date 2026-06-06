/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:






-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name AS table_name,
table_rows AS no_of_rows
FROM information_schema.tables
WHERE table_schema='imdb';



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_nulls_count,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls_count,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls_count,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls_count,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls_count,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls_count,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls_count,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls_count,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls_count
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT MONTH(date_published), COUNT(id) AS number_of_movies FROM movie
GROUP BY MONTH(date_published)
ORDER BY number_of_movies DESC;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS number_of_movies FROM movie
WHERE (country LIKE '%USA%'
OR country LIKE '%India%')
AND year='2019';



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, COUNT(movie_id) AS movie_count FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH summary AS (
SELECT g.movie_id, COUNT(genre) AS genre_count FROM movie m
JOIN genre g ON m.id=g.movie_id
GROUP BY g.movie_id
HAVING genre_count=1)
SELECT COUNT(movie_id) AS no_of_movies FROM summary;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre, ROUND(AVG(duration),2) AS avg_duration FROM movie m
JOIN genre g ON m.id=g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH summary AS (
SELECT genre, COUNT(m.id) AS movie_count, 
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM movie m
JOIN genre g ON m.id=g.movie_id
GROUP BY genre)
SELECT * FROM summary
WHERE genre='Thriller';



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
MAX(avg_rating) AS max_rating,
MIN(avg_rating) AS min_rating,
MAX(total_votes) AS max_votes,
MIN(total_votes) AS min_votes,
MAX(median_rating) AS max_median_rating,
MIN(median_rating) AS min_median_rating
FROM ratings;
use imdb;