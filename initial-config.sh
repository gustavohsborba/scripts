#!/bin/bash

# Variáveis do script
WIDGET_WIDTH=60
WIDGET_HEIGHT=10
STR_BACKTITLE="Escritório de Projetos - CEFET-MG"
CURRENT_DIR="$(pwd)"

test_cancel()
{
    # Se o usuário pressionar Cancelar ou ESC então encerra
    if [ $? -ne 0 ]; then
        return
    fi
}

gui_about()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --msgbox "Será iniciado o processo de configuração inicial do pacote de desenvolvimento." \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
    test_cancel
}

gui_make_shortcuts()
{
    MAKE_ECLIPSE_SHORTCUT=0
    MAKE_IREPORT_SHORTCUT=0

    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Configurações" \
            --checklist "Atalhos no desktop:" \
            0 $WIDGET_WIDTH 0 \
            "1" "Criar atalho para o Eclipse" on \
            "2" "Criar atalho para iReport" on \
    )
    test_cancel

    if ( echo "$DIALOG_RETURN" | grep "1" >/dev/null ); then MAKE_ECLIPSE_SHORTCUT=1; fi
    if ( echo "$DIALOG_RETURN" | grep "2" >/dev/null ); then MAKE_IREPORT_SHORTCUT=1; fi
}

gui_other_configs()
{
    SET_BASHRC=0

    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Configurações" \
            --checklist "Configurações adicionais:" \
            0 $WIDGET_WIDTH 0 \
            "1" "Atualizar Bash para melhor utilização GIT" off \
    )
    test_cancel

    if ( echo "$DIALOG_RETURN" | grep "1" >/dev/null ); then SET_BASHRC=1; fi
}

gui_git_clone()
{
    GIT_CLONE_SINAPSE=0
    GIT_CLONE_DOCUMENTATION=0
    GIT_CLONE_EXCHANGER=0

    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Configurações" \
            --checklist "Repositórios de desenvolvimento:" \
            0 $WIDGET_WIDTH 0 \
            "1" "Clonar repositório GIT do projeto Sinapse" on \
            "2" "Clonar repositório GIT de documentação" off \
            "3" "Clonar repositório GIT do projeto Exchanger" off \
    )
    test_cancel

    if ( echo "$DIALOG_RETURN" | grep "1" >/dev/null ); then GIT_CLONE_SINAPSE=1; fi
    if ( echo "$DIALOG_RETURN" | grep "2" >/dev/null ); then GIT_CLONE_DOCUMENTATION=1; fi
    if ( echo "$DIALOG_RETURN" | grep "3" >/dev/null ); then GIT_CLONE_EXCHANGER=1; fi
}

gui_wait_clone_process()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --infobox "Clonando repositórios. Aguarde..." \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
    test_cancel

    # Clona o repositório do projeto Sinapse
    if [ $GIT_CLONE_SINAPSE == 1 ]; then
        {
            mkdir -p "./git/sinapse/"
            git clone gitlab@gitlab.ep.sgi.cefetmg.br:sinapse/sinapse.git "./git/sinapse/"
            pushd $PWD
            popd
        } &> /dev/null
    fi

    # Clona o repositório do projeto Documentation
    if [ $GIT_CLONE_DOCUMENTATION == 1 ]; then
        {
            mkdir -p "./git/documentation/"
            git clone gitlab@gitlab.ep.sgi.cefetmg.br:sinapse/documentation.git "./git/documentation/"
            pushd $PWD
            popd
        } &> /dev/null
    fi

    # Clona o repositório do projeto Exchanger
    if [ $GIT_CLONE_EXCHANGER == 1 ]; then
        {
            mkdir -p "./git/exchanger/"
            git clone gitlab@gitlab.ep.sgi.cefetmg.br:sinapse/exchanger.git "./git/exchanger/"
            pushd $PWD
            popd
        } &> /dev/null
    fi
}

set_other_configs()
{
    if [ $SET_BASHRC == 1 ]; then
        {
            cp -f "./home/.bashrc" ~
            source "~/.bashrc"
        } &> /dev/null
    fi
}

gui_wait()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --infobox "Configurando o ambiente. Aguarde..." \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
    test_cancel
}

gui_success()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --msgbox "O ambiente foi configurado com sucesso e está pronto para ser utilizado." \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
    test_cancel
}

# Atualiza o diretório de instalação nos arquivos de configuração do Glassfish
update_glassfish_dir()
{
    find ./bin/glassfish/bin/ -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./bin/glassfish/updatecenter/bin/ -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./bin/glassfish/domains/domain1/bin/ -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./bin/glassfish/ -iname "*.conf" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./bin/glassfish/ -iname "*.xml" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
}

# Atualiza o diretório de instalação nos arquivos de configuração do workspace do Eclipse
update_eclipse_dir()
{
    find ./bin/eclipse/ -iname "*.prefs" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./bin/eclipse/ -iname "*.xml" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" ./bin/eclipse/eclipse.ini
}

# Atualiza o diretório de instalação nos arquivos de configuração do workspace do Eclipse
update_eclipse_workspace()
{
    find ./home/workspace/ -iname "*.prefs" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./home/workspace/ -iname "*.xml" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
    find ./home/workspace/ -iname "*.launch" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
}

# Atualiza o diretório de instalação nos arquivos de configuração do Maven
update_maven_dir()
{
    find ./bin/apache-maven-3.2.5/ -iname "*.xml" -type f -exec sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" {} \;
}

# Atualiza os arquivos de configuração do iReport
update_ireport_dir()
{
    sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" ./bin/ireport-4.0.1/etc/ireport.conf
}


update_developer()
{
    # Atualiza os scripts da raiz do pacote
    sed -i -e "s|$INSTALLED_DIR|$CURRENT_DIR|g" "utilities.sh"

    # Atualiza o arquivo de configuração com o diretório atual
    sed -i -e "s|[# ]*INSTALLED_DIR.*=.*|INSTALLED_DIR=\"$CURRENT_DIR\"|g" ./home/developer.conf
}


make_shortcuts()
{
    # Cria um atalho para o Eclipse
    if [ $MAKE_ECLIPSE_SHORTCUT == 1 ]; then
        cat << EOF > opt_eclipse_sinapse.desktop
[Desktop Entry]
Type=Application
Name=Eclipse (Sinapse)
Comment=Eclipse Integrated Development Environment
Icon=$CURRENT_DIR/bin/eclipse/icon.xpm
Exec=$CURRENT_DIR/bin/eclipse/eclipse
Terminal=false
Categories=Development;IDE;Java;
StartupWMClass=Eclipse
EOF
    fi


    # Cria um atalho para o iReport
    if [ $MAKE_IREPORT_SHORTCUT == 1 ]; then
        cat << EOF > opt_ireport_sinapse.desktop
[Desktop Entry]
Type=Application
Name=iReport (Sinapse)
Comment=iReport IDE
Icon=$CURRENT_DIR/bin/ireport-4.0.1/bin/document.ico
Exec=$CURRENT_DIR/bin/ireport-4.0.1/bin/ireport
Terminal=false
Categories=Development;IDE;
EOF
    fi

    # Define permissão de execução para os atalhos
    chmod +x *.desktop
    # Copia o atalho para o Desktop do usuário
    cp -f *.desktop "$XDG_DESKTOP_DIR" 2>/dev/null
}

gui_start_utilities()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --yesno "Deseja agora construir a aplicação do projeto Sinapse?" \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
    if [ $? -eq 0 ]; then
        "./utilities.sh"
    fi
    exit 0
}

########
# Main #
########

# Lê arquivos de configuração
source "./home/developer.conf"
source ~/.config/user-dirs.dirs

# Configura o arquivo pg_hba.conf
PGHBA_CONFIG="$(find "/etc/postgresql" -type f -iname "pg_hba.conf")"
sudo sed -i "s/peer$/md5/g" "$PGHBA_CONFIG"

# Reinicia o Postgresql
sudo service postgresql restart

# Verifica dependências
if ! dpkg -s libpostgresql-jdbc-java 2> /dev/null; then
    echo "Instalando dependência para o módulo do postgres..."
    sudo apt-get install -y libpostgresql-jdbc-java
fi

if ! dpkg -s dialog 2> /dev/null; then
    echo "Instalando dependência para o módulo do postgres..."
    sudo apt-get install -y dialog
fi

gui_about
gui_make_shortcuts
gui_git_clone
gui_other_configs
gui_wait_clone_process
gui_wait
update_glassfish_dir
update_eclipse_dir
update_eclipse_workspace
update_maven_dir
update_ireport_dir
update_developer
make_shortcuts
set_other_configs
gui_success
gui_start_utilities

clear
exit 0
