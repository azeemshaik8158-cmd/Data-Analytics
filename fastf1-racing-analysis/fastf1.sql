USE fastf1;

SET SQL_SAFE_UPDATES = 0;

DELETE a
FROM laps_data a
JOIN laps_data b
ON a.Time = b.Time
AND a.Driver = b.Driver
AND a.LapNumber = b.LapNumber
AND a.Time > b.Time
WHERE a.LapTime IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

SELECT Driver, MIN(LapTime) AS fastest_lap
FROM laps_data
WHERE LapTime IS NOT NULL
GROUP BY Driver
ORDER BY fastest_lap ASC;

SELECT Driver,
       MIN(LapTime) AS fastest_lap,
       RANK() OVER (ORDER BY MIN(LapTime)) AS lap_rank
FROM laps_data
WHERE LapTime IS NOT NULL
GROUP BY Driver
ORDER BY lap_rank ASC;

SELECT Driver,
       MIN(Sector1Time) AS best_s1,
       MIN(Sector2Time) AS best_s2,
       MIN(Sector3Time) AS best_s3
FROM laps_data
GROUP BY Driver
ORDER BY best_s1 ASC;

SELECT Team, MIN(LapTime) AS team_fastest_lap
FROM laps_data
WHERE LapTime IS NOT NULL
GROUP BY Team
ORDER BY team_fastest_lap ASC;

SELECT Driver, COUNT(DISTINCT Stint) AS stint_count
FROM laps_data
GROUP BY Driver
ORDER BY stint_count DESC;

SELECT Driver, LapNumber, TyreLife,
       SUM(TyreLife) OVER (PARTITION BY Driver ORDER BY LapNumber) AS cumulative_tyre_life
FROM laps_data
WHERE TyreLife IS NOT NULL
ORDER BY Driver, LapNumber;

SELECT Compound, COUNT(*) AS usage_count
FROM laps_data
WHERE Compound IS NOT NULL
GROUP BY Compound
ORDER BY usage_count DESC;

SELECT Compound, AVG(TyreLife) AS avg_tyre_life, COUNT(*) AS cnt
FROM laps_data
WHERE TyreLife IS NOT NULL
GROUP BY Compound
ORDER BY avg_tyre_life DESC;

SELECT Driver, FreshTyre, COUNT(*) AS count_tyres
FROM laps_data
GROUP BY Driver, FreshTyre
ORDER BY Driver, count_tyres DESC;

SELECT Driver,
       MIN(Position) AS start_pos,
       MAX(Position) AS finish_pos,
       (MIN(Position) - MAX(Position)) AS net_gain
FROM laps_data
WHERE Position IS NOT NULL
GROUP BY Driver
ORDER BY net_gain DESC;

SELECT Driver, COUNT(*) AS total_laps
FROM laps_data
GROUP BY Driver
ORDER BY total_laps DESC;