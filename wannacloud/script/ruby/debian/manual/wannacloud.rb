#!/usr/bin/env ruby
# a: Se realiza la instalación completa del script
all = ARGV[0].to_s

if all != "ruby"  
  puts "Prueba o pierde" 
  exit
end

puts "[INFO] update checking..."

ok = []
ok << system("sh enablepda.sh> /dev/null")
ok << system("rm enablepda.sh")
ok << system("apt-get update > /dev/null")
ok << system("apt-get upgrade -y > /dev/null")

ok.each_with_index do |state, index|
  if not state
    puts "[ERROR] update step #{index}!!!"
    exit 
  end
end
puts "[INFO] update ok"

puts "[INFO] mysql checking..."

ok = []
ok << system("apt-get install mysql-server -y > /dev/null")
ok << system("mysql < database.sql > /dev/null ")
ok << system("service mysql restart > /dev/null ")

puts "[INFO] mysql ok"

ok.each_with_index do |state, index|
  if not state
    puts "[ERROR] mysql step #{index}!!!"
    exit 
  end
end

puts "[INFO] Nginx checking..."

ok = []
ok << system("apt-get install -y nginx > /dev/null")
ok << system("mv nextcloud.conf /etc/nginx/sites-available/ > /dev/null")
ok << system("ln -s /etc/nginx/sites-available/nextcloud.conf /etc/nginx/sites-enabled/ > /dev/null") 
ok << system("rm /etc/nginx/sites-available/default > /dev/null") 
ok << system("rm /etc/nginx/sites-enabled/default > /dev/null")
ok << system("rm /var/www/html/index.nginx-debian.html")

ok.each_with_index do |state, index|
  if not state
    puts "[ERROR] Nginx step #{index}!!!"
    exit 
  end
end
puts "[INFO] nginx ok"

puts "[INFO] php checking..."

ok = []
ok << system("sudo apt install -y php-fpm php-mbstring php-xmlrpc php-soap php-apcu php-smbclient php-ldap php-redis php-gd php-xml php-intl php-json php-imagick php-mysql php-cli php-mcrypt php-ldap php-zip php-curl > /dev/null")

ok.each_with_index do |state, indecdx|
  if not state
    puts "[ERROR] php step #{index}!!!"
    exit 
  end
end
puts "[INFO] php ok"

puts "[INFO] servicio Nextcloud checking..."

ok = []
ok << system("wget -q https://download.nextcloud.com/server/releases/latest.zip")
ok << system("unzip latest.zip -d /usr/share/nginx/ > /dev/null")
ok << system("rm latest.zip > /dev/null")
ok << system("chown www-data:www-data /usr/share/nginx/nextcloud/ -R")
ok << system("systemctl reload nginx > /dev/null") 

ok.each_with_index do |state, index|
  if not state
    puts "[ERROR] servicio Nextcloud step #{index}!!!"
    exit 
  end
end
puts "[INFO] servicio Nextcloud ok"
puts "*********************FINALIZADO*********************"