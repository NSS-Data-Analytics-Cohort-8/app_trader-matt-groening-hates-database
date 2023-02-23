-- Query Highest rated games

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
	 CAST(play_store.price AS MONEY),     		ROUND(AVG((app_store.rating+play_store.rating)/2),0) AS avg_rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL					
	AND CAST(app_store.price AS MONEY) < '$1.00'
	AND CAST(play_store.price AS MONEY)<'$1.00'
GROUP BY app_store.name, CAST(app_store.price AS MONEY),CAST(play_store.price AS MONEY)
ORDER by avg_rating DESC

