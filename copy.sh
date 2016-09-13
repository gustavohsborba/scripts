#		Copiando o ambiente:

#cp -R Developer /home/gustavo/
#cp -R Documents /home/gustavo/
#cp -R Downloads /home/gustavo/
#cp -R Music /home/gustavo/
#cp -R Pictures /home/gustavo/
#mkdir /home/gustavo/opt
#cp -R /opt/* /home/gustavo/opt
##cp -R Pictures /home/gustavo/
cp -R .CLion12 /home/gustavo/
cp -R .netbeans /home/gustavo/
cp -R .TelegramDesktop /home/gustavo/
cp -R .IntelliJIdea15 /home/gustavo/
cp -R .pgadmin3 /home/gustavo/

cd /home/gustavo
chmod 777 -R Documents
chmod 777 -R Downloads
chmod 777 -R Music
chmod 777 -R Pictures
chmod 777 -R .CLion12
chmod 777 -R .netbeans
chmod 777 -R .TelegramDesktop
chmod 777 -R .IntelliJIdea15
chmod 777 -R .pgadmin3
chmod 777 -R *


#		Adicionando PPAs:
add-apt-repository ppa:xorg-edgers/ppa
add-apt-repository -y ppa:webupd8team/java
add-apt-repository ppa:mpstark/elementary-tweaks-daily
add-apt-repository ppa:yunnxx/elementary
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get update


#		Programas utilizados para Desenvolvimento:
apt-get install -y pgadmin3
apt-get install -y git git-base git-flow
apt-get install -y postgresql
apt-get install -y orcale-java7-installer
apt-get install gedit gedit-plugins


# 		Melhorando a aparência do Elementary
apt-get install ubuntu-restricted-extras 
apt-get install dconf-editor
apt-get install elementary-tweaks

# Ícones, wallpapers e temas:
apt-get install elementary-transparent-theme
apt-get install ubuntu-wallpapers-karmic ubuntu-wallpapers-lucid ubuntu-wallpapers-maverick ubuntu-wallpapers-natty ubuntu-wallpapers-oneiric ubuntu-wallpapers-precise ubuntu-wallpapers-quantal ubuntu-wallpapers-raring ubuntu-wallpapers-saucy ubuntu-wallpapers-trusty 
apt-get install elementary-dark-theme elementary-plastico-theme elementary-whit-e-theme elementary-harvey-theme elementary-blue-theme elementary-colors-theme elementary-lion-theme elementary-champagne-theme elementary-milk-theme elementary-emod-icons elementary-elfaenza-icons elementary-nitrux-icons elementary-enumix-utouch-icons elementary-plank-themes faba-icon-theme moka-icon-theme faba-mono-icons
apt-get install super-wingpanel
apt-get install conky-manager


#		Programas úteis:
apt-get install texlive-full
apt-get install -y google-chrome-stable
apt-get install firefox vlc libreoffice gimp transmission rar unrar
apt-get install adobe-flashplugin
apt-get install ubuntu-restricted-extras libavcodec-extra-53
apt-get install icedtea-plugin

software-properties-gtk


wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py



echo "Acesse: http://meetfranz.com/"
#apt-get update
#apt-get upgrade
#apt-get dist-upgrade
#apt-get autoremove








