SELECT 
	ROW_NUMBER() OVER (ORDER BY stages.start_date) AS stage_num, 
	stages.* 
FROM stages
INNER JOIN championships ON championships.id = stages.championships_id
WHERE championships."name" = 'LADA Time Attack Cup 2024'