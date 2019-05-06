#!/usr/bin/env ruby
# a: Se realiza la instalación completa del script
all = ARGV[0].to_s

if all != "ruby"  
  puts "Prueba o pierde" 
  exit
end

puts "[INFO] update checking..."

ok = []
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
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/script/master/wannacloud/database.sql")
ok << system("mysql < database.sql")
ok << system("rm database.sql' > /dev/null ")
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
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/script/master/wannacloud/nextcloud.conf> /dev/null")
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
ok << system("apt-get install -y php7.0 php7.0-bz2 php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-sqlite3 php7.0-xml php7.0-zip php-apcu php-pear > /dev/null")

ok.each_with_index do |state, indecdx|
  if not state
    puts "[ERROR] php step #{index}!!!"
    exit 
  end
end
puts "[INFO] php ok"

puts "[INFO] servicio Nextcloud checking..."

ok = []
ok << system("wget -q https://download.nextcloud.com/server/releases/latest-13.zip")
ok << system("unzip latest-13.zip > /dev/null ")
ok << system("mv nextcloud/* /var/www/html > /dev/null ")
ok << system("rm -r nextcloud/ > /dev/null ")
ok << system("rm latest-13.zip > /dev/null ")
ok << system("mkdir /var/www/html/data")
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/script/master/wannacloud/permisos.sh")
ok << system("sh permisos.sh")
ok << system("rm permisos.sh")
ok << system("systemctl reload nginx > /dev/null") 

ok.each_with_index do |state, index|
  if not state
    puts "[ERROR] servicio Nextcloud step #{index}!!!"
    exit 
  end
end
puts "[INFO] servicio Nextcloud ok"
puts "*********************FINALIZADO*********************"