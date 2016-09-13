#!/bin/bash

# Variáveis do script
WIDGET_WIDTH=60
WIDGET_HEIGHT=10
STR_BACKTITLE="Escritório de Projetos - CEFET-MG"

gui_main()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Projeto Sinapse" \
            --radiolist "Selecione uma das opções abaixo:" \
            0 $WIDGET_WIDTH 0 \
            1 "Construir projeto" on \
            2 "Alterar branch" off \
            3 "Alterar banco" off \
            4 "Sair" off \
        )
    if [ $? -ne 0 ]; then
        exit 0
    fi
}

gui_build()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Projeto Sinapse" \
            --radiolist "Construir projeto:" \
            0 $WIDGET_WIDTH 0 \
            1 "Construir, publicar e iniciar servidor" on \
            2 "Apenas construir" off \
            3 "Apenas publicar" off \
            4 "Apenas iniciar servidor" off \
            5 "Apenas parar servidor" off \
            6 "Reiniciar o servidor" off \
            7 "Limpar tudo" off \
        )
    if [ $? -ne 0 ]; then
        return
    fi

    clear
    if [ "$DIALOG_RETURN" == "1" ]; then
        developer_clean
        developer_maven_build
        developer_maven_deploy
        developer_open_browser
    elif [ "$DIALOG_RETURN" == "2" ]; then
        developer_maven_build
    elif [ "$DIALOG_RETURN" == "3" ]; then
        developer_maven_deploy
        developer_open_browser
    elif [ "$DIALOG_RETURN" == "4" ]; then
        developer_glassfish_start
    elif [ "$DIALOG_RETURN" == "5" ]; then
        developer_glassfish_stop
    elif [ "$DIALOG_RETURN" == "6" ]; then
        developer_glassfish_stop
        developer_glassfish_start
    elif [ "$DIALOG_RETURN" == "7" ]; then
        developer_clean
    fi
    read -p "Press [Enter] para retornar ao menu..."
}

gui_git_chechout()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Projeto Sinapse" \
            --radiolist "Alterar branch (ou nenhum para manter):" \
            0 $WIDGET_WIDTH 0 \
            $(git br -a | grep "remotes/origin/" | grep -v "HEAD" | grep -v "master" | sed "s/.*origin\///g" | sed "s/$/ - off /g")
        )
    if [ $? -ne 0 ]; then
        return
    fi

    gui_wait_chechout
    {
        git checkout $DIALOG_RETURN
        git pull --all --tags --prune
        popd
    } &> /dev/null
}

gui_wait_chechout()
{
    DIALOG_INPUT_OPTIONS=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --infobox "Trocando de ramo no repositório. Aguarde..." \
            $WIDGET_HEIGHT $WIDGET_WIDTH \
    )
}

gui_set_database()
{
    DIALOG_RETURN=$(
        dialog \
            --stdout \
            --backtitle "$STR_BACKTITLE" \
            --title "Projeto Sinapse" \
            --radiolist "Alterar banco:" \
            0 $WIDGET_WIDTH 0 \
            1 "Local" on \
            2 "Homologação" off \
        )
    if [ $? -ne 0 ]; then
        return
    fi

    if [ "$DIALOG_RETURN" == "1" ]; then
        cp -f "/home/gustavo/workspace/developer-sinapse/home/domain_local.xml" "/home/gustavo/workspace/developer-sinapse/bin/glassfish/domains/domain1/config/domain.xml"
        cp -f "/home/gustavo/workspace/developer-sinapse/home/domain_local.xml" "/home/gustavo/workspace/developer-sinapse/bin/glassfish/domains_backup/domain1/config/domain.xml"
    elif [ "$DIALOG_RETURN" == "2" ]; then
        cp -f "/home/gustavo/workspace/developer-sinapse/home/domain_homolog.xml" "/home/gustavo/workspace/developer-sinapse/bin/glassfish/domains/domain1/config/domain.xml"
        cp -f "/home/gustavo/workspace/developer-sinapse/home/domain_homolog.xml" "/home/gustavo/workspace/developer-sinapse/bin/glassfish/domains_backup/domain1/config/domain.xml"
    fi
}

developer_clean()
{
    echo "Limpando o ambiente de desenvolvimento..."

    # Mata o processo do Glassfish
    echo "Encerrando o Glassfish..."
    kill -9 $(lsof -i:8080 | tail -n -1 | sed 's/  */ /g' | cut -f 2 -d ' ') 2>/dev/null

    # Restaura os dominios do Glassfish
    echo "Restaurando o dominio inicial do Glassfish..."
    rm -rf /home/gustavo/workspace/developer-sinapse/bin/glassfish/domains
    cp -R /home/gustavo/workspace/developer-sinapse/bin/glassfish/domains_backup /home/gustavo/workspace/developer-sinapse/bin/glassfish/domains

    # Limpa Workspace do Eclipse
    echo "Limpando o Workspace do Eclipse..."
    rm -rf "/home/gustavo/workspace/developer-sinapse/home/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp"*
    rm -rf "/home/gustavo/workspace/developer-sinapse/home/workspace/.metadata/.plugins/org.eclipse.wst.server.core/publish/"*

    # Limpa o Build anterior
    echo "Limpando Build anterior..."
    rm -rf "/home/gustavo/workspace/developer-sinapse/git/sinapse/sinapse-core/build" 2>/dev/null
    rm -rf "/home/gustavo/workspace/developer-sinapse/git/sinapse/sinapse-core/target" 2>/dev/null
    rm -rf "/home/gustavo/workspace/developer-sinapse/git/sinapse/sinapse-ear/target" 2>/dev/null
    rm -rf "/home/gustavo/workspace/developer-sinapse/git/sinapse/sinapse-web/build" 2>/dev/null
    rm -rf "/home/gustavo/workspace/developer-sinapse/git/sinapse/sinapse-web/target" 2>/dev/null

    # Limpa Cache do repositório do Maven
    echo "Limpando cache do Maven..."
    rm -rf "/home/gustavo/workspace/developer-sinapse/home/.m2/repository/br" 2>/dev/null
    rm -rf "/home/gustavo/workspace/developer-sinapse/home/.m2/repository/.cache" 2>/dev/null

    echo "Ambiente limpado com sucesso!"
}

developer_glassfish_start()
{
    echo "Iniciando o servidor Glassfish..."
    /home/gustavo/workspace/developer-sinapse/bin/glassfish/bin/asadmin start-domain domain1
}

developer_glassfish_stop()
{
    echo "Parando o servidor Glassfish..."
    /home/gustavo/workspace/developer-sinapse/bin/glassfish/bin/asadmin stop-domain domain1
}

developer_maven_build()
{
    # Efetua uma limpeza no pacote
    developer_clean

    # Efetua o build pelo Maven
    echo "Construindo projeto..."
    pushd $PWD
    cd /home/gustavo/workspace/developer-sinapse/git/sinapse
    /home/gustavo/workspace/developer-sinapse/bin/apache-maven-3.2.5/bin/mvn validate compile install -o
    popd
}

developer_maven_deploy()
{
    # Realiza o Deploy pelo Maven
    echo "Publicando projeto..."
    pushd $PWD
    cd /home/gustavo/workspace/developer-sinapse/git/sinapse
    /home/gustavo/workspace/developer-sinapse/bin/apache-maven-3.2.5/bin/mvn org.glassfish.maven.plugin:maven-glassfish-plugin:deploy -pl sinapse-ear -o
    popd
}

developer_open_browser()
{
    echo "Abrindo navegador Firefox..."
    {
        firefox -new-tab "http://localhost:8080/sinapse-web/" &
    } &> /dev/null
}

########
# Main #
########

export JAVA_HOME=/home/gustavo/workspace/developer-sinapse/bin/java-6-oracle/jre

while true; do
    gui_main
    if [ "$DIALOG_RETURN" == "1" ]; then
        gui_build
    elif [ "$DIALOG_RETURN" == "2" ]; then
        {
            pushd $PWD
            cd "./git/sinapse/"
            git pull --all --tags --prune
        } &> /dev/null
        gui_git_chechout
    elif [ "$DIALOG_RETURN" == "3" ]; then
        gui_set_database
    elif [ "$DIALOG_RETURN" == "4" ]; then
        clear
        exit 0
    fi
done
