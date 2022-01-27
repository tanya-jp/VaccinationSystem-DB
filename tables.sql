-- `DB`.System_info definition

--  Drop table

--  DROP TABLE `DB`.System_info;
-- 
CREATE TABLE `DB`.System_info (
	ID char(10) NOT null,
-- 	check (ID RLIKE '[0-9]{10}'),
	pass varchar(512) NOT null,
-- 	check (pass like '%[0-9]%' and pass like '^[a-zA-Z]{8,}$'),
	registration_date date,
	registration_time time,
	PRIMARY KEY (ID)
-- 	check(NOT LIKE '%[^0-9]%'),
-- 	check (length(password) >= 8)
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.System_info;

-- `DB`.person_info definition

--  Drop table

--  DROP TABLE `DB`.person_info;
-- 
CREATE TABLE `DB`.person_info (
	ID char(10) NOT null,
-- 	check (ID RLIKE '[0-9]{10}'),
	fist_name varchar(512),
	last_name varchar(512),
	gender varchar(16),
-- 	CHECK (gender IN("Male", "Female")),
	disease varchar(4),
-- 	CHECK (disease IN("yes", "no")),
	birthday date,
	PRIMARY KEY (ID),
	foreign key (ID) references System_info(ID)
	ON DELETE cascade
	ON UPDATE CASCADE
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.person_info;

-- `DB`.doctor definition

--  Drop table

--  DROP TABLE `DB`.doctor;
-- -- 
CREATE TABLE `DB`.doctor (
	ID char(10) NOT null,
-- 	check (ID RLIKE '[0-9]{10}'),
	doctor_ID char(5) NOT null,
-- 	check (doctor_ID RLIKE '[0-9]{5}'),
	PRIMARY KEY (doctor_ID),
	foreign key (ID) references person_info(ID)
	ON DELETE CASCADE
    ON UPDATE CASCADE
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.doctor;

-- `DB`.nurse definition

--  Drop table

--  DROP TABLE `DB`.nurse;

CREATE TABLE `DB`.nurse (
	ID char(10) NOT null,
-- 	check (ID RLIKE '[0-9]{10}'),
	nurse_ID char(8) NOT null,
-- 	check (nurse_ID RLIKE '[0-9]{8}'),
	nurse_level varchar(32),
-- 	CHECK (nurse_level IN("matron", "supervisor", "nurse", "paramadic")),
	PRIMARY KEY (nurse_ID),
	foreign key (ID) references person_info(ID)
	ON DELETE CASCADE
    ON UPDATE CASCADE
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.nurse;

-- `DB`.brand definition

--  Drop table

 DROP TABLE `DB`.brand;
-- 
CREATE TABLE `DB`.brand (
	name varchar(32) PRIMARY KEY,
    dose int,
    days int, 
    doctor_ID char(5) NOT null,
--     check (doctor_ID RLIKE '[0-9]{5}'),
    foreign key (doctor_ID) references doctor(doctor_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.brand;

-- `DB`.health_center definition

--  Drop table

--  DROP TABLE `DB`.health_center;

CREATE TABLE `DB`.health_center (
	name varchar(32) PRIMARY KEY,
    address varchar(512)
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.health_center;

-- `DB`.vial definition

--  Drop table

--  DROP TABLE `DB`.vial;
-- 
CREATE TABLE `DB`.vial (
	serial_number varchar(32) PRIMARY key,
	check (serial_number RLIKE '[0-9]'),
    dose int,
    production_date date, 
    name varchar(32),
    foreign key (name) references brand(name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.brand;

-- `DB`.history definition

--  Drop table

 DROP TABLE `DB`.history;

CREATE TABLE `DB`.history (
    person_ID char(10),
    vaccinator_ID char(8),
    vaccination_center_name varchar(32),
    vial_serial varchar(32),
    vaccination_date date,
    FOREIGN KEY(person_ID) REFERENCES person_info(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(vaccinator_ID) REFERENCES nurse(nurse_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(vaccination_center_name) REFERENCES health_center(name),
    FOREIGN KEY(vial_serial) REFERENCES vial(serial_number),
    PRIMARY KEY(person_ID, vaccinator_ID, vaccination_center_name, vial_serial),
    score integer
    CHECK(score>=1 and score<=5)
)
-- ENGINE=InnoDB
-- DEFAULT CHARSET=utf8mb4
-- COLLATE=utf8mb4_general_ci;
-- DROP TABLE IF EXISTS `DB`.history;

--  DROP TABLE `DB`.login;
-- 
CREATE TABLE `DB`.login (
    ID char(10) not null unique,
    login_time Time,
    primary key(login_time),
	foreign key(ID) references system_info(ID)
)