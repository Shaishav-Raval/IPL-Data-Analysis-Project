WITH season_runs AS (
    SELECT
        m.season,
        d.batsman AS orange_cap_holder,
        SUM(d.batsman_runs) AS total_runs,
        RANK() OVER (
            PARTITION BY m.season
            ORDER BY SUM(d.batsman_runs) DESC
        ) AS run_rank
    FROM deliveries d
    JOIN matches m
        ON d.match_id = m.id
    GROUP BY m.season, d.batsman
),
season_wickets AS (
    SELECT
        m.season,
        d.bowler AS purple_cap_holder,
        COUNT(d.player_dismissed) AS total_wickets,
        RANK() OVER (
            PARTITION BY m.season
            ORDER BY COUNT(d.player_dismissed) DESC
        ) AS wicket_rank
    FROM deliveries d
    JOIN matches m
        ON d.match_id = m.id
    WHERE d.player_dismissed IS NOT NULL
      AND d.dismissal_kind NOT IN ('run out', 'retired hurt')
    GROUP BY m.season, d.bowler
)
SELECT
    r.season,
    r.orange_cap_holder,
    w.purple_cap_holder
FROM season_runs r
JOIN season_wickets w
    ON r.season = w.season
WHERE r.run_rank = 1
  AND w.wicket_rank = 1
ORDER BY r.season;