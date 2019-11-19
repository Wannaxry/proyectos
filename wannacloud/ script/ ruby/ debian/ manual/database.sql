create database cloud;
create user 'nextuser'@'%' identiFied by 'cloudpassword';
grant all privileges on cloud.* to 'nextuser'@'%';
flush privileges;
