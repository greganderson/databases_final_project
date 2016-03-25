-- Figure out NOT NULL fields

CREATE TABLE POI(
	pid INT AUTO_INCREMENT,
	name VARCHAR(50),
	address VARCHAR(80),
	url VARCHAR(50),
	phone_num CHAR(10),
	price_per_person INT,
	year_of_est INT,
	hours CHAR(21),
	category VARCHAR(50),
	PRIMARY KEY (pid, name));

CREATE TABLE Keywords(
	wid INT AUTO_INCREMENT,
	word CHAR(50) UNIQUE,
	PRIMARY KEY (wid, word));

CREATE TABLE HasKeywords(
	pid INT,
	wid INT,
	PRIMARY KEY (pid, wid),
	FOREIGN KEY (pid) REFERENCES POI(pid),
	FOREIGN KEY (wid) REFERENCES Keywords(wid));

CREATE TABLE Users(
	username CHAR(30),
	name VARCHAR(40),
	is_admin BOOLEAN,
	password VARCHAR(30),
	address VARCHAR(80),
	phone_num CHAR(10),
	PRIMARY KEY (username));

CREATE TABLE Trust(
	username1 CHAR(30),
	username2 CHAR(30),
	is_trusted INT,
	PRIMARY KEY (username1, username2),
	FOREIGN KEY (username1) REFERENCES Users(username),
	FOREIGN KEY (username2) REFERENCES Users(username));

CREATE TABLE Favorites(
	username CHAR(30),
	pid INT,
	PRIMARY KEY (username, pid),
	FOREIGN KEY (username) REFERENCES Users(username),
	FOREIGN KEY (pid) REFERENCES POI(pid));

CREATE TABLE VisitEvent(
	vid int AUTO_INCREMENT,
	cost int,
	num_of_people int,
	PRIMARY KEY (vid));

CREATE TABLE Visit(
	username CHAR(30),
	pid INT,
	vid INT,
	visit_date DATE,
	PRIMARY KEY (username, pid, vid),
	FOREIGN KEY (username) REFERENCES Users(username),
	FOREIGN KEY (pid)   REFERENCES POI(pid),
	FOREIGN KEY (vid)   REFERENCES VisitEvent(vid));

CREATE TABLE Feedback(
	fid INT AUTO_INCREMENT,
	pid INT,
	username CHAR(30),
	score INT,
	text CHAR(100),
	fbdate DATE,
	PRIMARY KEY (fid),
	FOREIGN KEY (pid) REFERENCES POI(pid),
	FOREIGN KEY (username) REFERENCES Users(username));

CREATE TABLE Rates(
	username CHAR(30),
	fid INT,
	rating INT,
	PRIMARY KEY (username, fid),
	FOREIGN KEY (username) REFERENCES Users(username),
	FOREIGN KEY (fid) REFERENCES Feedback(fid));
