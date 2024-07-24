# US Household Income (Exploratory Data Analysis)

SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;
-------------------------------

-- Identify the size of Land Area & Water Area of each State --

#Let's have an overview of these columns
SELECT State_Name, ALand, AWater
FROM us_project.us_household_income;

#Let's sum Land Area & Water Area per state, order by Land Area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2;

#Filter out 10 states with the largest Land Area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

#Filter out 10 states with the largest Water Area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;
-------------------------------

-- Let's explore the Income by State --

#Let's JOIN the "id" column from both tables first
SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0;
    
#Let's have a selected overview of income by state
SELECT u.State_Name, County, `Type`, `Primary`, Mean, Median
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id;

#Identify the lowest (AVG-mean) household income states, ASC
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2;

#Identify the 10 states with highest (AVG-mean) household income, DESC
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median), 1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

#Identify the lowest (AVG-Median) household income states, ASC
SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name
order by 3;
-------------------------------

-- Let's explore the Income by Type --

#
SELECT `Type`, `Primary`, AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY `Type`, `Primary`
order by 3;

#Let's see the lowest AVG(Median) household income by Type
SELECT `Type`, AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 3;
-- So Type: County, CPD, and City are the lowest AVG(Median) household income


#Let's count the number of each Type with the low-high AVG(Median) household income
SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 4;

#We want to filter COUNT of Type for greater than 100 -- to filter out results < 100
SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
order by 4;
-------------------------------

#Identify what state has Type 'Community'
SELECT *
FROM us_project.us_household_income
WHERE Type = 'Community';
-- Turn out there is missing data, the output populate nothing, unlike in the video

-------------------------------
 
#Let's have a look at the tables again
SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id;

#Now, let's see the AVG(Mean) household income at City level for each State
SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC;


#Highest
SELECT u.State_Name, City, AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
LIMIT 10;