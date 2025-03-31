WITH results AS (
SELECT plttoteam_on_stage.* FROM plttoteam_on_stage
INNER JOIN stages ON stages.id = plttoteam_on_stage.stages_id
INNER JOIN championships ON championships.id = stages.championships_id
WHERE championships."name" = 'LADA Time Attack Cup 2024'
)

SELECT
	SUM(results.quali_score + results.race_score) AS score,
	teams."name"
FROM results
INNER JOIN teams ON teams.id = results.teams_id
GROUP BY teams."name"
ORDER BY score ASC;