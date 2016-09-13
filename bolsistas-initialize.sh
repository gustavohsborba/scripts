#!/bin/bash

#para colorir o bash:
RED='\e[31m'
NC='\e[00;39m' 
GREEN='\e[32m' #no color
BOLD='\e[01;39m'


# -----------------------------------------------------------------------------------------------------------

DEPENDENCIAS=(libpq-dev # Modulo do Postgres
                rabbitmq-server # Gerenciador de Filas RabbitMQ
                unixodbc # Conexão com acadêmico
                freetds-dev # Conexão com acadêmico
                tdsodbc # Conexão com acadêmico
                python3-dev # biblioteca pyodbc
                unixodbc-dev # para pyodbc             
               )


echo -e "$BOLD Verificando dependências...$NC"
for dependencia in ${DEPENDENCIAS[*]}; do
    if ! dpkg -s $dependencia > /dev/null; then
        echo -e "\t* $RED ${dependencia} $BOLD Instalando dependência: $NC" 
        sudo apt-get install -y $dependencia
    else
        echo -e "\t"* ${dependencia}" "$GREEN" OK "$NC;
    fi
done


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Removendo diretórios existentes...$NC"
rm -rf "./git/apoio-selecao-bolsistas/"
rm -rf "./home/bolsistas-django-env"

# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Removendo base de dados existente...$NC"
export PGPASSWORD="postgres"
PG_USER="postgres"
PG_HOST="127.0.0.1"
psql --username=$PG_USER --host=$PG_HOST --no-password --command="DROP DATABASE \"apoio-selecao-bolsistas\""


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Clonando o repositório do projeto apoio-selecao-bolsistas...$NC"
mkdir -p "./git/apoio-selecao-bolsistas/"
git clone gitlab@gitlab.ep.sgi.cefetmg.br:django/apoio-selecao-bolsistas.git "./git/apoio-selecao-bolsistas/"


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Criando o ambiente virtual...$NC"
virtualenv -p python3 "./home/bolsistas-django-env" --no-site-packages
source "./home/bolsistas-django-env/bin/activate"


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Instalando as dependências no python...$NC"
pip install -r "./git/apoio-selecao-bolsistas/requirements.txt"


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Criando o banco de dados, se não existir...$NC"
DB="apoio-selecao-bolsistas"
psql -U postgres -c "\l" | grep -w -q "$DB" || createdb -U postgres "$DB"


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Realizando as migrações...$NC"
python "./git/apoio-selecao-bolsistas/manage.py" migrate


# -----------------------------------------------------------------------------------------------------------

echo -e "$BOLD Criando a senha de admin... Favor responder as questões abaixo.$NC"
python "./git/apoio-selecao-bolsistas/manage.py" createsuperuser




