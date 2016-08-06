#!/bin/bash

. env.conf

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGE_MANAGER="apt-get"

do_install() {
    printf "Installing... "
    crontab crontab
    sh -c "$PACKAGE_MANAGER -y update"
    sh -c "$PACKAGE_MANAGER -y install git"
    sh -c "$PACKAGE_MANAGER -y install make"
    if [ -n "$(python -mplatform | grep -i Ubuntu)" ]; then
        # Ubuntu
        apt-get -y update
        apt-get -y install apt-transport-https ca-certificates
        apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        # Only for 14.04 (change for any other ubuntu version):
        if [ -n "$(python -mplatform | grep -i 14.04)" ]; then
            echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
        elif [ -n "$(python -mplatform | grep -i 16.04)" ]; then
            echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
        else
            echo "Unsupported ubuntu version." >&2
            exit 1;
        fi
        apt-get -y update
        apt-get -y purge lxc-docker
        apt-cache policy docker-engine
        apt-get install -y linux-image-extra-$(uname -r)
        apt-get install -y --force-yes docker-engine
        service docker start
        docker run hello-world
    else
        echo "Unsupported OS." >&2
        exit 1;
    fi
    git submodule update --init
    printf "Installed\n"
}

do_start() {
    echo "Starting..."

    # Folders:
    mkdir -p $DIR/logs

    # Start components:
    make build run
    echo "Started"
}

get_date() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

do_stop() {
    echo "Stopping... "
    make stop LOG="$DIR/logs/$SERVER_NAME-$(get_date).log"
    echo "Stopped"
}

do_clean() {
    echo "Cleaning... "
    make clean
    echo "Clean"
}

do_gen_cert() {
    cd $DIR/letsencrypt
    if ./letsencrypt-auto certonly --standalone -d $SERVER_FQDN ; then
        mkdir -p $DIR/certs
        rm $DIR/certs/*
        cp /etc/letsencrypt/live/$SERVER_FQDN/fullchain.pem $DIR/certs/cert.pem
        cp /etc/letsencrypt/live/$SERVER_FQDN/privkey.pem $DIR/certs/privkey.pem
    else
        mkdir -p $DIR/certs
        rm $DIR/certs/*
        openssl req -x509 -newkey rsa:2048 -keyout $DIR/certs/privkey.pem -out $DIR/certs/cert.pem -days 365 -nodes
    fi
    cd $DIR
}

case "$1" in
    install)
        do_install;
        ;;
    start)
        do_start;
        ;;
    restart|reload|force-reload)
        do_stop;
        do_start;
        ;;
    stop)
        do_stop;
        ;;
    clean)
        do_clean;
        ;;
    generate-cert)
        do_gen_cert;
        ;;
    *)
        echo "Usage: $0 start|stop|install|clean|generate-cert" >&2
        exit 3
        ;;
esac
