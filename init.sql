
psql postgres (если ничего нет и все чисто)
psql (название базы)

create database parser_avto_db;
\c database parser_avto_db; // входим в базу, если не написать, то создаться в системе (мало приятно)
 create table  avto_storage ( id SERIAL CONSTRAINT avto_storage_primary_key PRIMARY KEY,external_id integer, manufacturer varchar(255) ,
model varchar (255), color varchar (50), year  integer , price float , currency varchar (10),source varchar (255));
//  \q - выйти из базы

