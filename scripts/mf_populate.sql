/***********************************************
 * Populating script for MetaFolder            *
 * Must execute mf_creation.sql first          *
 * Used only for unit testing or demonstration *
 *                                             *
 * psql -U mf -d mf -f scripts/mf_populate.sql *
 ***********************************************/
 
--Two users
INSERT INTO mf_user (email, password, first_name, last_name)
VALUES ('pgl@metafolder.com', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Philippe', 'Garand-Leduc');

INSERT INTO mf_user (email, password, first_name, last_name)
VALUES ('somebody@metafolder.com', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Some', 'Body');
	
--One existing Project
INSERT INTO mf_project (id_creator, date_creation, name)
VALUES (1, now(), 'Project 001');

--That contains one Document
INSERT INTO mf_document (id_project, id_uploader, name, file_path)
VALUES (1, 1, 'Document 001', 'no path');

--Link user to project
INSERT INTO mf_user_project (id_user, id_project, access_rights)
VALUES (1, 1, 0);


--Two metadata instances for Project 1
INSERT INTO mf_metadata_instance (id_metadata_type, id_project, name, possible_values, is_required)
VALUES (1, 1, 'Temperature', '', TRUE);

INSERT INTO mf_metadata_instance (id_metadata_type, id_project, name, possible_values, is_required)
VALUES (3, 1, 'Metal type', '', TRUE);

--Two metadata values for Document 1
INSERT INTO mf_metadata_value (id_metadata_instance, id_document, metadata_value)
VALUES (1, 1, '75');

INSERT INTO mf_metadata_value (id_metadata_instance, id_document, metadata_value)
VALUES (2, 1, 'Aluminium');
