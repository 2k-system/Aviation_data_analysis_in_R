use match ; 
WITH result as (
SELECT *,
    CASE WHEN host_goals > guest_goals THEN 3 
        WHEN host_goals = guest_goals THEN 1
        WHEN host_goals < guest_goals THEN 0
    END as host_points,
    CASE WHEN guest_goals > host_goals THEN 3
        WHEN guest_goals = host_goals THEN 1
        WHEN guest_goals < host_goals THEN 0 
    END as guest_points 
FROM match

SELECT
    t.team_id,
    t.team_name,
    COALESCE(y.num_points,0) as num_points
FROM match t LEFT JOIN (
    SELECT
        team_id,
        SUM(num_points) as num_points
    FROM (
        SELECT
            host_team as team_id,
            SUM(host_points) as num_points
        FROM result 
        GROUP BY 1
        UNION ALL
        SELECT
            guest_team as team_id,
            SUM(guest_points) as num_points
        FROM result
        GROUP BY 1
        ) x
    GROUP BY 1
    ORDER BY 1
        ) y 
ON t.team_id = y.team_id 
ORDER BY 3 DESC, 1 ASC