WITH cte1 AS (
    SELECT id AS cte1_id, name AS cte1_name, MAX(updated) AS cte1_updated
    FROM currency
    GROUP BY id, name
), cte2 AS (
    SELECT DISTINCT id, name AS currency_name, rate_to_usd
    FROM currency
    JOIN cte1 ON currency.updated = cte1.cte1_updated
), cte3 AS (
    SELECT name, lastname, type, SUM(money) AS summ, currency_id
    FROM "user"
    FULL JOIN balance ON "user".id = balance.user_id
    GROUP BY name, lastname, type, currency_id
), cte4 AS (SELECT name, lastname, type, summ AS volume, currency_name,
    (CASE WHEN rate_to_usd ISNULL THEN 1 ELSE rate_to_usd END) AS last_rate_to_usd
    FROM cte3
    FULL JOIN cte2 ON cte2.id = cte3.currency_id
    ORDER BY name DESC, lastname, type
)

SELECT  COALESCE(name, 'not defined') AS name,
        COALESCE(lastname, 'not defined') AS lastname,
        type,
        volume,
        COALESCE(currency_name, 'not defined') AS currency_name, last_rate_to_usd,
        (volume * last_rate_to_usd) AS total_volume_in_usd
FROM cte4
ORDER BY name DESC, lastname, type





