select distinct pilots.surname, pilots."name" from pilots
JOIN plttoteam_on_stage on pilots.id = plttoteam_on_stage.pilots_id
JOIN stages on stages.id = plttoteam_on_stage.stages_id
JOIN championships on stages.championships_id = championships.id
WHERE championships.start_date >= '2024.001'
ORDER BY pilots.surname, pilots."name" ASC;
