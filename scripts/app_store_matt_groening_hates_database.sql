-- Assumptions

-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
    
-- - For example, an app that costs $2.00 will be purchased for $20,000.
    
-- - The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 
    
-- - If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. 

-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.
    
-- - An app that costs $200,000 will make the same per month as an app that costs $1.00. 

-- - An app that is on both app stores will make $10,000 per month. 

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.
    
-- - An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.
    
-- - App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.

-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

-- Deliverables

-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.

SELECT 
	name,
	cast(price as money)
FROM play_store_apps
WHERE cast(price as money) > '$0.99'
	AND cast(price as money) < '$1.99'

SELECT *
FROM app_store_apps

						-- SELECT DISTINCT CAST(price AS money),
						-- 	(SELECT COUNT(CAST(price AS money)))
						-- FROM play_store_apps
						-- GROUP BY DISTINCT CAST(price AS money)

						-- SELECT DISTINCT price,
						-- 	(SELECT COUNT(price))
						-- FROM app_store_apps
						-- GROUP BY DISTINCT price

						-- SELECT DISTINCT price,
						-- 	(SELECT COUNT(price)), price_count
						-- 	(SELECT ROUND(AVG(rating), 2)) as avg_rating
						-- 	(SELECT (avg_rating/2)*4000-price*10000)
						-- FROM app_store_apps
						-- GROUP BY DISTINCT price
						
								--


SELECT 
	DISTINCT sub.name as app_name,
	
	(SELECT (SUM(CAST(sub.review_count AS int)))) as asp_review,
	
	(SELECT (SUM(CAST(psp.review_count AS int)))) as psp_review,
	
	CASE WHEN CAST(sub.price as money) + CAST (psp.price AS money) <= '$2.00' THEN '$10,000.00'  
		WHEN CAST(sub.price as money) < CAST (psp.price AS money) THEN CAST(psp.price AS money)*10000
		WHEN CAST(sub.price as money) >= CAST (psp.price AS money) THEN CAST(sub.price AS money)*10000
		END AS purchase_price,		
	
	(SELECT CAST(((ROUND(((psp.rating+sub.rating)*2)/2)/2)/.5) AS int)) AS lifespan,
	
	(SELECT CAST((((ROUND(((psp.rating+sub.rating)*2)/2)/2)/.5)*36000) as money)-
			(CASE WHEN CAST(sub.price as money)+CAST (psp.price AS money) <= '$2.00' THEN '$10,000.00'  
				WHEN CAST(sub.price as money) < CAST (psp.price AS money) THEN CAST(psp.price AS money)*10000
				WHEN CAST(sub.price as money) >= CAST (psp.price AS money) THEN CAST(sub.price AS money)*10000
				END)) AS lifetime_profit
FROM 
	(SELECT
		name,
		price,
		rating,
	 	review_count
	FROM app_store_apps
	WHERE name IN
		(SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps)) as sub
INNER JOIN play_store_apps as psp
USING (name)
GROUP BY sub.name, purchase_price, lifespan, lifetime_profit
ORDER BY lifetime_profit DESC;


--VALIDATION

SELECT *
FROM app_store_apps
WHERE name IN
	(SELECT 
-- 		name
-- 	 	, CAST(price as money)
	 *
	FROM play_store_apps
	WHERE cast(price as money) > '$0.99'
		AND cast(price as money) < '$1.99')