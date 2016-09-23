#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

echo "Tutoriais:"
echo "http://www.tecmint.com/setup-postfix-mail-server-in-ubuntu-debian/" # tutorial 1
echo "https://www.digitalocean.com/community/tutorials/how-to-install-and-setup-postfix-on-ubuntu-14-04" # Tutorial 2
echo "https://paulschreiber.com/blog/2008/08/01/how-to-create-a-self-signed-ssl-certificate-for-dovecot-on-debian/" # Tutorial 3
read -n 1 -s

# hostname: rede1.cefetmg.br
# username: gustavo


apt-get install -y postfix
read -p "Press any key to continue... " -n1 -s
nano /etc/postfix/main.cf # Verificar no tutorial 2 o que deve ser feito aqui
read -p "Press any key to continue... " -n1 -s
service postfix restart


apt-get install -y mailutils #mailx - Para criar um e-mail na caixa de e-mails do usuário
apt-get install -y openssl # para auto-assinar o certificado SSL 

apt-get install -y dovecot-core
apt-get install -y dovecot-imapd
read -p "Press any key to continue... " -n1 -s
apt-get install -y dovecot-pop3d
read -p "Press any key to continue... " -n1 -s

# Caso a auto-assinatura do certificado não funcione:
#openssl req -new -x509 -days 1000 -nodes -out "/etc/ssl/certs/dovecot.pem" -keyout "/etc/ssl/private/dovecot.pem"
#openssl req -new -x509 -days 1000 -nodes -out "/etc/ssl/certs/dovecot.pem" -keyout "/etc/ssl/private/dovecot.pem"
#find /etc/ssl -name dovecot.* -exec rm {} \;
#find /etc/ssl -name dovecot.* -exec rm {} \;
#dpkg-reconfigure dovecot-core
#dpkg-reconfigure dovecot-imapd 
#dpkg-reconfigure dovecot-pop3d 

apt-get install -y php5 php5-mcrypt
#apt-get install -y php5.6 php5.6-mcrypt 
apt-get install -y mysql-server
#apt-get install -y mysql-server-5.7 
read -p "Press any key to continue... " -n1 -s
apt-get install -y squirrelmail
read -p "Press any key to continue... " -n1 -s
squirrelmail-configure # Seguir no tutorial 1 
read -p "Press any key to continue... " -n1 -s

cp /etc/squirrelmail/apache.conf /etc/apache2/sites-available/squirrelmail.conf
a2ensite squirrelmail.conf
service apache2 restart
service dovecot restart
service postfix restart

# Adicionando um usuário:
read -p "Press any key to add test user... " -n1 -s
useradd testeemail
passwd testeemail
mkdir -p /var/www/html/testeemail
usermod -m -d /var/www/html/testeemail testeemail
chown -R testeemail:testeemail /var/www/html/testeemail
adduser testeemail mail

read -p "Press any key to send first mail to user... " -n1 -s
mailx testeemail@rede1.cefetmg.br

