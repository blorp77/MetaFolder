/***************************************
 * MetaFolder database creation script *
 ***************************************/

--Delete previous database if it exists
/*
ALTER TABLE mf_document DROP CONSTRAINT fkmf_Documen966268;
ALTER TABLE mf_project DROP CONSTRAINT fkmf_project810906;
ALTER TABLE mf_user_project DROP CONSTRAINT fkmf_user_Pr25468;
ALTER TABLE mf_user_project DROP CONSTRAINT fkmf_user_Pr542941;
ALTER TABLE mf_document DROP CONSTRAINT fkmf_Documen723623;
ALTER TABLE mf_metadata_instance DROP CONSTRAINT fkmf_Metadat481552;
ALTER TABLE mf_metadata_value DROP CONSTRAINT fkmf_Metadat640309;
ALTER TABLE mf_metadata_value DROP CONSTRAINT fkmf_Metadat335704;
ALTER TABLE mf_metadata_instance DROP CONSTRAINT fkmf_Metadat683101;
*/
DROP TABLE IF EXISTS mf_user_project CASCADE;
DROP TABLE IF EXISTS mf_user CASCADE;
DROP TABLE IF EXISTS mf_document CASCADE;
DROP TABLE IF EXISTS mf_project CASCADE;
DROP TABLE IF EXISTS mf_metadata_value CASCADE;
DROP TABLE IF EXISTS mf_metadata_instance CASCADE;
DROP TABLE IF EXISTS mf_metadata_type CASCADE;

--Metadata-related tables
CREATE TABLE mf_metadata_type (
	id  	SERIAL 			PRIMARY KEY, 
	name 	varchar(255) 	NOT NULL
);

CREATE TABLE mf_metadata_instance (
	id  				SERIAL 			PRIMARY KEY, 
	id_metadata_type 	integer 		NOT NULL, 
	id_project 			integer 		NOT NULL, 
	name 				varchar(255) 	NOT NULL, 
	possible_values 	varchar(1000) 	NOT NULL, --Comma separated values
	is_required 		boolean 		NOT NULL
);

CREATE TABLE mf_metadata_value (
	id  					SERIAL 		PRIMARY KEY, 
	id_metadata_instance 	integer 	NOT NULL, 
	id_document 			integer 	NOT NULL,
	metadata_value 			varchar(255)
);

--Project-related tables
CREATE TABLE mf_project (
	id  			SERIAL 			PRIMARY KEY, 
	id_creator 		integer 		NOT NULL, 
	date_creation 	TIMESTAMP 		NOT NULL, 
	name 			varchar(255) 	NOT NULL
);

CREATE TABLE mf_document (
	id  		SERIAL 			PRIMARY KEY, 
	id_project 	integer 		NOT NULL, 
	id_uploader integer 		NOT NULL, 
	name 		varchar(255) 	NOT NULL, 
	file_path 	varchar(255) 	NOT NULL
);

--User-related tables
CREATE TABLE mf_user_project (
	id_user 		integer 	PRIMARY KEY, 
	id_project 		integer 	PRIMARY KEY, 
	access_rights	smallint 	NOT NULL
);

CREATE TABLE mf_user (
	id  		SERIAL 			PRIMARY KEY, 
	email 		varchar(255) 	NOT NULL, 
	password 	varchar(255) 	NOT NULL, 
	first_name 	varchar(255) 	NOT NULL, 
	last_name 	varchar(255) 	NOT NULL, 
	join_date 	TIMESTAMP 		NOT NULL, 
	is_active 	boolean 		NOT NULL, 
);

--Foreign keys
ALTER TABLE mf_project 				ADD CONSTRAINT fk_mf_project 					FOREIGN KEY (id_creator) 			REFERENCES mf_user (id);
ALTER TABLE mf_document 			ADD CONSTRAINT fk_mf_document_user 				FOREIGN KEY (id_uploader) 			REFERENCES mf_user (id);
ALTER TABLE mf_document 			ADD CONSTRAINT fk_mf_document_project 			FOREIGN KEY (id_project) 			REFERENCES mf_project (id);
ALTER TABLE mf_user_project 		ADD CONSTRAINT fk_mf_user_project_project 		FOREIGN KEY (id_project) 			REFERENCES mf_project (id);
ALTER TABLE mf_user_project 		ADD CONSTRAINT fk_mf_user_project_user 			FOREIGN KEY (id_user) 				REFERENCES mf_user (id);
ALTER TABLE mf_metadata_instance 	ADD CONSTRAINT fk_mf_metadata_instance_project	FOREIGN KEY (id_project) 			REFERENCES mf_project (id);
ALTER TABLE mf_metadata_instance 	ADD CONSTRAINT fk_mf_metadata_instance_type		FOREIGN KEY (id_metadata_type) 		REFERENCES mf_metadata_type (id);
ALTER TABLE mf_metadata_value 		ADD CONSTRAINT fk_mf_metadata_value_document	FOREIGN KEY (id_document) 			REFERENCES mf_document (id);
ALTER TABLE mf_metadata_value 		ADD CONSTRAINT fk_mf_metadata_value_instance 	FOREIGN KEY (id_metadata_instance) 	REFERENCES mf_metadata_instance (id);

--Populate mf_metadata_type, this table is never modified by the software and is just for naming Metadata types
INSERT INTO mf_metadata_type (name) VALUES ("numeric");
INSERT INTO mf_metadata_type (name) VALUES ("numeric_with_decimals");
INSERT INTO mf_metadata_type (name) VALUES ("text");
INSERT INTO mf_metadata_type (name) VALUES ("text_with_options");
INSERT INTO mf_metadata_type (name) VALUES ("date");
INSERT INTO mf_metadata_type (name) VALUES ("date_with_time_of_day");