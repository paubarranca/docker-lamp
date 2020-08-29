# docker-lamp-stack

```sh
export DOMAIN_NAME=yourdomain.com
export CREATE_REDIS=true|false
```

Exec the script with root permissions:
```sh
./transform.sh
```

It will deploy the entire stack with random passwords and the labels set in the *DOMAIN_NAME* constant in the docker-compose