SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    COUNT(*) AS balls_faced,
    ROUND(
        (SUM(batsman_runs)::DECIMAL / COUNT(*)) * 100,
        2
    ) AS strike_rate
FROM deliveries_cleaned
GROUP BY batter
HAVING COUNT(*) >= 250
ORDER BY strike_rate DESC;