WITH wicket_balls AS (
    SELECT
        match_id,
        inning,
        over,
        ball,
        bowler,
        is_wicket,
        LAG(is_wicket, 1) OVER (
            PARTITION BY match_id, inning, bowler
            ORDER BY over, ball
        ) AS prev_wicket_1,
        LAG(is_wicket, 2) OVER (
            PARTITION BY match_id, inning, bowler
            ORDER BY over, ball
        ) AS prev_wicket_2
    FROM deliveries_cleaned
)
SELECT
    bowler,
    COUNT(*) AS hat_tricks
FROM wicket_balls
WHERE is_wicket = 1
  AND prev_wicket_1 = 1
  AND prev_wicket_2 = 1
GROUP BY bowler
ORDER BY hat_tricks DESC;