-- Create the database --
CREATE DATABASE FoodserviceDB

-- Create the schema for the restaurant --
CREATE SCHEMA rst

-- Data was inserted as a flat file --

-- Query the data for dicovery --
SELECT * FROM [rst].[consumers]
SELECT * FROM [rst].[ratings]
SELECT * FROM [rst].[restaurants]
SELECT * FROM [rst].[restaurant_cuisines]

-- Add the primary keys first then the foreign ones --
ALTER TABLE [rst].[consumers]
ADD PRIMARY KEY (Consumer_ID);

ALTER TABLE [rst].[ratings]
ADD FOREIGN KEY (Consumer_ID)
REFERENCES [rst].[consumers](Consumer_ID);

ALTER TABLE [rst].[restaurants]
ADD PRIMARY KEY (Restaurant_ID);

ALTER TABLE [rst].[restaurant_cuisines]
ADD FOREIGN KEY (Restaurant_ID)
REFERENCES [rst].[restaurants](Restaurant_ID);

ALTER TABLE [rst].[ratings]
ADD FOREIGN KEY (Restaurant_ID)
REFERENCES [rst].[restaurants](Restaurant_ID);

-- 1. Write a query that lists all restaurants with a Medium range price with open area, serving Mexican food --
SELECT
	r.Name,
	r.City,
	r.State,
	r.Country,
	r.Price,
	r.Area,
	rc.Cuisine
FROM [rst].[restaurants] r
INNER JOIN [rst].[restaurant_cuisines] rc
	ON r.Restaurant_ID = rc.Restaurant_ID
WHERE r.Price = 'Medium'
	and r.Area = 'Open'
	and rc.Cuisine = 'Mexican'

-- 2. Write a query that returns the total number of restaurants who have the overall rating as 1 and are serving --
-- Mexican food. Compare the results with the total number of restaurants who have the overall rating as 1 serving --
-- Italian food (please give explanations on their comparison) --
SELECT
	CONCAT(COUNT(res.Name), ' Mexican Restaurants') AS [Tot. nbr of restaurants (Overall rating 1)]
FROM [rst].[restaurants] res
WHERE res.Restaurant_ID in (
	SELECT DISTINCT
		Restaurant_ID
	FROM [rst].[ratings]
	WHERE Overall_Rating = 1
)
	and res.Restaurant_ID in (
	SELECT DISTINCT
		Restaurant_ID
	FROM [rst].[restaurant_cuisines]
	WHERE Cuisine = 'Mexican'
)
UNION ALL
SELECT
	CONCAT(COUNT(res.Name), ' Italian Restaurants') AS [Tot. nbr of restaurants (Overall rating 1)]
FROM [rst].[restaurants] res
WHERE res.Restaurant_ID in (
	SELECT DISTINCT
		Restaurant_ID
	FROM [rst].[ratings]
	WHERE Overall_Rating = 1
)
	and res.Restaurant_ID in (
	SELECT DISTINCT
		Restaurant_ID
	FROM [rst].[restaurant_cuisines]
	WHERE Cuisine = 'Italian'
)

-- 3. Calculate the average age of consumers who have given a 0 rating to the 'Service_rating' column --
SELECT
	ROUND(
		CAST(
			SUM(c.Age)
			AS FLOAT)
		/
		CAST(
			COUNT(c.Age)
			AS FLOAT)
		, 2) AS [Average Age Who Gave 0 Service Rating]
FROM [rst].[consumers] c
INNER JOIN [rst].[ratings] r
	ON c.Consumer_ID = r.Consumer_ID
WHERE r.Service_Rating = 0

SELECT ROUND(AVG(Age), 2)
FROM [rst].[consumers]

-- 4. Write a query that returns the restaurants ranked by the youngest consumer. You should include the --
-- restaurant name and food rating that is given by that customer to the restaurant in your result. Sort --
-- the results based on food rating from high to low --
SELECT
	res.Name,
	con.Consumer_ID,
	con.Age,
	r.Food_Rating
FROM [rst].[restaurants] res
INNER JOIN [rst].[ratings] r
	ON r.Restaurant_ID = res.Restaurant_ID
INNER JOIN [rst].[consumers] con
	ON con.Consumer_ID = r.Consumer_ID
WHERE con.Age in (
	SELECT
		MIN(Age)
	FROM [rst].[consumers]
)
ORDER BY r.Food_Rating Desc

-- 5. Write a stored procedure for the query given as: Update the Service_rating of all restaurants to '2' --
-- if they have parking available, either as 'yes' or 'public' --
CREATE PROCEDURE Update_Service_Rating AS
BEGIN
	UPDATE [rst].[ratings]
	SET
		Service_Rating = 2
	WHERE
		Restaurant_ID in (
			SELECT
				Restaurant_ID
			FROM [rst].[restaurants]
			WHERE Parking in ('Yes', 'Public')
		);
END
	
EXEC Update_Service_Rating;

--Before query
SELECT
	res.Restaurant_ID,
	res.Parking,
	r.Service_Rating
FROM [rst].[restaurants] res
INNER JOIN [rst].[ratings] r
	ON r.Restaurant_ID = res.Restaurant_ID
WHERE res.Parking in ('Yes', 'Public')
	and r.Service_Rating <> 2

--After query
SELECT
	res.Restaurant_ID,
	res.Parking,
	r.Service_Rating
FROM [rst].[restaurants] res
INNER JOIN [rst].[ratings] r
	ON r.Restaurant_ID = res.Restaurant_ID
WHERE res.Parking in ('Yes', 'Public')

-- 6. You should also write four queries of your own and provide a brief explanation of the results which each --
-- query returns. You should make use of all of the following at least once: --
-- 6) A. Nested queries-EXISTS --
SELECT
	Name,
	Alcohol_Service,
	Smoking_Allowed,
	Price,
	Area,
	Parking
FROM [rst].[restaurants]
WHERE EXISTS (
	SELECT *
	FROM [rst].[ratings]
	WHERE [rst].[ratings].Restaurant_ID = [rst].[restaurants].Restaurant_ID
		and Food_Rating > 1
		and Service_Rating > 1
)

-- 6) B. Nested queries-IN --
SELECT
	ROUND(
		CAST(SUM(Overall_Rating) AS FLOAT)
		/CAST(COUNT(Overall_Rating) AS FLOAT)
		, 2) AS [Average Overall Rating],
	ROUND(
		CAST(SUM(Food_Rating) AS FLOAT)
		/CAST(COUNT(Food_Rating) AS FLOAT)
		, 2) AS [Average Food Rating],
	ROUND(
		CAST(SUM(Service_Rating) AS FLOAT)
		/CAST(COUNT(Service_Rating) AS FLOAT)
		, 2) AS [Average Service Rating]
FROM [rst].[ratings]
WHERE Consumer_ID in (
	SELECT
		Consumer_ID
	FROM [rst].[consumers]
	WHERE Country = 'Mexico'
		and Occupation = 'Student'
		and Budget = 'Low'
)

-- 6) C. System functions --
SELECT DISTINCT
	CONCAT(res.Name, ' serving ', resc.Cuisine) AS [Restaurant Cuisine],
	CONCAT('info@',REPLACE(LOWER(res.Name), ' ', ''), resc.Cuisine, '.com') AS [Restaurant Email],
	ROUND(
		CAST(SUM(ra.Overall_Rating) AS FLOAT)
		/
		CAST(COUNT(ra.Overall_Rating) AS FLOAT)
		, 2)
	/
	2 AS [Success Overall Rating]
INTO #Temp
FROM [rst].[restaurants] res
LEFT JOIN [rst].[restaurant_cuisines] resc
	ON res.Restaurant_ID = resc.Restaurant_ID
LEFT JOIN [rst].[ratings] ra
	ON ra.Restaurant_ID = res.Restaurant_ID
GROUP BY res.Name, resc.Cuisine

SELECT
	[Restaurant Cuisine],
	[Restaurant Email],
	FORMAT([Success Overall Rating], 'P') AS [Success Overall Rating Percentage],
	CASE
		WHEN [Success Overall Rating] <= 0.35
			THEN 'Need immediate action'
		WHEN [Success Overall Rating] > 0.35 and [Success Overall Rating] <= 0.7
			THEN 'Improvement Needed'
		WHEN [Success Overall Rating] > 0.7
			THEN 'Great Rating'
	END AS [Rating Status]
FROM #Temp

DROP TABLE #Temp

-- 6) D. Use of GROUP BY, HAVING and ORDER BY clauses --
SELECT TOP 20
	COUNT(ra.Consumer_ID) AS [Number of Reviews],
	res.Name AS [Restaurant Name]
FROM [rst].[ratings] ra
INNER JOIN [rst].[restaurants] res
	ON ra.Restaurant_ID = res.Restaurant_ID
GROUP BY res.Name, ra.Overall_Rating
HAVING ra.Overall_Rating <> 0
ORDER BY COUNT(ra.Consumer_ID) DESC;