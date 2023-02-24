-- ============================================================
-- This is the most working query I have so far
-- ============================================================
select
	app_name,
	rounded_combined_rating,
	case
		when apple_purchase_price > google_purchase_price then apple_purchase_price
		else google_purchase_price
	end as app_purchase_price,
	case
		when apple_purchase_price > google_purchase_price then app_lifetime_estimated_income - apple_purchase_price
		else app_lifetime_estimated_income - google_purchase_price
	end as app_projected_profit
from (
	select
		app_name,
		round(((apple_rating + google_rating) / 2) / 0.5, 0) * 0.5 as rounded_combined_rating,
		cast(((round(((apple_rating + google_rating) / 2) / 0.5, 0) * 0.5) / 0.5 ) * 1 as integer) as app_lifetime_expectancy_in_years,
		cast(apple_price as money),
		cast(google_price as money),
		case
			when apple_price <= 1 then cast(10000 * 1 as money)
			else cast(10000 * apple_price as money)
		end as apple_purchase_price,
		case
			when cast(right(google_price, -1) as money)::numeric::int <= 1 then cast(10000 * 1 as money)
			else cast(10000 * cast(right(google_price, -1) as money) as money)
		end as google_purchase_price,
		cast((10000 - 1000) * ((((round(((apple_rating + google_rating) / 2) / 0.5, 0) * 0.5) / 0.5 ) * 1) * 12) as money) as app_lifetime_estimated_income
	from (
		select
			asa.name as app_name,
			asa.price as apple_price,
			asa.review_count as apple_review_count,
			asa.rating as apple_rating,
			psa.name as google_name,
			psa.price as google_price,
			psa.review_count as google_review_count,
			psa.rating as google_rating
		from app_store_apps as asa
		inner join (
			select
				distinct on(name) name,
				category,
				rating,
				review_count,
				size,
				install_count,
				type,
				price,
				content_rating,
				genres
			from play_store_apps
			order by name
		) as psa
		on asa.name = psa.name
		where asa.name in (
			select name from play_store_apps
			intersect
			select name from app_store_apps
		)
		order by asa.name
	) as play_and_app_stores_data
) as play_and_app_stores_data_with_equations
order by app_projected_profit desc, app_name
limit 10;


-- ASSUMPTIONS

-- App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000
-- Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app
-- App Trader will spend an average of $1000 per month to market an app regardless of the price of the app
-- For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years