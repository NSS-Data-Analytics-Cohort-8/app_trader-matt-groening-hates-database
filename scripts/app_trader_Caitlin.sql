--Searching for apps that overlap stores - 553

--Trying to return highest rated games and lowest price. So far have avg rating between both stores as rating. Need to add on price
SELECT DISTINCT a.name, ROUND(((a.rating + p.rating)/2),1) AS rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
ORDER BY rating DESC






