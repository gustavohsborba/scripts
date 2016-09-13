#!/bin/bash
set -e

pushd $PWD
source "./home/bolsistas-django-env/bin/activate"
cd "./git/apoio-selecao-bolsistas"
python3 manage.py runserver
popd
