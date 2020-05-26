#!/usr/bin/env bash

export DEV_ENV_ROOT=$(dirname $(realpath ${BASH_SOURCE[0]}))

DOCKER_COMPOSE_FILENAME="docker-compose-dev.yml"
DOCKER_COMPOSE_FILE="${DEV_ENV_ROOT}/${DOCKER_COMPOSE_FILENAME}"
echo "DevEnv Root: ${DEV_ENV_ROOT}"
if [ ! -f "${DOCKER_COMPOSE_FILE}" ]; then
    echo "Root dir is not right"
    exit 2
fi
docker-compose --version
DB_FOLDERS=("memcached" "mysql" "redis")

function prepare_folders() {
    for folder in ${DB_FOLDERS[@]}; do
        data_path="$DEV_ENV_ROOT/$folder/data"
        if [ ! -d "$data_path" ]; then
            echo "making $data_path"
            mkdir -p "$data_path"
        fi
    done
}

function clean_folders() {
    for folder in ${DB_FOLDERS[@]}; do
        data_path="$DEV_ENV_ROOT/$folder/data"
        if [ -d "$data_path" ]; then
            echo "cleaning $data_path"
            sudo rm -rf $data_path
            echo $data_path
        fi
    done
}

function print_status() {
    echo "service status"
    docker-compose -f $DOCKER_COMPOSE_FILE ps
}

function up_devenv() {
    prepare_folders
    docker-compose -f $DOCKER_COMPOSE_FILE up -d
    print_status
}

function down_devenv() {
    docker-compose -f $DOCKER_COMPOSE_FILE down
    print_status
}

function start_devenv() {
    docker-compose -f $DOCKER_COMPOSE_FILE start
    print_status
}

function stop_devenv() {
    docker-compose -f $DOCKER_COMPOSE_FILE stop
    print_status
}

function print_help() {
    echo "devenv.sh [up | start | stop | clean | status | rerun]"
    echo "    -h          print help"
    echo "    up          create data folders and docker-compose up"
    echo "    start       docker-compose start"
    echo "    stop        docker-compose stop"
    echo "    status      docker-compose ps"
    echo "    clean       clean data folders"
    echo "    rerun       clean and up"
}

if [ $# -eq 1 ]; then
    ACTION=$1
    case $ACTION in
        -h|--help)
            print_help
            exit
            ;;
        u|up)
            up_devenv
            ;;
        s|start)
            start_devenv
            ;;
        p|stop)
            stop_devenv
            ;;
        t|status)
            print_status
            ;;
        c|clean)
            clean_folders
            ;;
        r|rerun)
            stop_devenv
            clean_folders
            up_devenv
            ;;
        *)
            printf "Unknows Option: $key \n"
            print_help
            exit
            ;;
    esac
else
    echo "Invalid arguments"
    print_help
fi
