create database wannacloud;
create user 'wannacry'@'localhost' identiFied by 'Atistirma_22';
grant all privileges on wannacloud.* to 'wannacry'@'localhost';
update mysql.user set password=PASSWORD("atistirma22") where user='wannacry';
flush privileges;