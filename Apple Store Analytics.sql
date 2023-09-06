CREATE TABLE appleStore_description_combined AS 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**EXPLANATORY DATA ANALYSIS**

-- check the number of unique apps in both tables AppleStore

SELeCT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

-- check for missing values in key fields

select count(*) as MissingValues
FROM AppleStore
where track_name is null or user_rating is null or prime_genre is null

SELECT COUNT(*) AS MissingValues
from appleStore_description_combined
where app_desc is null

-- Find out the number of apps per genre

select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

-- Get an overview of the apps' ratings

SELECT min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

Group by PriceBinStart
Order by PriceBinStart


**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than free apps

select CASE
			when price > 0 then 'Paid'
            else 'Free'
         end as App_Type,
         avg(user_rating) as Avg_Rating
from AppleStore
group by App_Type

-- Check if apps that support more languages have higher ratings

SELECT CASE
			when lang_num < 10 then '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            else '>30 languages'
          end as Language_Bucket,
          avg(user_rating) as Avg_Rating
from AppleStore
Group by Language_Bucket
order by Avg_Rating desc

-- Check genres with low ratings

select prime_genre,
	   avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

-- Check if there is correlation between the length of the app description and the user rating

SELECT CASE
			when length(B.app_desc) <500 then 'Short'
            when length(B.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
         end as description_length_bucket,
         avg(A.user_rating) as Avg_Rating
FROM
	AppleStore as A
join 
	appleStore_description_combined as B
ON
	A.id = B.id
group by description_length_bucket
order by Avg_Rating desc

-- Check the top-rated apps for each genre

SELECT
	prime_genre,
    track_name,
    user_rating
from (
  			SELECT
  			prime_genre,
  			track_name,
  			user_rating,
  			RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
            FROM
            AppleStore
      ) as a
WHERE
a.rank = 1


**FINAL RECOMMENDATIONS**
--1. Paid apps have better ratings.
--    This may be because paid apps tend to have more feartures, better support and higher qualuty overral which leads to better ratings from users.
--2. Apps supporting between 10 and 30 languages have better ratings.
--    Apps supporting between 10 and 30 languages may strike a balance between catering to a diverse user base and maintaining quality localization. This could lead to better useer satsfaction and higher ratings.
--3. Finance and Book apps have low ratings
--    This indicates a potential business opportunity! By identifying the pain points and areas of dissatisfaction in these areas, you can create apps that better meets the need and expectations of users.
--4. Apps with a longer dscription have better ratings.
--     This may be due to the fact that a detailed description provides users with more information about the app's features and benefits, setting appropriate expectation. This can lead to a better user experience and higher satisfaction, resulting in higher earnings.
--5. Games and entertainment have high competition.
--     The games and entertainment genres appears to be saturated hence entering the market will be a bit challenging.
--6. A new app should aim for an average rating above 3.5.
--     This is because all the apps on Apple Store have an average rating of 3.5.