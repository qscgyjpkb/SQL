-- insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
-- insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');

SELECT coalesce(u.name, 'not defined') AS name,
       coalesce(u.lastname, 'not defined') AS lastname,
       c.name AS currency_name,
       coalesce(cp.past, cp.future) * cp.money as currency_in_usd
FROM balance
LEFT JOIN "user" u on balance.user_id = u.id
LEFT JOIN
       (SELECT b.user_id, b.money, b.currency_id,
       (SELECT c.rate_to_usd FROM currency c WHERE c.id = b.currency_id AND c.updated <= b.updated ORDER BY c.updated DESC LIMIT 1) AS past,
       (SELECT c.rate_to_usd FROM currency c WHERE c.id = b.currency_id AND c.updated >= b.updated ORDER BY c.updated LIMIT 1) AS future
       FROM balance b) AS cp on balance.user_id = cp.user_id
RIGHT JOIN currency c on cp.currency_id = c.id
GROUP BY u.name, currency_in_usd, u.lastname, c.name
ORDER BY name DESC, lastname, currency_name;
