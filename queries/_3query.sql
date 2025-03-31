SELECT DISTINCT teams."name" AS team_name, managers.patronymic AS manager_patronymic, managers."name" as manager_name, managers.surname as manager_surname, managers.phone from plttoteam_on_stage
JOIN teams ON plttoteam_on_stage.teams_id = teams.id
JOIN managers ON managers.id = teams.managers_id
JOIN stages ON stages.id = plttoteam_on_stage.stages_id
JOIN championships ON championships.id = stages.championships_id
WHERE championships.start_date >= '2024.001' --first day of 2024
