WITH starting AS (
SELECT 
	l.stages_id AS stage_id,
	p.id AS pilot_id,
	p.name AS pilot_name,
	p.surname AS pilot_surname,
    COUNT(l.lap) AS total_laps,
	CASE 
		WHEN l.flag = '0' THEN MIN(l.time)
		ELSE SUM(l.time)
	END + COALESCE(SUM(plty.penalty), 0) as time_with_pnlty,
	COALESCE(SUM(plty.penalty), 0) as penalty
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
	on plty.lap_lap = l.lap AND plty.lap_flag = l.flag AND plty.pilots_id = l.pilots_id AND plty.stages_id = l.stages_id

WHERE l.flag = '0'

GROUP BY 
    p.id, p.name, p.surname, l.stages_id, l.flag
ORDER BY 
    time_with_pnlty ASC
),

stage_num AS (
SELECT 
	ROW_NUMBER() OVER (ORDER BY stages.start_date) AS stage_num, 
	stages.* 
FROM stages
INNER JOIN championships ON championships.id = stages.championships_id
WHERE championships."name" = 'LADA Time Attack Cup 2024'
)

SELECT
	ROW_NUMBER() OVER (ORDER BY time_with_pnlty ASC) AS starting_place,
	pilot_id,
	pilot_name,
	pilot_surname,
	total_laps,
	time_with_pnlty,
	penalty
FROM starting
INNER JOIN stage_num ON stage_num.id = starting.stage_id
WHERE stage_num.stage_num = 1