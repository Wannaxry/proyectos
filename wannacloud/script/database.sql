create database wannacloud;
create user 'wannacry'@'%' identiFied by 'Atistirma_22';
grant all privileges on wannacloud.* to 'wannacry'@'%';
update mysql.user set password=PASSWORD("atistirma22") where user='wannacry';
flush privileges;