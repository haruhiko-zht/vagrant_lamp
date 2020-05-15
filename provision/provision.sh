#!/bin/sh

# You should consider 'ansible' or 'chef'.

#echo -------------------------------------------------
#echo            SELinux (For test machine)
#echo -------------------------------------------------

setenforce 0
cp -p /etc/selinux/config /etc/selinux/config.org
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#echo -------------------------------------------------
#echo           Firewall (For test machine)
#echo -------------------------------------------------

systemctl stop firewalld

#echo -------------------------------------------------
#echo                    Local
#echo -------------------------------------------------

localectl set-locale LANG=ja_JP.utf8
export LC_ALL=C

#echo -------------------------------------------------
#echo                   Timezone
#echo -------------------------------------------------

timedatectl set-timezone Asia/Tokyo

#echo -------------------------------------------------
#echo                    Chrony
#echo -------------------------------------------------

cp -p /etc/chrony.conf /etc/chrony.conf.org
sed -i -e 's/pool 2.centos.pool.ntp.org iburst/#pool 2.centos.pool.ntp.org iburst\nserver ntp1.jst.mfeed.ad.jp iburst\nserver ntp2.jst.mfeed.ad.jp iburst\nserver ntp3.jst.mfeed.ad.jp iburst/g' /etc/chrony.conf
systemctl restart chronyd
chronyc sourcestats

#echo -------------------------------------------------
#echo                    Package
#echo -------------------------------------------------

#dnf -y update
dnf -y install epel-release
dnf -y install http://rpms.famillecollet.com/enterprise/remi-release-8.rpm

#echo -------------------------------------------------
#echo                    PHP(7.4)
#echo -------------------------------------------------

dnf module install -y php:remi-7.4

# Maybe installed httpd
dnf -y install php php-mbstring php-xml php-xmlrpc php-gd php-pdo php-json php-pecl-mcrypt
php -v

cp -p /etc/php.ini /etc/php.ini.org
cp /vagrant/php.ini /etc/php.ini

#echo -------------------------------------------------
#echo                   MySQL(8.0)
#echo -------------------------------------------------

dnf -y install php-mysqlnd php-pecl-mysql mysql-server
systemctl enable mysqld

#echo -------------------------------------------------
#echo                     Apache
#echo -------------------------------------------------

systemctl enable httpd
systemctl enable php-fpm
cp /vagrant/index.php /var/www/html/index.php
chown vagrant. /var/www/html/

#echo -------------------------------------------------
#echo                phpMyAdmin(v4.9.5)
#echo -------------------------------------------------

#dnf -y install wget unzip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.zip
#unzip phpMyAdmin-4.9.5-all-languages.zip
#mv phpMyAdmin-4.9.5-all-languages /var/www/html/myadmin
#rm -rf phpMyAdmin-4.9.5-all-languages.zip

#cp -p /var/www/html/myadmin/config.sample.inc.php /var/www/html/myadmin/config.inc.php
#sed -i -e "s/\['AllowNoPassword'\] = false;/\['AllowNoPassword'\] = true;/g" /var/www/html/myadmin/config.inc.php

#echo -------------------------------------------------
#echo                    SSL/TLS
#echo -------------------------------------------------

dnf -y install openssl mod_ssl
#openssl genrsa 2048 > /etc/pki/tls/apachessl.key
#openssl req -new -key /etc/pki/tls/apachessl.key > /etc/pki/tls/apachessl.csr
#openssl x509 -req -days 3650 -signkey /etc/pki/tls/apachessl.key < /etc/pki/tls/apachessl.csr > /etc/pki/tls/apachessl.crt
cp -p /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.org
#sed -i -e 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/apachessl.crt/g' /etc/httpd/conf.d/ssl.conf
#sed -i -e 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/apachessl.key/g' /etc/httpd/conf.d/ssl.conf

systemctl start httpd
systemctl start php-fpm
systemctl start mysqld
