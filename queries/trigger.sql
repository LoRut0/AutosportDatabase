CREATE OR REPLACE FUNCTION check_stage_finish_date_func()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (
		SELECT 1 FROM championships
            WHERE id = NEW.championships_id
              AND (finish_date IS NOT NULL AND NEW.finish_date > finish_date)
        ) THEN
            RAISE EXCEPTION 'Дата окончания этапа (%) не может быть позже даты окончания чемпионата',
                NEW.finish_date;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stage_finish_date
BEFORE INSERT OR UPDATE ON stages
FOR EACH ROW
WHEN (NEW.finish_date IS NOT NULL)
EXECUTE FUNCTION check_stage_finish_date_func();
