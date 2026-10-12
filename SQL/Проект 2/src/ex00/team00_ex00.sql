CREATE TABLE paths (
    points1 varchar,
    points2 varchar,
    cost bigint
);

INSERT INTO paths
    (points1, points2, cost)
VALUES
    ('A', 'B', 10),
    ('A', 'C', 15),
    ('A', 'D', 20),
    ('B', 'A', 10),
    ('B', 'C', 35),
    ('B', 'D', 25),
    ('C', 'A', 15),
    ('C', 'B', 35),
    ('C', 'D', 30),
    ('D', 'A', 20),
    ('D', 'B', 25),
    ('D', 'C', 30);

WITH RECURSIVE citys AS (
    SELECT points1, points2, cost as tcost, array [points2] as path, false AS cycle, array [cost] as costs
    FROM paths
    WHERE points2 = 'A'
    UNION
    SELECT paths.points1, paths.points2, paths.cost + citys.tcost as total_cost,
           citys.path || paths.points2 as path,
                paths.points2 = any(path) as cicle,
                citys.costs || paths.cost as costs
    FROM paths
    JOIN citys ON paths.points1 = citys.points2 AND NOT cycle
), res AS (
    SELECT DISTINCT (costs[2] + costs[3] + costs[4] + costs[5]) as total_cost,  citys.path
    FROM citys
    WHERE cardinality(citys.path) = 5 AND citys.path[5] = 'A'
    ORDER BY total_cost
)

SELECT
    total_cost,
    path
FROM res
WHERE total_cost = (SELECT min(total_cost) FROM res);