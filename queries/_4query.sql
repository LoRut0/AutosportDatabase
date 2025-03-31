WITH stage_results AS
(SELECT 
    p.id AS pilot_id,
	p.name AS pilot_name,
	p.surname AS pilot_surname,
    s.id AS stage_id,
    COUNT(l.lap) AS total_laps,
	
	CASE 
		WHEN l.flag = '0' THEN MIN(l.time)
		ELSE SUM(l.time)
	END + COALESCE(SUM(plty.penalty), 0) AS time_with_penalty,
	tracks.facility AS track
FROM 
    lap l
	
INNER JOIN plttoteam_on_stage pts
    ON l.pilots_id = pts.pilots_id AND l.stages_id = pts.stages_id
INNER JOIN pilots p
    ON pts.pilots_id = p.id
INNER JOIN teams t
    ON pts.teams_id = t.id
INNER JOIN stages s
    ON l.stages_id = s.id
FULL JOIN penalties plty
	ON plty.lap_lap = l.lap AND plty.lap_flag = l.flag AND plty.pilots_id = l.pilots_id AND plty.stages_id = l.stages_id
FULL JOIN tracks ON tracks.id = s.tracks_id

WHERE l.flag = '1'

GROUP BY 
    p.id, p.name, p.surname, s.id, tracks.facility, l.flag
ORDER BY 
    s.id, time_with_penalty ASC),
	
best_time AS (
SELECT MIN(stage_results.time_with_penalty) as time
	FROM stage_results
	GROUP BY stage_results.stage_id),

best_time_with AS (SELECT 
	stg_res.stage_id,
	stg_res.pilot_id,
	best_time.time
FROM best_time
FULL JOIN stage_results stg_res
	ON stg_res.time_with_penalty = best_time.time
WHERE best_time.time IS NOT NULL)

SELECT cars.id AS car_id, cars.brand AS manufacturer, cars.model, tracks.facility, btw.time FROM best_time_with btw
INNER JOIN plttoteam_on_stage ON 
	btw.pilot_id = plttoteam_on_stage.pilots_id AND btw.stage_id = plttoteam_on_stage.stages_id
INNER JOIN stages ON
	stages.id = btw.stage_id
INNER JOIN tracks ON
	tracks.id = stages.tracks_id
INNER JOIN cars ON
	cars.id = plttoteam_on_stage.cars_id

	