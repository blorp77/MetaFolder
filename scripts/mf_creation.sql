/***********************************************
 * MetaFolder database creation script         *
 *                                             *
 * psql -U mf -d mf -f scripts/mf_populate.sql *
 ***********************************************/

--Delete previous database if it exists
DROP TABLE IF EXISTS mf_user_project CASCADE;
DROP TABLE IF EXISTS mf_user CASCADE;
DROP TABLE IF EXISTS mf_document CASCADE;
DROP TABLE IF EXISTS mf_project CASCADE;
DROP TABLE IF EXISTS mf_metadata_value CASCADE;
DROP TABLE IF EXISTS mf_metadata_instance CASCADE;
DROP TABLE IF EXISTS mf_metadata_type CASCADE;

--Metadata-related tables
CREATE TABLE mf_metadata_type (
	id  	SERIAL 		PRIMARY KEY, 
	name 	varchar(255) 	NOT NULL
);

CREATE TABLE mf_metadata_instance (
	id  			SERIAL 		PRIMARY KEY, 
	id_metadata_type 	integer 	NOT NULL, 
	id_project 		integer 	NOT NULL, 
	name 			varchar(255) 	NOT NULL, 
	possible_values 	varchar(1000) 	DEFAULT '', --Comma separated values
	is_required 		boolean 	DEFAULT FALSE
);

CREATE TABLE mf_metadata_value (
	id  			SERIAL 		PRIMARY KEY, 
	id_metadata_instance 	integer 	NOT NULL, 
	id_document 		integer 	NOT NULL,
	metadata_value 		varchar(255)
);

--Project-related tables
CREATE TABLE mf_project (
	id  		SERIAL 		PRIMARY KEY, 
	id_creator 	integer 	NOT NULL, 
	date_creation 	TIMESTAMP 	DEFAULT now(), 
	name 		varchar(255) 	NOT NULL
);

CREATE TABLE mf_document (
	id  		SERIAL 		PRIMARY KEY, 
	id_project 	integer 	NOT NULL, 
	id_uploader 	integer 	NOT NULL, 
	date_upload	TIMESTAMP	DEFAULT now(),
	name 		varchar(255) 	NOT NULL, 
	file_path 	varchar(255) 	NOT NULL
);

--User-related tables
CREATE TABLE mf_user_project (
	id_user 	integer 	NOT NULL, 
	id_project 	integer 	NOT NULL, 
	access_rights	smallint 	NOT NULL,
	PRIMARY KEY (id_user, id_project)
);

CREATE TABLE mf_user (
	id  		SERIAL 		PRIMARY KEY, 
	email 		varchar(255) 	NOT NULL, 
	password 	varchar(255) 	NOT NULL, 
	first_name 	varchar(255) 	NOT NULL, 
	last_name 	varchar(255) 	NOT NULL, 
	join_date 	TIMESTAMP 	DEFAULT now(), 
	is_active 	boolean 	DEFAULT TRUE
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
INSERT INTO mf_metadata_type (name) VALUES ('numeric');
INSERT INTO mf_metadata_type (name) VALUES ('numeric_with_decimals');
INSERT INTO mf_metadata_type (name) VALUES ('text');
INSERT INTO mf_metadata_type (name) VALUES ('text_with_options');
INSERT INTO mf_metadata_type (name) VALUES ('date');
INSERT INTO mf_metadata_type (name) VALUES ('date_with_time_of_day');
