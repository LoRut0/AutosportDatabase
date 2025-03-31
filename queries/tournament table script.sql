WITH lap_table as (SELECT 
    p.id AS pilot_id,
    s.id AS stage_name,
    l.flag,
    COUNT(l.lap) AS total_laps,
	
	CASE 
		WHEN l.flag = '0' THEN MIN(l.time)
		ELSE SUM(l.time)
	END + COALESCE(SUM(plty.penalty), 0) as time_with_pnlty,
	
	COALESCE(SUM(plty.penalty), 0) as penalty,
	
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
    s.id, l.flag, time_with_pnlty ASC)

SELECT ROW_NUMBER() OVER (PARTITION BY stage_name, "flag" ORDER BY time_with_pnlty) AS place, 
	lap_table.*	
FROM lap_table

