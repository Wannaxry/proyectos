#!/usr/bin/env ruby
# a: Se realiza la instalación completa del script
all = ARGV[0].to_s

if all != "ruby"  
  puts "Prueba o pierde" 
  exit
end

puts "[INFO] hola jesus"

puts "[INFO] update checking..."

ok = []
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/proyectos/master/wannacloud/script/ruby/debian/manual/enablepda.sh > /dev/null")
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
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/proyectos/master/wannacloud/script/ruby/debian/manual/database.sql > /dev/null")
ok << system("mysql < database.sql")
ok << system("rm database.sql > /dev/null")
ok << system("service mysql restart > /dev/null")

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
ok << system("wget -q https://raw.githubusercontent.com/Wannaxry/proyectos/master/wannacloud/script/ruby/debian/manual/nextcloud.conf > /dev/null")
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
ok << system("apt-get install -y php7.3-fpm php7.3-gd php7.3-mysql php7.3-curl php7.3-xml php7.3-zip php7.3-intl php7.3-mbstring php7.3-json php7.3-bz2 php7.3-ldap php-apcu imagemagick php-imagick php-smbclient > /dev/null")

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
ok << system("unzip latest-13.zip -d /usr/share/nginx/ > /dev/null")
ok << system("rm latest-13.zip > /dev/null")
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