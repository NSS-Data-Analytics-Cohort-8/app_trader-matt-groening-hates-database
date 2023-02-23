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
SELECT app_store.name, CAST(app_store.price AS MONEY) AS app_price,CAST(play_store.price AS MONEY) AS play_price, app_store.rating, play_store.rating
FROM app_store_apps AS app_store
INNER JOIN play_store_apps AS play_store
ON app_store.name = play_store.name
WHERE app_store.rating IS NOT NULL
	AND play_store.rating IS NOT NULL
	AND CAST(app_store.price AS MONEY) < '$1.00'
	AND CAST(play_store.price AS MONEY)<'$1.00'
ORDER by app_store.rating DESC

--Need correct rating score.


