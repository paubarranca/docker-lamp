# docker-lamp-stack

```sh
git clone https://github.com/paubarranca/docker-lamp-stack.git
```

Export this constant for the root user:
```sh
export DOMAIN_NAME=yourdomain.com
export CREATE_REDIS=true|false
```

Exec the script as root:
```sh
./transform.sh
```

It will deploy the entire stack with random passwords and the labels set in the *DOMAIN_NAME* constant in the docker-compose