CREATE SEQUENCE user_type_id_seq;
ALTER TABLE user_type ALTER id SET DEFAULT NEXTVAL('user_type_id_seq');

CREATE SEQUENCE saybolt_user_id_seq;
ALTER TABLE saybolt_user ALTER id SET DEFAULT NEXTVAL('saybolt_user_id_seq');

CREATE SEQUENCE vli_user_id_seq;
ALTER TABLE vli_user ALTER id SET DEFAULT NEXTVAL('vli_user_id_seq');

CREATE SEQUENCE samples_id_seq;
ALTER TABLE samples ALTER id SET DEFAULT NEXTVAL('samples_id_seq');

CREATE SEQUENCE sample_type_id_seq;
ALTER TABLE sample_type ALTER id SET DEFAULT NEXTVAL('sample_type_id_seq');
