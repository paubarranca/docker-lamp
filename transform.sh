#!/bin/bash -e

init_bootstrap() {
	REPO_URL=https://github.com/paubarranca/init.git

	echo -e "Init not installed, bootstrapping...\n"
	cd /root/; git clone $REPO_URL; bash /root/init/bootstrap.sh
}

create_volumes() {
    NGINX_VOLUME=/srv/nginx/www
    TRAEFIK_VOLUME=/srv/traefik
    MYSQL_VOLUME=/srv/mysql/data

    mkdir -p $NGINX_VOLUME $TRAEFIK_VOLUME $MYSQL_VOLUME
}

pre_transform_actions() {
    if [ -e $COMPOSE_FILE ]; then
        COMPOSE_FILE=/root/init/docker-compose.yml
        TMP_COMPOSE_FILE=/tmp/docker-compose-pre-transform.yml

        read -p "\n$COMPOSE_FILE already exists, do you want to overwrite it? (y/n) " RESPONSE
        if [ $RESPONSE == "y" ]; then
            cp -a $COMPOSE_FILE $TMP_COMPOSE_FILE
            echo -e "\n$COMPOSE_FILE moved to $TMP_COMPOSE_FILE"
        else
            echo -e "\n$COMPOSE_FILE not changed"
        fi
    fi
}

cleanup() {
    declare -a files=("README.md" "transform.sh")
    declare -a folders=("jinja2")

    for i in "${files[@]}"
    do
        if [ -e $i ]; then
            rm -f $i
        fi
    done

    for x in "${folders[@]}"
    do
        if [ -d $x ]; then
            rm -rf $x
        fi
    done
}

# Main
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Check bootstrap
if [ ! -f /root/init/init.sh ]; then
    init_bootstrap
fi

# Required packages
apt install -qy git python3-pip wget pwgen && pip3 install j2cli setuptools

export DOMAIN_NAME=${DOMAIN_NAME:not_set}
export DOMAIN_USER=$(echo "$DOMAIN_NAME" | sed -r 's/[.]+/-/g')
export MYSQL_ROOT_PASSWORD=$(pwgen -1s 30)
export MYSQL_USER_PASSWORD=$(pwgen -1s 30)

pre_transform_actions; create_volumes

j2 jinja2/docker-compose-yml.j2 > /root/init/docker-compose.yml; /root/init/init.sh; cleanup