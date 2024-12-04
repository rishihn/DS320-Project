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

	
SELECT title, Released_Year, Runtime, Genre,
IMDB_Rating, Director, No_of_Votes, Gross, year, ProductionBudget, DomesticGross, WorldwideGross
 FROM merged_data
 GROUP BY title;
	
	
	
	
	
	
