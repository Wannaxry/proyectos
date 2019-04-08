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

Para empezar la instalación lo primero que haremos es instalar el Servidor Web *nginx*:

`apt-get install -y nginx`

Una vez instalado movemos el fichero nextcloud.conf que dejare en la carpeta de **Download** que contiene la configuración para el servidor *Nextcloud*, se movera al directotio **Sites-avaible** que es donde alojaremos las futuras configuraciónes de los sitios web antes de ser publicados:

`mv nextcloud.conf /etc/nginx/sites-available/ `

Realizamos un enlace simbólico en el directorio **sites-enable** para activar el sitio web y que **Nextcloud** se nos active:

`ln -s /etc/nginx/sites-available/nextcloud.conf /etc/nginx/sites-enabled`

Eliminamos el fichero que viene por defecto de nginx para evitar errores:

```
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
rm /var/www/html/index.nginx-debian.html
```

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

`create database wannacloud;`

Creamos el usuario para la base de datos:

`create user 'wannacry'@'localhost' identiFied by 'Atistirma_22';`

Le damos todos los privilegios 

`grant all privileges on wannacloud.* to 'wannacry'@'localhost';`

Recargamos los privilegios:

`flush privileges;`

### PHP 7.0

Para realizar la instalación del **PHP** vamos al terminal y escribimos:

```
sudo apt-get install -y php7.0 php7.0-bz2 php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-sqlite3 php7.0-xml php7.0-zip php-apcu php-pear

```

### Nextcloud (WannaCloud)

Descargamos la ultima versión de Nextcloud para instalarlo en el servidor:

`wget -q https://download.nextcloud.com/server/releases/latest.zip`

Descomprimimos el fichero .zip que se nos descarga:

`unzip nextcloud-12.0.5.zip`  

Movemos el directorio a donde queramos alojarlo aunque estos dos pasos también se pueden hacer al revés:

`mv nextcloud /usr/share/` 

Eliminamos el fichero que se nos descargo:

`rm latest.zip` 

Creamos el directorio data:

`mkdir /usr/share/nextcloud/data`

Y ejecutamos el script con los comandos aunque tambien podemos ejecutarlos directamente:

`sh permisos.sh`

o

```
chown -R www-data:www-data /usr/share/nextcloud;
chown -R www-data:www-data /usr/share/nextcloud/data;
find /usr/share/nextcloud/ -type d -exec chmod 750 {} \; 
find /usr/share/nextcloud/ -type f -exec chmod 640 {} \; 
find /usr/share/nextcloud/data -type d -exec chmod 750 {} \; 
find /usr/share/nextcloud/data -type f -exec chmod 640 {} \;

```

Y por ultimo recargamos el Servicio para que se carguen los cambios realizados:

`systemctl reload nginx` 

Y entramos en el navegador con la IP de nuestro ordenador, sino sabemos cual es escribimos `ip a` y nos saldra.

Accedemos y ponemos nuestros datos, tanto como administrador, como la base de datos creada anteriormente con sus respectivos campos:

Y una vez completado todo le damos a **Completar** y ya estaría y tocaria esperar a que se instale:

