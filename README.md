# WannaCloud

En este proyecto se trata de una nube gestionada de forma local en el cual la empresa instala configura y es dueña de su propia nube con posibilidad de poder conectarse remotamente desde cualquier parte, gestionando sus propios datos sin que empresas externas lo hagan por ellos.

## Software a instalar

Software necesario para la instalación:

- ***Nginx***-***Apache***: En este caso se usará **nginx** debido que es mas ligero y mas facil de configurar.

-  ***PHP 7.0***: La versión a usar ya es depende de la versión que quieran instalar, en mi caso cojo esta ya que es la que se me instala en la *raspberry*.
  
- ***MYSQL***: Para la gestión de base de datos.
 
- ***NO-IP***: Usaremos **no-ip** para poder conectarnos a ella por internet, para poder acceder tanto por *navegador* como por *ssh*
- ***Nextcloud***: Es el software el cual se va a usar para este proyecto.

## Instalación de WannaCloud

### Nginx

ok << system("rm /etc/nginx/sites-available/default > /dev/null") 
ok << system("rm /etc/nginx/sites-enabled/default > /dev/null")
ok << system("apt-get install -y nginx > /dev/null")

### Mysql

Los primeros pasos no tienen orden, cada uno elige como lo instala pero yo lo realizo de esta manera por que me resulta mas facíl a la hora se realizar la isntalación.

Lo primero que hago es instalar mysql, creo la base de datos y configuro el usuario asignandole todos los permisos:
Para ello instalamos mysql:
`apt install mysql -y` 
(le ponemos el paramtero **-y** para que no pregunte e instale de "golpe").

Ahora por seguridad ejecutamos el comando `mysql_secure_instalation`:

Ponemos la contraseña de root


`Enter current password for root (enter for none): ******`

Si queremos cambiar la contraseña le ponemos `y` y sino `n`:

`Change the root password? [Y/n] n`

Eliminamos el usuario anonimo con las mismas opciónes que la anterior:

`Remove anonymous users? [Y/n] y`

Eliminamos el usuario anonimo:

`Disallow root login remotely? [Y/n] y`

Eliminamos la base de datos de test:

`Remove test database and access to it? [Y/n]` y

Realizamos una recarga de los privilegios:

`Reload privilege tables now? [Y/n] y`

Accedemos a la base de datos mediante:
`mysql -u root -p`

Le ponemos la contraseña de root que pusimos anteriormente y realizamos lo siguiente:

Creamos la base de datos:

create database wannacloud;

Creamos el usuario para la base de datos:

create user 'wannacry'@'localhost' identiFied by 'Atistirma_22';

Le damos todos los privilegios 

grant all privileges on wannacloud.* to 'wannacry'@'localhost';

Recargamos los privilegios:

flush privileges;

### PHP 7.0

Para realizar la instalación del **PHP** vamos al terminal y escribimos:

`apt-get install -y php7.0 php7.0-bz2 php7.0-cli php7.0-curl php7.0-gd php7.0-fpm php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php-pear php7.0-imap php-memcache php7.0-pspell php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-mysql php7.0-opcache php7.0-xml php7.0-zip php-imagick php-redis libapache2-mod-php7.0`

