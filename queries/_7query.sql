WITH results AS (
SELECT plttoteam_on_stage.* FROM plttoteam_on_stage
INNER JOIN stages ON stages.id = plttoteam_on_stage.stages_id
INNER JOIN championships ON championships.id = stages.championships_id
WHERE championships."name" = 'LADA Time Attack Cup 2024'
),

score_pilot AS (
SELECT
	SUM(results.quali_score + results.race_score) AS score,
	results.pilots_id	
FROM results
GROUP BY results.pilots_id
)

SELECT 
	ROW_NUMBER() OVER (ORDER BY score DESC) AS place_in_championship,
	score_pilot.score,
	pilots.id AS pilot_id,
	pilots.surname,
	pilots.name
FROM score_pilot
INNER JOIN pilots ON score_pilot.pilots_id = pilots.id
ORDER BY score DESC

