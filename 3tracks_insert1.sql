INSERT INTO racing_facilities(
	name, coordinates_latitude, coordinates_longitude)
	VALUES ('Moscow Raceway', 55.996498, 36.270057),
	('ADM Raceway', 55.564563, 37.991189),
	('Smolensk ring', 54.987411, 33.366555),
	('NRing', 56.119653, 43.601236),
	('Atron international circuit', 55.162014,37.350472);

INSERT INTO tracks(
	facility, configuration, length, num_of_turns)
	VALUES ('Moscow Raceway', 'Grand Prix 1', 3955, 15),
	('ADM Raceway', 'SUPERSPRINT', 1056, 7),
	('ADM Raceway', 'Grade 4', 3240, 13),
	('NRing', 'A', 3222, 15),
	('Atron international circuit', 'karting', 1400, 18),
	('ADM Raceway', 'SPRINT', 2150, 16),
	('Smolensk ring', 'default', 3362, 13);
