-- POI's
INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Papa Johns',
	'400 S. 300 E. Salt Lake City, UT 84102',
	'http://www.papajohnspizza.com/',
	'8011234567',
	5,
	1970,
	'12:00am-12:00pm',
	'restaurant');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Corner Bakery Cafe',
	'610 Foothill Dr, Salt Lake City, UT 84113',
	'www.cornerbakerycafe.com',
	'3859839832',
	8,
	2004,
	'6:30AM-9PM',
	'cafe');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Daynes Music',
	'6000ish State Street',
	'www.daynesmusic.com',
	'8011112222',
	150000,
	1968,
	'9am-8pm',
	'store');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Pizza Factory',
	'St. George, UT 84790',
	'http://www.pizzafactory.com/',
	'4351231234',
	6,
	1982,
	'12:00am-12:00pm',
	'restaurant');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Barnes and Noble',
	'UT',
	'http://www.banurl.com/',
	'8011234567',
	20,
	1970,
	'12:00am-12:00pm',
	'store');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Little Caesars',
	'UT',
	'http://www.littlecaesars.com/',
	'8011234567',
	2,
	1970,
	'12:00am-12:00pm',
	'restaurant');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Starbucks',
	'UT',
	'http://www.starbucks.com/',
	'8011234567',
	6,
	1970,
	'12:00am-12:00pm',
	'cafe');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Target',
	'UT',
	'http://www.target.com/',
	'8011234567',
	8,
	1970,
	'12:00am-12:00pm',
	'store');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Walmart',
	'UT',
	'http://www.walmart.com/',
	'8011234567',
	7,
	1970,
	'12:00am-12:00pm',
	'store');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'R&Rs',
	'UT',
	'http://www.rnrs.com/',
	'8011234567',
	7,
	1970,
	'12:00am-12:00pm',
	'restaurant');

INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category) VALUES (
	'Cafe Rio',
	'UT',
	'http://www.caferio.com/',
	'8011234567',
	7,
	1970,
	'12:00am-12:00pm',
	'restaurant');

-- Users
INSERT INTO Users VALUES (
	'john24',
	'John',
	false,
	'hello',
	'123 SLC',
	'1234567890');

INSERT INTO Users VALUES (
	'sam98',
	'Sam the Man',
	false,
	'sammy',
	'789 SLC',
	'1232569392');

INSERT INTO Users VALUES (
	'ted54',
	'Teddy',
	false,
	'ted',
	'St. George',
	'4351231234');

INSERT INTO Users VALUES (
	'abc1',
	'ABC1',
	false,
	'abc',
	'123 SLC',
	'1234567890');

INSERT INTO Users VALUES (
	'abc2',
	'ABC2',
	false,
	'abc',
	'123 SLC',
	'1234567890');

INSERT INTO Users VALUES (
	'abc3',
	'ABC3',
	false,
	'abc',
	'123 SLC',
	'1234567890');

INSERT INTO Users VALUES (
	'bob00',
	'Bob',
	true,
	'world',
	'456 SLC',
	'0987654321');

-- Keywords
INSERT INTO Keywords (word) VALUES ('gospel');
INSERT INTO Keywords (word) VALUES ('hello');
INSERT INTO Keywords (word) VALUES ('world');
INSERT INTO Keywords (word) VALUES ('sandwich');
INSERT INTO Keywords (word) VALUES ('soup');
INSERT INTO Keywords (word) VALUES ('salad');
INSERT INTO Keywords (word) VALUES ('pizza');
INSERT INTO Keywords (word) VALUES ('piano');

-- HasKeywords
INSERT INTO HasKeywords VALUES (
	(select pid from POI where name = 'Papa Johns'),
	(select wid from Keywords where word = 'pizza'));

INSERT INTO HasKeywords VALUES (
	(select pid from POI where name = 'Corner Bakery Cafe'),
	(select wid from Keywords where word = 'sandwich'));

INSERT INTO HasKeywords VALUES (
	(select pid from POI where name = 'Corner Bakery Cafe'),
	(select wid from Keywords where word = 'soup'));

INSERT INTO HasKeywords VALUES (
	(select pid from POI where name = 'Corner Bakery Cafe'),
	(select wid from Keywords where word = 'salad'));

INSERT INTO HasKeywords VALUES (
	(select pid from POI where name = 'Daynes Music'),
	(select wid from Keywords where word = 'piano'));

-- Favorites
INSERT INTO Favorites VALUES (
	'john24',
	(select pid from POI where name = 'Papa Johns'));

INSERT INTO Favorites VALUES (
	'john24',
	(select pid from POI where name = 'Corner Bakery Cafe'));

INSERT INTO Favorites VALUES (
	'sam98',
	(select pid from POI where name = 'Corner Bakery Cafe'));

INSERT INTO Favorites VALUES (
	'sam98',
	(select pid from POI where name = 'Daynes Music'));

INSERT INTO Favorites VALUES (
	'ted54',
	(select pid from POI where name = 'Daynes Music'));

INSERT INTO Favorites VALUES (
	'ted54',
	(select pid from POI where name = 'Pizza Factory'));

INSERT INTO Favorites VALUES (
	'abc1',
	(select pid from POI where name = 'Papa Johns'));

INSERT INTO Favorites VALUES (
	'abc1',
	(select pid from POI where name = 'Pizza Factory'));

INSERT INTO Favorites VALUES (
	'abc2',
	(select pid from POI where name = 'Pizza Factory'));

INSERT INTO Favorites VALUES (
	'abc2',
	(select pid from POI where name = 'Cafe Rio'));

-- VisitEvent
INSERT INTO VisitEvent (cost, num_of_people) VALUES (12, 4);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (8, 6);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (12, 4);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (4, 2);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (3, 1);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (1, 9);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (7, 3);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (9, 1);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (0, 3);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (6, 2);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (6, 2);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (7, 4);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (8, 6);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (9, 5);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (10, 2);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (5, 1);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (4, 3);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (3, 8);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (0, 1);
INSERT INTO VisitEvent (cost, num_of_people) VALUES (13, 2);

-- Visit
INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Papa Johns'),
	1,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'sam98',
	(select pid from POI where name = 'Corner Bakery Cafe'),
	2,
	STR_TO_DATE('12-25-2016', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Papa Johns'),
	3,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc1',
	(select pid from POI where name = 'Papa Johns'),
	4,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc1',
	(select pid from POI where name = 'Daynes Music'),
	5,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Corner Bakery Cafe'),
	5,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc2',
	(select pid from POI where name = 'Pizza Factory'),
	6,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc2',
	(select pid from POI where name = 'Papa Johns'),
	7,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc2',
	(select pid from POI where name = 'Pizza Factory'),
	8,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc2',
	(select pid from POI where name = 'Pizza Factory'),
	9,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc1',
	(select pid from POI where name = 'Pizza Factory'),
	10,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Barnes and Noble'),
	11,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Little Caesars'),
	12,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Cafe Rio'),
	13,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'sam98',
	(select pid from POI where name = 'Cafe Rio'),
	14,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Walmart'),
	15,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'Target'),
	16,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'R&Rs'),
	17,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'ted54',
	(select pid from POI where name = 'Walmart'),
	18,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'abc1',
	(select pid from POI where name = 'Walmart'),
	19,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

INSERT INTO Visit VALUES (
	'john24',
	(select pid from POI where name = 'R&Rs'),
	20,
	STR_TO_DATE('1-30-2015', '%m-%d-%Y'));

-- Feedback
INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Papa Johns'),
	'john24',
	10,
	'This place was super good!  Love their garlic sauce!',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Papa Johns'),
	'sam98',
	7,
	'Good sandwich.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Daynes Music'),
	'sam98',
	8,
	'Nice pianos.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Pizza Factory'),
	'sam98',
	9,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Barnes and Noble'),
	'sam98',
	6,
	'Filler text',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Little Caesars'),
	'sam98',
	5,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Starbucks'),
	'sam98',
	2,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Target'),
	'sam98',
	7,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Walmart'),
	'sam98',
	7,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Cafe Rio'),
	'sam98',
	9,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Cafe Rio'),
	'john24',
	10,
	'Original, awesome pizza.',
	CURDATE());

INSERT INTO Feedback (pid, username, score, text, fbdate) VALUES (
	(select pid from POI where name = 'Papa Johns'),
	'ted54',
	3,
	'Must have been an off day for them.',
	CURDATE());

-- Rates
INSERT INTO Rates VALUES (
	'sam98',
	(select fid from Feedback where username = 'john24' and
		pid = (select pid from POI where name = 'Papa Johns')),
	1);

INSERT INTO Rates VALUES (
	'john24',
	(select fid from Feedback where username = 'sam98' and
		pid = (select pid from POI where name = 'Daynes Music')),
	0);

INSERT INTO Rates VALUES (
	'abc1',
	(select fid from Feedback where username = 'sam98' and
		pid = (select pid from POI where name = 'Daynes Music')),
	1);

INSERT INTO Rates VALUES (
	'abc1',
	(select fid from Feedback where username = 'john24' and
		pid = (select pid from POI where name = 'Papa Johns')),
	2);

INSERT INTO Rates VALUES (
	'abc2',
	(select fid from Feedback where username = 'john24' and
		pid = (select pid from POI where name = 'Papa Johns')),
	2);

INSERT INTO Rates VALUES (
	'abc1',
	(select fid from Feedback where username = 'ted54' and
		pid = (select pid from POI where name = 'Papa Johns')),
	0);

INSERT INTO Rates VALUES (
	'abc2',
	(select fid from Feedback where username = 'ted54' and
		pid = (select pid from POI where name = 'Papa Johns')),
	0);

-- Trust
INSERT INTO Trust VALUES ('sam98', 'john24', 1);
INSERT INTO Trust VALUES ('ted54', 'john24', 1);
INSERT INTO Trust VALUES ('abc1', 'john24', -1);
INSERT INTO Trust VALUES ('abc2', 'john24', 1);
INSERT INTO Trust VALUES ('abc3', 'john24', 1);
INSERT INTO Trust VALUES ('abc1', 'sam98', -1);
INSERT INTO Trust VALUES ('abc2', 'sam98', 1);
INSERT INTO Trust VALUES ('abc3', 'sam98', -1);
INSERT INTO Trust VALUES ('abc1', 'ted54', 1);
INSERT INTO Trust VALUES ('abc2', 'ted54', -1);
