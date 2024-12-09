--Joined two preprocessed datasets
CREATE TABLE joined AS
SELECT 
    imdb_cleaned.title,
    imdb_cleaned.Released_Year,
    imdb_cleaned.Runtime,
    imdb_cleaned.Genre,
    imdb_cleaned.IMDB_Rating,
    imdb_cleaned.Director,
    imdb_cleaned.No_of_Votes,
    imdb_cleaned.Gross AS IMDB_Gross,
    movies_cleaned.year AS Movie_Year,
    movies_cleaned."ProductionBudget(mil)" AS ProductionBudget,
    movies_cleaned.DomesticGross,
    movies_cleaned.WorldwideGross
FROM 
    imdb_cleaned
JOIN 
    movies_cleaned
ON 
    LOWER(TRIM(imdb_cleaned.title)) = LOWER(TRIM(movies_cleaned.title));
	
--Grouped the joined table by the title to remove the duplicates
CREATE TABLE merged AS
SELECT DISTINCT title, Released_Year, Runtime, Genre, IMDB_Rating, Director, No_of_Votes, ProductionBudget, DomesticGross, WorldwideGross
FROM joined
GROUP BY title;	

--Do higher budget costs always result in higher ratings?
SELECT 
    CASE 
        WHEN ProductionBudget < 50 THEN 'Low (<50M)'
        WHEN ProductionBudget BETWEEN 50 AND 100 THEN 'Medium (50-100M)'
        WHEN ProductionBudget BETWEEN 101 AND 200 THEN 'High (101-200M)'
        ELSE 'Very High (>200M)'
    END AS BudgetRange,
    AVG(IMDB_Rating) AS AvgRating,
    COUNT(*) AS MovieCount
FROM 
    merged
GROUP BY 
    BudgetRange
ORDER BY 
    BudgetRange;

--How does runtime affect gross?
SELECT 
    CAST(Runtime AS INTEGER) AS Runtime,
    CAST(AVG(WorldwideGross) AS INTEGER) AS AvgWorldwideGross,
    COUNT(*) AS MovieCount
FROM 
    merged
GROUP BY 
    Runtime
ORDER BY 
    AvgWorldwideGross DESC;

--Which directors have the greatest box office success?
SELECT 
    Director,
    CAST(AVG(WorldwideGross) AS INTEGER) AS AvgWorldwideGross,
    COUNT(*) AS MovieCount
FROM 
    merged
GROUP BY 
    Director
ORDER BY 
    AvgWorldwideGross DESC;
	
-- Are certain genres more successful than others?
SELECT 
    Genre, 
    CAST(AVG(WorldwideGross) AS INTEGER) AS AvgWorldwideGross,
    COUNT(*) AS MovieCount
FROM 
    merged
GROUP BY 
    Genre
--removed genres with total of movies less than 10 since it is too small to be considered
HAVING 
    COUNT(*) >= 10
ORDER BY 
    AvgWorldwideGross DESC;

--Are movies getting better reviews over time?
--released year was from 1921 to 2019
SELECT DISTINCT Released_Year
FROM merged
WHERE Released_Year IS NOT NULL
ORDER BY Released_Year;

--Grouped the movies into 5-year intevals
SELECT 
    (Released_Year / 5) * 5 AS YearStart,
    ((Released_Year / 5) * 5) + 4 AS YearEnd,
    ROUND(AVG(IMDB_Rating), 2) AS AvgIMDBRating,
    COUNT(*) AS MovieCount
FROM 
    merged
WHERE 
    Released_Year IS NOT NULL
    AND Released_Year >= 1920
GROUP BY 
    (Released_Year / 5) * 5
--removed the rows where there was less than 3 movies 
HAVING 
    MovieCount >= 3
ORDER BY 
    YearStart;
	
	
	




	


	















	
	
