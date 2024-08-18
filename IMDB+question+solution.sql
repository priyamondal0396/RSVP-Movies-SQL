USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

/* CHECKING MOVIE TABLE 
SELECT 
    *
FROM
    MOVIE;
    
SELECT 
    COUNT(ID) AS ID_COUNT,
    COUNT(DISTINCT (ID)) AS DISTINCT_ID_COUNT
FROM
    MOVIE;
-- 7997 COUNT AND DISTINCT COUNT FOR ID COLUMN
*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS count_movie
FROM
    movie;
-- 7997
SELECT 
    COUNT(*) AS count_genre
FROM
    genre;
-- 14662
SELECT 
    COUNT(*) AS count_director
FROM
    director_mapping;
-- 3867
SELECT 
    COUNT(*) AS count_name
FROM
    names;
-- 25735
SELECT 
    COUNT(*) AS count_ratings
FROM
    ratings;
-- 7997
SELECT 
    COUNT(*) AS count_role_mapping
FROM
    role_mapping;
-- 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN ID IS NULL THEN 1
        ELSE 0
    END) AS ID_NULLCOUNT,
    SUM(CASE
        WHEN TITLE IS NULL THEN 1
        ELSE 0
    END) AS TITLE_NULLCOUNT,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS YEAR_NULLCOUNT,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS DATE_PUBLISHED_NULLCOUNT,
    SUM(CASE
        WHEN DURATION IS NULL THEN 1
        ELSE 0
    END) AS DURATION_NULLCOUNT,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS COUNTRY_NULLCOUNT,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS WORLWIDE_GROSS_INCOME_NULLCOUNT,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS LANGUAGES_NULLCOUNT,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS PRODUCTION_COMPANY_NULLCOUNT
FROM
    MOVIE;

/* 
 OBSERVATIONS :
COUNTRY_NULLCOUNT 20, WORLWIDE_GROSS_INCOME_NULLCOUNT - 3724, LANGUAGES_NULLCOUNT - 194, PRODUCTION_COMPANY_NULLCOUNT - 528
*/

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

-- 1st Output

SELECT 
    year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year
ORDER BY year;

--  OBSERVATIONS :
-- MAXIMUM MOVIES WERE PRODUCED IN THE YEAR 2017

-- 2nd Output

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY number_of_movies desc;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- MAIN CODE 

SELECT 
    COUNT(ID) AS COUNT_ID
FROM
    movie
WHERE
    (UPPER(COUNTRY) LIKE '%USA%'
        OR UPPER(COUNTRY) LIKE '%INDIA%')
        AND YEAR = 2019;

--  OBSERVATIONS :
-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;

--  OBSERVATIONS :
-- 13 Unique list of the genres present in the data set

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

/*
 SELECT A.GENRE, COUNT(B.ID) AS No_of_movies 
FROM GENRE AS A
INNER JOIN MOVIE AS B
ON A.movie_id= B.ID
 WHERE YEAR= 2019
GROUP BY A.GENRE
ORDER BY No_of_movies desc
limit 1;
*/

--  OBSERVATIONS :
-- 1078 MOVIES WERE PRODUCED IN THE YEAR 2019 WHICH BELONGED TO DRAMA GENRE

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    A.GENRE, COUNT(B.ID) AS No_of_movies
FROM
    GENRE AS A
        INNER JOIN
    MOVIE AS B ON A.movie_id = B.ID
GROUP BY A.GENRE
ORDER BY No_of_movies DESC
LIMIT 1;

-- OBSERVATIONS :
-- TOTAL 4285 MOVIES WERE PRODUCED WHICH BELONGED TO DRAMA GENRE.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- checking Genre table 
-- SELECT * FROM GENRE;

-- Main Query
WITH GENRE_PER_MOVIE_ID_CTE AS (
SELECT MOVIE_ID, 
	   COUNT(GENRE) AS GENRE_PER_MOVIE_ID
FROM GENRE
GROUP BY MOVIE_ID
HAVING GENRE_PER_MOVIE_ID=1
)
SELECT 
    COUNT(*) AS COUNT_OF_1_GENRE_MOVIE
FROM
    GENRE_PER_MOVIE_ID_CTE;

-- OBSERVATIONS :

-- There are 3289 movies which belong to a single genre.

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

-- CHECKING table MOVIE
-- select * from movie;
-- CHECKING TABLE GENRE
-- select * from genre;

-- MAIN QUERY
SELECT 
    B.GENRE, ROUND(AVG(A.DURATION), 2) AS AVG_DURATION
FROM
    MOVIE AS A
        INNER JOIN
    GENRE AS B ON A.ID = B.MOVIE_ID
GROUP BY GENRE
ORDER BY AVG_DURATION DESC;

-- ACTION MOVIES ARE OF THE LONGEST DURATION OF 112.88, FOLLOWED BY ROMANCE OF DURATION 109.53

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

WITH THRILLER_MOVIE_RANK_CTE AS (
SELECT GENRE, 
	   COUNT(MOVIE_ID) AS MOVIE_COUNT,
       RANK() OVER (ORDER BY COUNT(MOVIE_ID) DESC) AS GENRE_RANK
FROM GENRE 
GROUP BY  GENRE
)
SELECT * FROM THRILLER_MOVIE_RANK_CTE
WHERE UPPER(GENRE)= 'THRILLER';

-- OBSERVATIONS :
-- Thriller genre has Rank 3 and its movie count is 1484.

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
-- checking ratings table.
-- select * from ratings;

-- Main code

SELECT 
    MIN(AVG_RATING) AS MIN_AVG_RATING,
    MAX(AVG_RATING) AS MAX_AVG_RATING,
    MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES,
    MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
    MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
    MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM
    RATINGS;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH MOVIE_RANK_CTE AS (
SELECT A.TITLE,
       B.AVG_RATING,
       DENSE_RANK() OVER (ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM MOVIE AS A
INNER JOIN RATINGS AS B
ON A.ID= B.MOVIE_ID
GROUP BY A.TITLE,B.AVG_RATING
)
SELECT * 
FROM MOVIE_RANK_CTE
WHERE MOVIE_RANK<=10;

-- OBSERVATIONS :
 
-- 40 SUCH MOVIES.
-- KIRKET AND LOVE IN KILNERRY HAVE AVG_RATING OF 10

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- CHECKING RATINGS TABLE-
-- SELECT * FROM RATINGS;

-- MAIN CODE

SELECT 
    MEDIAN_RATING, COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM
    ratings
GROUP BY MEDIAN_RATING
ORDER BY MOVIE_COUNT DESC;

-- MEDIAN RATING 7 MOVIES HAVE THE HIGHEST COUNT OF 2257, FOLLOWED BY MEDIAN_RATING 6 AND 8.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH PROD_COMPANY_RANK_CTE AS (
SELECT A.PRODUCTION_COMPANY,
	   COUNT(A.ID) AS MOVIE_COUNT,
       DENSE_RANK() OVER (ORDER BY COUNT(A.ID)  DESC) AS PROD_COMPANY_RANK
FROM MOVIE AS A
INNER JOIN RATINGS AS B
ON A.ID= B.MOVIE_ID
WHERE B.AVG_RATING> 8 AND A.PRODUCTION_COMPANY IS NOT NULL
GROUP BY A.PRODUCTION_COMPANY
)
SELECT PRODUCTION_COMPANY, MOVIE_COUNT, PROD_COMPANY_RANK
FROM PROD_COMPANY_RANK_CTE
;

-- BOTH DREAM WARRIOR PICTURES AND NATIONAL THEATRE LIVE HAVE PRODUCED THE MOST NO OF HIT MOVIES WITH COUNT OF 3

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* TABLES USED 
1. GENER
2. MOVIE
3. RATINGS */

-- CHECKING MOVIE TABLE-
-- SELECT * FROM MOVIE;

-- MAIN CODE

SELECT 
    A.GENRE, COUNT(A.MOVIE_ID) AS MOVIE_COUNT
FROM
    GENRE AS A
        INNER JOIN
    MOVIE AS B ON A.MOVIE_ID = B.ID
        INNER JOIN
    RATINGS AS C ON A.MOVIE_ID = C.MOVIE_ID
WHERE
    MONTH(DATE_PUBLISHED) = 3
        AND YEAR = 2017
        AND UPPER(COUNTRY) LIKE '%USA%'
        AND C.TOTAL_VOTES > 1000
GROUP BY A.GENRE
ORDER BY MOVIE_COUNT DESC;
       
-- OBSERVATION :

-- DRAMA AND THRILLER TOP THE LIST WITH 24 AND 9 NO. OF MOVIES RESPECTIVELY, FAMILY GENRE HAS ONLY 1 VOTE.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/* TABLES USED 
1. GENER
2. MOVIE
3. RATINGS */

SELECT 
    A.TITLE, B.AVG_RATING, C.GENRE
FROM
    MOVIE AS A
        INNER JOIN
    RATINGS AS B ON A.ID = B.MOVIE_ID
        INNER JOIN
    GENRE AS C ON A.ID = C.MOVIE_ID
WHERE
    A.TITLE LIKE 'THE%' AND B.AVG_RATING > 8
GROUP BY A.TITLE , B.AVG_RATING , C.GENRE
ORDER BY B.AVG_RATING DESC;

-- OBSERVATION :

-- THERE ARE 8 DISTINCT MOVIES OF EACH GENRE THAT START WITH THE WORD ‘THE’
-- THE BRIGHTON MIRACLE IS THE HIGHEST AVERAGE RATING MOVIE WHICH COMES UNDER DRAMA GENRE.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/* TABLES USED 
1. MOVIE
2. RATINGS */

SELECT 
    COUNT(ID) AS MOVIE_COUNT
FROM
    MOVIE AS A
        INNER JOIN
    RATINGS AS B ON A.ID = B.MOVIE_ID
WHERE
    A.DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01'
        AND B.MEDIAN_RATING = 8;

-- OBSERVATION :

-- 361 MOVIES WERE RELEASED BETWEEN 1 APRIL 2018 AND 1 APRIL 2019 WITH MEDIAN RATING OF 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/* TABLES USED 
1. MOVIE
2. RATINGS */

-- CHECKING MOVIE TABLE
/* 
SELECT sum(total_votes) FROM MOVIE as A inner join ratings as b 
on a.id= b.movie_id
where upper(languages) LIKE '%GERMAN%';
*/

-- MAIN CODE
WITH LANG_SUMMARY_CTE AS (
SELECT LANGUAGES, 
	   SUM(TOTAL_VOTES) AS TOTAL_NO_OF_VOTES,
       CASE WHEN UPPER(LANGUAGES) LIKE '%ITALIAN%' THEN 'ITALIAN' ELSE '-' END AS LANG
FROM MOVIE AS M 
INNER JOIN RATINGS AS R
 ON R.MOVIE_ID = M.ID 
 WHERE LANGUAGES LIKE '%ITALIAN%'
 GROUP BY LANGUAGES, LANG
 UNION 
 SELECT LANGUAGES, 
	    SUM(TOTAL_VOTES) AS TOTAL_NO_OF_VOTES,
        CASE WHEN UPPER(LANGUAGES) LIKE '%GERMAN%' THEN 'GERMAN' ELSE '-'  END AS LANG
 
 FROM MOVIE AS M INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID 
 WHERE LANGUAGES LIKE '%GERMAN%' 
 GROUP BY LANGUAGES, LANG
 ORDER BY TOTAL_NO_OF_VOTES DESC
 )
 SELECT LANG, SUM(TOTAL_NO_OF_VOTES) AS TOTAL_NO_OF_VOTES
 FROM LANG_SUMMARY_CTE
 GROUP BY LANG;

-- OBSERVATION :

-- YES, GERMAN MOVIES HAVE MORE VOTES THAN ITALIAN MOVIES.

-- # lang	total_no_of_votes
-- GERMAN	      4421525
-- ITALIAN	      2559540

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM NAMES;

-- OBSERVATION :

/*THERE ARE NO NULL VALUES IN NAME COLUMN, HEIGHT HAS 17335 NULL VALUES,
DATE OF BIRTH HAS 13431 NULL VALUES AND KNOWN_FOR_MOVIES HAS 15226 NULL VALUES.*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* TABLES USED 
1. NAMES
2. RATINGS 
3. GENRE*/

-- CHECKING TABLES
-- SELECT * FROM NAMES;
-- SELECT * FROM director_mapping;

/*HERE IN THE FIRST PART WE ARE ONLY FETCHING THE TOP 3 GENRE MOVIES BASED ON MOVIE COUNT WHERE AVG_RATING>8 */
WITH TOP_3_GENRES AS (
SELECT A.GENRE, COUNT(B.ID) AS MOVIE_COUNT,
DENSE_RANK() OVER (ORDER BY COUNT(B.ID) DESC) AS GENRE_RANK
FROM GENRE AS A 
INNER JOIN MOVIE AS B ON A.MOVIE_ID = B.ID
INNER JOIN RATINGS AS C ON B.ID = C.MOVIE_ID
WHERE C.AVG_RATING>8
GROUP BY A.GENRE
ORDER BY MOVIE_COUNT DESC
LIMIT 3
)
/*HERE WE ARE FETCHING TOP 3 DIRECTORS CONNECTED TO TOP 3 GENRES AND WHERE AVG_RATING>8 */
SELECT B.NAME AS DIRECTOR_NAME,
COUNT(A.MOVIE_ID) AS MOVIE_COUNT
FROM DIRECTOR_MAPPING AS A  
	INNER JOIN NAMES AS B ON A.NAME_ID = B.ID
	INNER JOIN RATINGS AS C ON A.MOVIE_ID = C.MOVIE_ID
	INNER JOIN GENRE AS D ON A.MOVIE_ID = D.MOVIE_ID
    INNER JOIN TOP_3_GENRES AS E ON D.GENRE = E.GENRE
WHERE C.AVG_RATING>8
GROUP BY B.NAME
ORDER BY MOVIE_COUNT DESC 
LIMIT 3;

-- OBSERVATION :

-- JAMES MANGOLD HAS DIRECTED 4 MOVIES WHICH BELONG TO THE TOP 3 MOST RATED(AVG_RATING > 8) GENRES.

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/* TABLES USED 
1. ROLE_MAPPING
2. RATINGS 
3. NAMES*/
-- checking table role_mapping
-- select * from role_mapping;

WITH TOP2_ACTORS AS (
SELECT (B.NAME) AS ACTOR_NAME, COUNT(A.MOVIE_ID) AS MOVIE_COUNT,
ROW_NUMBER() OVER (ORDER BY COUNT(A.MOVIE_ID) DESC) AS RANKING
FROM ROLE_MAPPING AS A 
INNER JOIN NAMES AS B ON A.NAME_ID= B.ID
INNER JOIN RATINGS AS C ON A.MOVIE_ID = C.MOVIE_ID
WHERE C.MEDIAN_RATING >=8
GROUP BY ACTOR_NAME
)
SELECT ACTOR_NAME, MOVIE_COUNT
FROM TOP2_ACTORS
WHERE RANKING<=2;

-- OBSERVATIONS :

-- TOP 2 ACTORS WITH HIGHEST RATED MOVIES ARE MAMMOOTTY	WITH 8 SUCH FILMS AND MOHANLAL WITH	5 HIGH RATED MOVIES.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
/* TABLES USED 
1. MOVIE
2. RATINGS */

WITH TOP3_PRODUCTION_COMPANY AS (
SELECT A.PRODUCTION_COMPANY, SUM(B.TOTAL_VOTES) AS VOTE_COUNT,
RANK() OVER (ORDER BY SUM(B.TOTAL_VOTES) DESC) AS PROD_COMP_RANK
FROM MOVIE AS A 
INNER JOIN RATINGS AS B ON A.ID= B.MOVIE_ID
WHERE  A.PRODUCTION_COMPANY IS NOT NULL
GROUP BY A.PRODUCTION_COMPANY
)
SELECT * FROM TOP3_PRODUCTION_COMPANY
WHERE PROD_COMP_RANK <=3;

-- OBSERVATIONS :

/* THE TOP 3 PRODUCTION HOUSES AND THEIR RESPECTIVE VOTE_COUNTS ARE -
Marvel Studios - 2656967
Twentieth Century Fox - 2411163
Warner Bros. - 2396057
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/* TABLES USED 
1. ROLE_MAPPING
2. RATINGS
3. NAMES 
4. MOVIE */

WITH ACTOR_NAME_SUMMARY AS(
SELECT A.NAME AS ACTOR_NAME, SUM(C.TOTAL_VOTES) AS TOTAL_VOTES , COUNT(C.MOVIE_ID) AS MOVIE_COUNT, 
ROUND(SUM(C.avg_rating * C.total_votes) / SUM(C.total_votes), 2) AS ACTOR_AVG_RATING
FROM NAMES AS A
INNER JOIN ROLE_MAPPING AS B ON A.ID=B.NAME_ID
INNER JOIN RATINGS AS C ON B.MOVIE_ID= C.MOVIE_ID
INNER JOIN MOVIE AS D ON B.MOVIE_ID= D.ID
WHERE UPPER(COUNTRY) IN ('INDIA')
AND UPPER(B.category) IN ('ACTOR')
GROUP BY  A.NAME
HAVING MOVIE_COUNT>=5
)
SELECT *, RANK() OVER (ORDER BY ACTOR_AVG_RATING DESC) AS actor_rank
FROM ACTOR_NAME_SUMMARY;

-- OBSERVATIONS :
 
-- VIJAY SETHUPATHI IS AT THE TOP OF THE LIST, FOLLOWED BY FAHADH FAASIL AND YOGI BABU

-- TOP ACTOR IS VIJAY SETHUPATHI,

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/* TABLES USED 
1. ROLE_MAPPING
2. RATINGS
3. NAMES
4. MOVIE */

WITH ACTRESS_NAME_SUMMARY AS(
SELECT A.NAME AS ACTOR_NAME, SUM(C.TOTAL_VOTES) AS TOTAL_VOTES , COUNT(C.MOVIE_ID) AS MOVIE_COUNT, 
ROUND(SUM(C.AVG_RATING * C.TOTAL_VOTES) / SUM(C.TOTAL_VOTES), 2) AS ACTRESS_AVG_RATING
FROM NAMES AS A
INNER JOIN ROLE_MAPPING AS B ON A.ID=B.NAME_ID
INNER JOIN RATINGS AS C ON B.MOVIE_ID= C.MOVIE_ID
INNER JOIN MOVIE AS D ON B.MOVIE_ID= D.ID
WHERE UPPER(COUNTRY) IN ('INDIA')
AND UPPER(B.CATEGORY) IN ('ACTRESS')
AND UPPER(D.LANGUAGES) LIKE '%HINDI%'
GROUP BY  A.NAME
HAVING MOVIE_COUNT>=3
)
SELECT *, RANK() OVER (ORDER BY ACTRESS_AVG_RATING DESC) AS ACTRESS_RANK
FROM ACTRESS_NAME_SUMMARY;

 -- OBSERVATIONS :

-- TAAPSEE PANNU TOPS THE LIST, FOLLOWED BY KRITI SANON AND DIVYA DUTTA.

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
/* TABLES USED 
1. GENRE
2. RATINGS 
3. MOVIE*/

SELECT 
    X.TITLE,
    CASE
        WHEN B.AVG_RATING > 8 THEN 'SUPERHIT MOVIES'
        WHEN B.AVG_RATING BETWEEN 7 AND 8 THEN 'HIT MOVIES'
        WHEN B.AVG_RATING BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES'
        ELSE 'FLOP MOVIES'
    END AS CATEGORY
FROM
    GENRE AS A
        INNER JOIN
    RATINGS AS B ON A.MOVIE_ID = B.MOVIE_ID
        INNER JOIN
    MOVIE AS X ON A.MOVIE_ID = X.ID
WHERE
    UPPER(A.GENRE) LIKE 'THRILLER';

-- OBSEVATIONS :
-- 1484 ROWS RETURNED

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
/* TABLES USED 
1. GENRE
2. MOVIE*/
WITH GENRE_AVG_DURATION AS (
SELECT A.GENRE, ROUND(AVG(B.DURATION),2) AS AVG_DURATION
FROM GENRE AS A 
INNER JOIN MOVIE AS B ON A.MOVIE_ID= B.ID
GROUP BY A.GENRE
)
SELECT *,
ROUND(SUM(AVG_DURATION) OVER (ORDER BY AVG_DURATION ),2) AS RUNNING_TOTAL_DURATION,
ROUND(AVG(AVG_DURATION) OVER (ORDER BY AVG_DURATION ),2) AS MOVING_AVG_DURATION
FROM GENRE_AVG_DURATION;

-- OBSERVATIONS :
/* ACTION AND ROMANCE MOVIES HAVE HIGHEST AVERAGE DURATION AS FOLLOWED-
  Action -	112.88
  Romance -	109.53
*/

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top 3 Genres based on most number of movies
/* TABLES USED 
1. GENRE
2. MOVIE*/
WITH TOP_3_GENRE_CTE1 AS (
SELECT GENRE FROM GENRE GROUP BY GENRE ORDER BY COUNT(MOVIE_ID) DESC LIMIT 3
),
GROSS_INCOME_CTE2 AS (
SELECT *, 
CASE WHEN WORLWIDE_GROSS_INCOME LIKE 'INR%' THEN CAST(REPLACE(WORLWIDE_GROSS_INCOME,'INR','') AS DECIMAL(12)) / 82 
WHEN WORLWIDE_GROSS_INCOME LIKE '$%' THEN CAST(REPLACE(WORLWIDE_GROSS_INCOME,'$','') AS DECIMAL(12))
ELSE CAST(WORLWIDE_GROSS_INCOME AS DECIMAL(12)) 
END AS WORLDWIDE_GROSS_INCOME
FROM MOVIE
),
TOP5_MOVIE_CTE2 AS (
SELECT B.GENRE, A.YEAR, A.TITLE AS MOVIE_NAME, A.WORLDWIDE_GROSS_INCOME, 
DENSE_RANK() OVER (PARTITION BY YEAR ORDER BY A.WORLDWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
FROM GROSS_INCOME_CTE2 AS A 
INNER JOIN GENRE AS B ON A.ID= B.MOVIE_ID
WHERE  B.GENRE IN (SELECT GENRE FROM TOP_3_GENRE_CTE1)
)
SELECT * FROM TOP5_MOVIE_CTE2
WHERE MOVIE_RANK<=5;

/* OBSERVATIONS :
 Top 3 Genres based on most number of movies
1. Drama
2. Comedy
3. Thriller

2017 :
The Fate of the Furious
Despicable Me 3
Jumanji: Welcome to the Jungle
Zhan lang II
Guardians of the Galaxy Vol. 2

2018 :
Bohemian Rhapsody
Venom
Mission: Impossible - Fallout
Deadpool 2
Ant-Man and the Wasp

2019 :
Avengers: Endgame
The Lion King
Toy Story 4
Joker
Ne Zha zhi mo tong jiang shi
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
/* TABLES USED 
1. MOVIE
2. RATINGS */

WITH TOP2_PRODUCTION_COMPANY AS (
SELECT A.PRODUCTION_COMPANY, COUNT(A.ID) AS MOVIE_COUNT, RANK() OVER (ORDER BY COUNT(A.ID) DESC) AS PROD_COMP_RANK
FROM MOVIE AS A INNER JOIN RATINGS AS B
ON A.ID= B.MOVIE_ID
WHERE MEDIAN_RATING >= 8
AND POSITION(',' IN LANGUAGES)>0 
AND A.PRODUCTION_COMPANY IS NOT NULL
GROUP BY A.PRODUCTION_COMPANY
)
SELECT * FROM TOP2_PRODUCTION_COMPANY 
WHERE PROD_COMP_RANK <=2;

--  OBSERVATIONS :
-- STAR CINEMA RANKS 1 WITH 7 MOVIES, NEXT TWENTIETH CENTURY FOX WITH 4 MOVIES BOTH WITH MEDIAN RATING >= 8 AMONG MULTILINGUAL MOVIES.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/* TABLES USED 
1. ROLE_MAPPING
2. RATINGS 
3. GENRE
4. NAMES,
5.MOVIE */

WITH TOP_3_ACTRESS AS (
SELECT C.NAME AS ACTRESS_NAME,
SUM(B.TOTAL_VOTES) AS TOTAL_VOTES,
COUNT(A.ID) AS MOVIE_COUNT,
ROUND(SUM(B.AVG_RATING * B.TOTAL_VOTES)/ SUM(B.TOTAL_VOTES),2) AS ACTRESS_AVG_RATING,
ROW_NUMBER() OVER (ORDER BY COUNT(A.ID) DESC) AS ACTRESS_RANK
FROM MOVIE AS A
INNER JOIN RATINGS AS B ON A.ID = B.MOVIE_ID
INNER JOIN ROLE_MAPPING AS D ON A.ID= D.MOVIE_ID
INNER JOIN NAMES AS C ON D.NAME_ID = C.ID
INNER JOIN GENRE AS E ON A.ID= E.MOVIE_ID
WHERE B.AVG_RATING > 8
AND UPPER(E.GENRE) LIKE '%DRAMA%' 
AND UPPER(D.CATEGORY) IN ('ACTRESS')
GROUP BY C.NAME
) 
SELECT * 
FROM TOP_3_ACTRESS
WHERE ACTRESS_RANK <=3;

--  OBSERVATIONS
-- TOP 3 ACTRESSES ARE Parvathy Thiruvothu, Susan Brown, Amanda Lawrence

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
/* TABLES USED 
1. director_mapping
2. RATINGS 
3. NAMES 
4. MOVIE */

WITH NEXT_DATE_PUBLISH_CTE1 AS (
SELECT A.NAME_ID , B.NAME , A.MOVIE_ID, C.AVG_RATING, C.TOTAL_VOTES, D.DURATION, D.DATE_PUBLISHED,
LEAD(D.DATE_PUBLISHED) OVER (PARTITION BY A.NAME_ID ORDER BY D.DATE_PUBLISHED, A.MOVIE_ID ) AS NEXT_DATE_PUBLISH
FROM DIRECTOR_MAPPING AS A
INNER JOIN NAMES AS B ON A.NAME_ID = B.ID 
INNER JOIN RATINGS AS C ON A.MOVIE_ID = C.MOVIE_ID
INNER JOIN MOVIE AS D ON A.MOVIE_ID = D.ID
),
DATE_DIFF_CTE2 AS (
SELECT *, DATEDIFF(NEXT_DATE_PUBLISH, DATE_PUBLISHED) AS DATE_DIFF
FROM NEXT_DATE_PUBLISH_CTE1
)
SELECT NAME_ID AS DIRECTOR_ID, NAME AS DIRECTOR_NAME, COUNT(MOVIE_ID) AS NUMBER_OF_MOVIES, ROUND(AVG(DATE_DIFF),2) AS AVG_INTER_MOVIE_DAYS,
ROUND(AVG(AVG_RATING),2) AS AVG_RATING, ROUND(SUM(TOTAL_VOTES),2) AS TOTAL_VOTES, ROUND(MIN(AVG_RATING),2) AS MIN_RATING,
ROUND(MAX(AVG_RATING),2) AS MAX_RATING, ROUND(SUM(DURATION),2) AS TOTAL_DURATION
FROM DATE_DIFF_CTE2
GROUP BY NAME_ID, NAME
ORDER BY COUNT(MOVIE_ID) DESC
LIMIT 9;

-- OBSERVATIONS :
 
-- ANDREW JONES AND A.L. VIJAY TOPS THE LIST WITH 5 MOVIES.
/* TOP 9 ARE AS FOLLOWS :
ANDREW JONES
A.L. VIJAY
SION SONO
CHRIS STOKES
SAM LIU
STEVEN SODERBERGH
JESSE V. JOHNSON
JUSTIN PRICE
ÖZGÜR BAKAR
*/