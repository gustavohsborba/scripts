#!/bin/bash
# Adds a user client to e-mail server

if (( $EUID != 0 )); then
    echo "Esse script deve ser rodado apenas pelo root."
    exit
fi

if [[ $# -lt 1 ]]; then
    read -p "Insira o nome de usuário: " username
else
    username=$username
fi


if [[ $(useradd $username) ]]; then
    echo "Cliente $username@rede2.cefetmg.br Já existente"
    echo "Encerrando programa..."
    exit
fi

read -p "Insira a senha: " senha1
read -p "Insira a senha novamente: " senha2
while [[ $senha1 -ne $senha2 ]]; do
    echo "Senhas não compatíveis! Reinsira!"
    read -p "Insira a senha: " senha1
    read -p "Insira a senha novamente: " senha2
done 

echo -e "$senha1\n$senha2" | (passwd $username)
adduser $username mail

# Configura o usuário para ter acesso à interface Squirrelmail:
mkdir -p /var/www/html/$username
usermod -m -d /var/www/html/$username $username 
usermod -m -d /var/www/html/$username $username
chown -R $username:$username /var/www/html/$username
