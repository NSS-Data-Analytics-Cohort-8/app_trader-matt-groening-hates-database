-- 2. Assumptions
-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.



-- For example, an app that costs $2.00 will be purchased for $20,000.

-- The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores.

-- If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores.
WITH android_apps AS (
	SELECT 
		name, 
		category, 
		rating, 
		review_count, 
		size, 
		install_count, 
		type, 
		(CASE 
		 	WHEN Left(price, 1) = '$' THEN 
				CAST(substring(price from 2)AS FLOAT)
			ELSE 
		 		CAST(price AS FLOAT) 
		 END), 
		content_rating, 
		genres 
	FROM 
		play_store_apps
)
SELECT 
	name,
    'apple' AS store,
    CASE
        WHEN price = 0 THEN 1
        ELSE price 
    END * 10000 AS purchase_price
FROM 
	app_store_apps 
WHERE name NOT IN (SELECT name FROM play_store_apps)
UNION
SELECT 
	name,
    'android' AS store,
    (CASE
        WHEN price = 0 THEN 1
        ELSE price
    END) * 10000 AS purchase_price 
FROM 
	android_apps
WHERE name NOT IN (SELECT name FROM app_store_apps)
UNION
SELECT 
	apple.name, 
	CASE
        WHEN apple.price > playstore.price THEN 'apple'
        ELSE 'android'
	END AS store,
    (CASE
        WHEN apple.price > playstore.price THEN apple.price
        ELSE playstore.price 
    END) * 10000 AS purchase_price
FROM 
	app_store_apps apple
INNER JOIN 
	android_apps playstore ON apple.name = playstore.name
ORDER BY 
	purchase_price DESC;
-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.


-- An app that costs $200,000 will make the same per month as an app that costs $1.00.

-- An app that is on both app stores will make $10,000 per month.
SELECT 
  app_store_apps.name, 
  app_store_apps.price,  
  app_store_apps.rating, 
  app_store_apps.content_rating, 
  (app_store_apps.price * 10000) AS purchase_price, 
  120000 AS monthly_earnings, 
  1000 AS monthly_marketing_cost, 
  ROUND((app_store_apps.rating + play_store_apps.rating) / 2.0 * 2) / 2.0 AS avg_rating, 
  (CASE 
    WHEN app_store_apps.price >= CAST(play_store_apps.price AS numeric(5,2))
    THEN app_store_apps.price 
    ELSE CAST(play_store_apps.price AS numeric(5,2)) 
   END) AS highest_price 
FROM app_store_apps 
JOIN play_store_apps 
ON app_store_apps.name = play_store_apps.name 
--WHERE app_store_apps.price <= 1.00 AND play_store_apps.type = 'Free' 
ORDER BY avg_rating DESC, app_store_apps.review_count DESC 
LIMIT 10;
-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

-- An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.
-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.

-- App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.
-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

-- 3. Deliverables
-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.



WITH android_apps AS (
	SELECT 
		name, 
		category, 
		rating, 
		review_count, 
		size, 
		install_count, 
		type, 
		(CASE 
		 	WHEN Left(price, 1) = '$' THEN 
				CAST(substring(price from 2) AS FLOAT)
			ELSE 
		 		CAST(price AS FLOAT) 
		 END), 
		content_rating, 
		genres 
	FROM 
		play_store_apps
)
SELECT
	apple.name,
	(CASE
	 	WHEN apple.price = 0 AND playstore.price = 0 THEN 10000
        WHEN apple.price > playstore.price THEN apple.price * 10000
        ELSE playstore.price  * 10000
    END) AS purchase_price,
	10000 AS earnings,
	1000 AS marketing_cost,
	CAST((apple.rating + playstore.rating) / 2 AS NUMERIC(5,2)) AS average_rating,
	CAST((ROUND(apple.rating + playstore.rating)) / 2 AS NUMERIC(5,2)) AS rounded_average_rating,
	CAST(((ROUND(apple.rating + playstore.rating)) / 2) * 2 + 1 AS NUMERIC(5,2)) AS lifespan
FROM 
	app_store_apps apple
INNER JOIN 
	android_apps playstore ON apple.name = playstore.name
ORDER BY
	lifespan DESC, purchase_price
LIMIT 20


