#US Household Income (Data Cleaning)

SELECT * 
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;

---------------------------------
#First, let's do the COUNT function

SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

#Result: COUNT(id) = 32526 -- there is missing data -- Let's start cleaning the data

---------------------------------
#Let's identify the duplicates

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;
# There's no duplicate -- maybe because of the importing error of only 18k rows (which is less than 32k rows originally)

#Let's remove the duplicates, if any
SELECT *
FROM (
	SELECT row_id,
    id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income
	) duplicates
WHERE row_num > 1
;

#Now, let's delete the duplicates, if any
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
WHERE row_num > 1)
;

---------------------------------
#Next, let's take a look at State_Name column for cleaning, if any
SELECT State_Name, COUNT(State_Name) 
FROM us_project.us_household_income
GROUP BY State_Name
;
-- There's "georia" instead of "Georgia" in State_Name >> Let's fix that
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

---------------------------------

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

---------------------------------

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
#ORDER BY 1
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

---------------------------------

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;









