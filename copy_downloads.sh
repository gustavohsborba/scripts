#		Copiando o ambiente:

#cp -R /home/desenv/Developer /home/gustavo/
#cp -R /home/desenv/Documents /home/gustavo/
#cp -R /home/desenv/Downloads /home/gustavo/
#cp -R /home/desenv/Music /home/gustavo/
#cp -R /home/desenv/Pictures /home/gustavo/
#mkdir /home/gustavo/opt
#cp -R /opt/* /home/gustavo/opt
#cp -R /home/desenv/Pictures /home/gustavo/
#cp -R /home/desenv/.CLion12 /home/gustavo/
#cp -R /home/desenv/.netbeans /home/gustavo/
#cp -R /home/desenv/.TelegramDesktop /home/gustavo/
#cp -R /home/desenv/.IntelliJIdea15 /home/gustavo/
#cp -R /home/desenv/.pgadmin3 /home/gustavo/

#cd /home/gustavo
#chmod 777 -R Documents
#chmod 777 -R Downloads
#chmod 777 -R Music
#chmod 777 -R Pictures
#chmod 777 -R .CLion12
#chmod 777 -R .netbeans
#chmod 777 -R .TelegramDesktop
#chmod 777 -R .IntelliJIdea15
#chmod 777 -R .pgadmin3
#chmod 777 -R *


#		Adicionando PPAs:
add-apt-repository -y ppa:xorg-edgers/ppa
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:mpstark/elementary-tweaks-daily
add-apt-repository -y ppa:yunnxx/elementary
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get update


#		Programas utilizados para Desenvolvimento:
apt-get install -y pgadmin3
apt-get install -y git git-base git-flow
apt-get install -y postgresql
apt-get install -y oracle-java7-installer
apt-get install -y gedit gedit-plugins


# 		Melhorando a aparência do Elementary
apt-get install -y ubuntu-restricted-extras 
apt-get install -y dconf-editor
apt-get install -y elementary-tweaks
apt-get install -y indicator-sound


# Ícones, wallpapers e temas:
apt-get install -y elementary-transparent-theme
apt-get install -y ubuntu-wallpapers-karmic ubuntu-wallpapers-lucid ubuntu-wallpapers-maverick ubuntu-wallpapers-natty ubuntu-wallpapers-oneiric ubuntu-wallpapers-precise ubuntu-wallpapers-quantal ubuntu-wallpapers-raring ubuntu-wallpapers-saucy ubuntu-wallpapers-trusty 
apt-get install -y elementary-dark-theme elementary-plastico-theme elementary-whit-e-theme elementary-harvey-theme elementary-blue-theme elementary-colors-theme elementary-lion-theme elementary-champagne-theme elementary-milk-theme elementary-emod-icons elementary-elfaenza-icons elementary-nitrux-icons elementary-enumix-utouch-icons elementary-plank-themes faba-icon-theme moka-icon-theme faba-mono-icons
apt-get install -y super-wingpanel
apt-get install -y conky-manager

#		Programas úteis:
apt-get install -y google-chrome-stable
apt-get install -y firefox vlc libreoffice gimp transmission rar unrar
apt-get install -y adobe-flashplugin
apt-get install -y ubuntu-restricted-extras libavcodec-extra-53
apt-get install -y icedtea-plugin
apt-get install -y texlive-full

software-properties-gtk
apt-get update
apt-get upgrade
apt-get dist-upgrade
#apt-get autoremove
