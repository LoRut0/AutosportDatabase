CREATE TABLE cars (
    id         SERIAL NOT NULL,
    brand      VARCHAR(50) NOT NULL,
    model      VARCHAR(100),
    year       INTEGER NOT NULL,
    classes_name VARCHAR(100) NOT NULL
);

ALTER TABLE cars ADD CONSTRAINT cars_pk PRIMARY KEY ( id );

CREATE TABLE championships (
    id          SERIAL NOT NULL,
    name        VARCHAR(100) NOT NULL,
    start_date  DATE NOT NULL,
    finish_date DATE
);

ALTER TABLE championships ADD CONSTRAINT championships_pk PRIMARY KEY ( id );

CREATE TABLE classes (
    name VARCHAR(100) NOT NULL
);

ALTER TABLE classes ADD CONSTRAINT classes_pk PRIMARY KEY ( name );

CREATE TABLE lap (
    flag      CHAR(1) NOT NULL,
    time      INTEGER NOT NULL,
    lap       SMALLINT NOT NULL,
    pit_stop  CHAR(1) NOT NULL,
    tire_id  INTEGER NOT NULL,
    pilots_id INTEGER NOT NULL,
    stages_id INTEGER NOT NULL
);

COMMENT ON COLUMN lap.flag IS
    '1 - Race
0 - Qualification';

ALTER TABLE lap
    ADD CONSTRAINT lap_pk
        PRIMARY KEY ( lap,
                      flag,
                      pilots_id,
                      stages_id );

CREATE TABLE managers (
    id         SERIAL NOT NULL,
    surname    VARCHAR(100) NOT NULL,
    name       VARCHAR(100) NOT NULL,
    patronymic VARCHAR(100),
    phone      VARCHAR(15) NOT NULL
);

ALTER TABLE managers ADD CONSTRAINT managers_pk PRIMARY KEY ( id );

CREATE TABLE penalties (
    id        SERIAL NOT NULL,
    penalty   INTEGER NOT NULL,
    comment TEXT,
    lap_lap   SMALLINT NOT NULL,
    lap_flag  CHAR(1) NOT NULL,
    pilots_id INTEGER NOT NULL,
    stages_id INTEGER NOT NULL
);

CREATE UNIQUE INDEX penalties__idx ON
    penalties (
        lap_lap
    ASC,
        lap_flag
    ASC,
        pilots_id
    ASC,
        stages_id
    ASC );

ALTER TABLE penalties ADD CONSTRAINT penalties_pk PRIMARY KEY ( id );

CREATE TABLE pilots (
    id         SERIAL NOT NULL,
    surname    VARCHAR(100) NOT NULL,
    name       VARCHAR(100) NOT NULL,
    patronymic VARCHAR(100),
    birthday   DATE NOT NULL
);

ALTER TABLE pilots ADD CONSTRAINT pilots_pk PRIMARY KEY ( id );

CREATE TABLE plttoteam_on_stage (
    quali_score     NUMERIC(10, 2),
    race_score      NUMERIC(10, 2),
    disqualificated CHAR(1) DEFAULT '0' NOT NULL,
    teams_id        INTEGER NOT NULL,
    pilots_id       INTEGER NOT NULL,
    stages_id       INTEGER NOT NULL,
	cars_id         INTEGER NOT NULL
);

ALTER TABLE plttoteam_on_stage ADD CONSTRAINT plttoteam_on_stage_pk PRIMARY KEY ( pilots_id,
                                                                                  stages_id );

CREATE TABLE stages (
    id               SERIAL NOT NULL,
    championships_id INTEGER NOT NULL,
    laps             INTEGER NOT NULL,
    start_date       DATE NOT NULL,
    finish_date      DATE,
    tracks_id        INTEGER NOT NULL
);

ALTER TABLE stages ADD CONSTRAINT stages_pk PRIMARY KEY ( id );

CREATE TABLE teams (
    id          SERIAL NOT NULL,
    name        VARCHAR(200) NOT NULL,
    managers_id INTEGER,
	UNIQUE (name)
);

/*CREATE UNIQUE INDEX teams__idx ON
    teams (
        managers_id
    ASC );*/

ALTER TABLE teams ADD CONSTRAINT teams_pk PRIMARY KEY ( id );

CREATE TABLE tire_manufacturers (
    id                SERIAL NOT NULL,
    manufacturer_name VARCHAR(100)
);

ALTER TABLE tire_manufacturers ADD CONSTRAINT tire_manufacturers_pk PRIMARY KEY ( id );

CREATE TABLE tire (
    id                    SERIAL NOT NULL,
    name             VARCHAR(100) NOT NULL,
    tire_manufacturers_id INTEGER NOT NULL
);

ALTER TABLE tire ADD CONSTRAINT tire_pk PRIMARY KEY ( id );

CREATE TABLE tracks (
    id                    SERIAL NOT NULL,
	facility              VARCHAR(200) NOT NULL,
    configuration         VARCHAR(1000) NOT NULL,
    length                INTEGER NOT NULL,
    num_of_turns          INTEGER NOT NULL,
	CONSTRAINT uniq_track UNIQUE (configuration, facility)
);

ALTER TABLE tracks ADD CONSTRAINT tracks_pk PRIMARY KEY ( id );

CREATE TABLE racing_facilities (
	name                    VARCHAR(200) NOT NULL,
    coordinates_latitude  NUMERIC(9, 6) NOT NULL,
    coordinates_longitude NUMERIC(9, 6) NOT NULL
);

ALTER TABLE racing_facilities ADD CONSTRAINT racing_facilities_pk PRIMARY KEY (name);

ALTER TABLE tracks
	ADD CONSTRAINT tracks_fk FOREIGN KEY (facility)
		REFERENCES racing_facilities (name);

ALTER TABLE cars
    ADD CONSTRAINT cars_classes_fk FOREIGN KEY ( classes_name )
        REFERENCES classes ( name );

ALTER TABLE lap
    ADD CONSTRAINT lap_plttoteamonstg_fk
        FOREIGN KEY ( pilots_id,
                      stages_id )
            REFERENCES plttoteam_on_stage ( pilots_id,
                                            stages_id )
                ON DELETE CASCADE;

ALTER TABLE lap
    ADD CONSTRAINT lap_tire_fk FOREIGN KEY ( tire_id )
        REFERENCES tire ( id );

ALTER TABLE penalties
    ADD CONSTRAINT penalties_lap_fk
        FOREIGN KEY ( lap_lap,
                      lap_flag,
                      pilots_id,
                      stages_id )
            REFERENCES lap ( lap,
                             flag,
                             pilots_id,
                             stages_id )
                ON DELETE CASCADE;

ALTER TABLE plttoteam_on_stage
    ADD CONSTRAINT plttoteamonstg_pilots_fk
        FOREIGN KEY ( pilots_id )
            REFERENCES pilots ( id )
                ON DELETE RESTRICT;

ALTER TABLE plttoteam_on_stage
    ADD CONSTRAINT plttoteamonstg_stages_fk
        FOREIGN KEY ( stages_id )
            REFERENCES stages ( id )
                ON DELETE RESTRICT;

ALTER TABLE plttoteam_on_stage
    ADD CONSTRAINT plttoteamonstg_teams_fk
        FOREIGN KEY ( teams_id )
            REFERENCES teams ( id )
                ON DELETE RESTRICT;

ALTER TABLE plttoteam_on_stage
    ADD CONSTRAINT plt_to_caronstg_fk
        FOREIGN KEY ( cars_id )
            REFERENCES cars ( id )
                ON DELETE RESTRICT;

ALTER TABLE stages
    ADD CONSTRAINT stages_championships_fk
        FOREIGN KEY ( championships_id )
            REFERENCES championships ( id )
                ON DELETE CASCADE;

ALTER TABLE stages
    ADD CONSTRAINT stages_tracks_fk FOREIGN KEY ( tracks_id )
        REFERENCES tracks ( id );

ALTER TABLE teams
    ADD CONSTRAINT teams_managers_fk
        FOREIGN KEY ( managers_id )
            REFERENCES managers ( id )
                ON DELETE SET NULL;

ALTER TABLE tire
    ADD CONSTRAINT tire_tire_manufacturers_fk FOREIGN KEY ( tire_manufacturers_id )
        REFERENCES tire_manufacturers ( id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             2
-- ALTER TABLE                             29
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

CREATE OR REPLACE FUNCTION check_stage_finish_date_func()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (
		SELECT 1 FROM championships
            WHERE id = NEW.championships_id
              AND (finish_date IS NOT NULL AND NEW.finish_date > finish_date OR NEW.start_date < start_date)
        ) THEN
            RAISE EXCEPTION 'Ошибка в датах этапа';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stage_finish_date
BEFORE INSERT OR UPDATE ON stages
FOR EACH ROW
EXECUTE FUNCTION check_stage_finish_date_func();

CREATE OR REPLACE FUNCTION check_lap_cnt_func()
RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.flag = '1' AND EXISTS (
		SELECT 1 
		FROM stages
        WHERE id = NEW.stages_id AND stages.laps < NEW.lap
    )) THEN
        RAISE EXCEPTION 'На данном этапе (id = %, laps = %) невозможно установить lap = %', 
		NEW.stages_id, (SELECT laps FROM stages WHERE id = NEW.stages_id), NEW.lap;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_lap_cnt
BEFORE INSERT OR UPDATE ON lap
FOR EACH ROW
EXECUTE FUNCTION check_lap_cnt_func();