chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /var/www/html/data
find /var/www/html -type d -exec chmod 750 {} \; 
find /var/www/html -type f -exec chmod 640 {} \; 
find /var/www/html/data -type d -exec chmod 750 {} \; 
find /var/www/html/data -type f -exec chmod 640 {} \;