#!/bin/bash

#funções uteis
function getEnv(){
    eval "$(
    cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
        key=$(echo "$line" | cut -d '=' -f 1)
        value=$(echo "$line" | cut -d '=' -f 2-)
        echo "export $key=\"$value\""
    done
    )"
}

getEnv

function user_docker(){
    if id -nG "$USER" | grep -qw "docker"; then
        echo $USER belongs to docker group
    else
        sudo usermod -aG docker ${USER}
        echo $USER has added to the docker group
    fi
}

function enter(){
    docker exec -it $@ bash
}

function app(){
    if [ $1 == "enter" ]; then
        enter $APP_NAME-app
    else
        docker-compose run app $@
    fi
}

function app_reset(){
    permissions_update
    remove_app
    new_app
}

function db(){
    if [ $1 == "restore" ]; then
        echo 'iniciando restauração de '$APP_NAME'_development...'
        docker container exec $APP_NAME'_db' psql -d $APP_NAME'_development' -f '/home/db_restore/'$2 -U postgres
        echo $APP_NAME'_development restaurado com sucesso'
    else
        docker-compose run postgres $@
    fi 
}


atualiza_nome_app(){
   sudo sed -i "1cAPP_NAME="$1 .env
}

function permissions_update(){
    sudo chown -R $USER:$USER start.sh
}

function prune(){
    docker system prune -a -f
}

function destroy_project(){
    remove_app
    docker-compose down
    prune
}

function restart(){
    docker-compose down
    prune
    source start.sh
}

function se_existe(){
    file=$1
    if [ -f "$file" ] || [ -d "$file" ]
    then
        $2
    fi
}

function Welcome(){
    echo funções carregadas!
}

Welcome
