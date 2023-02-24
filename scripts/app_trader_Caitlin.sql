/*-- Query Highest rated games

SELECT app_store.name, CAST(app_store.price AS MONEY),CAST(play_store.price AS MONEY), app_store.rating, play_store.rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL
ORDER by app_store.rating DESC

-- Query how many games rated 5 are free?
SELECT COUNT(*)
FROM app_store_apps
WHERE price = 0
 -- 4056

--Highest rated games that are free
SELECT app_store.name, ROUND(AVG(CAST(app_store.price AS MONEY),CAST(play_store.price AS MONEY), app_store.rating, play_store.rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL
	AND CAST(app_store.price AS MONEY) < '$1.00'
	AND CAST(play_store.price AS MONEY)<'$1.00'
ORDER by app_store.rating DESC

--Need correct rating score.
SELECT app_store_apps.name, ROUND(AVG((app_store_apps.rating+play_store_apps.rating)/2),0) AS avg_rating
FROM app_store_apps
INNER JOIN play_store_apps
ON app_store_apps.name = play_store_apps.name
GROUP BY app_store_apps.name
								 
-- Putting it all together  --- might need a case when for money...? 
SELECT app_store.name, 
	 CAST(app_store.price AS MONEY),
	 CAST(play_store.price AS MONEY),
	ROUND(AVG((app_store.rating+play_store.rating)/2),1) AS avg_rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL					
	AND CAST(app_store.price AS MONEY) < '$1.00'
	AND CAST(play_store.price AS MONEY)<'$1.00'
GROUP BY app_store.name, CAST(app_store.price AS MONEY),CAST(play_store.price AS MONEY)
ORDER by avg_rating DESC
								 
-- Testing round to nearest .5 for ratings -yes!
SELECT app_store_apps.name, round(round(AVG((app_store_apps.rating+play_store_apps.rating)/2)/5,1)*5,1)
FROM app_store_apps
INNER JOIN play_store_apps
ON app_store_apps.name = play_store_apps.name
GROUP BY app_store_apps.name
			
--Improved rounding formula. Also changed filter < $0.50. 
 --THIS GIVES TOP 10 LIST*/

SELECT app_store.name, 
	 CAST(app_store.price AS MONEY),
	 CAST(play_store.price AS MONEY),
	ROUND(ROUND(AVG((app_store.rating+play_store.rating)/2)/5,1)*5,1) AS avg_rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL					
	AND CAST(app_store.price AS MONEY) < '$0.50'
	AND CAST(play_store.price AS MONEY)<'$0.50'
GROUP BY app_store.name, CAST(app_store.price AS MONEY),CAST(play_store.price AS MONEY)
ORDER by avg_rating DESC
LIMIT 10;


-- NEED to create profit column 

SELECT name, price, rating,
	(SELECT (rating * 2 * 120000) - (10000 * price + rating*2 * 12000)) AS profit
FROM app_store_Apps