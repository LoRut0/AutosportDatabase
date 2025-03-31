WITH lap_table AS (SELECT 
    p.id AS pilot_id,
    s.id AS stage_name,
    l.flag,
    COUNT(l.lap) AS total_laps,
	
	CASE 
		WHEN l.flag = '0' THEN MIN(l.time)
		ELSE SUM(l.time)
	END + COALESCE(SUM(plty.penalty), 0) AS time_with_pnlty,

	COALESCE(SUM(plty.penalty), 0) AS penalty,
	
    SUM(CASE WHEN l.pit_stop = '1' THEN 1 ELSE 0 END) AS pit_stops
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

GROUP BY 
    p.id, s.id, l.flag
ORDER BY 
    s.id, l.flag, time_with_pnlty ASC),

quali AS (SELECT ROW_NUMBER() OVER (PARTITION BY stage_name, "flag" ORDER BY time_with_pnlty) AS place_in_quali, 
	lap_table.*	
FROM lap_table
WHERE "flag" = '0'),

race AS (SELECT ROW_NUMBER() OVER (PARTITION BY stage_name, "flag" ORDER BY time_with_pnlty) AS place_in_race, 
	lap_table.*	
FROM lap_table
WHERE "flag" = '1'),

stage_num AS (SELECT 
	ROW_NUMBER() OVER (ORDER BY stages.start_date) AS stage_num, 
	stages.* 
FROM stages
INNER JOIN championships ON championships.id = stages.championships_id
WHERE championships."name" = 'LADA Time Attack Cup 2024')

SELECT distinct
	pilots.surname,
	race.place_in_race,
	quali.place_in_quali, 
	stage_num.stage_num,
	race.total_laps,
	race.pit_stops,
	race.time_with_pnlty,
	race.penalty
FROM race
INNER JOIN quali ON race.stage_name = quali.stage_name AND race.pilot_id = quali.pilot_id
INNER JOIN plttoteam_on_stage ON plttoteam_on_stage.pilots_id = race.pilot_id AND plttoteam_on_stage.stages_id = race.stage_name
INNER JOIN teams ON plttoteam_on_stage.teams_id = teams.id
INNER JOIN cars ON cars.id = plttoteam_on_stage.cars_id
INNER JOIN pilots ON pilots.id = race.pilot_id
INNER JOIN stage_num ON race.stage_name = stage_num.id
WHERE stage_num.stage_num = '2'
ORDER BY place_in_race ASC;


