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

CREATE TABLE merged AS
SELECT DISTINCT title, Released_Year, Runtime, Genre, IMDB_Rating, Director, No_of_Votes, ProductionBudget, DomesticGross, WorldwideGross
FROM joined
GROUP BY title;	

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
	

	


	















	
	
