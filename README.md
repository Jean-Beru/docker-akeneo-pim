# Akeneo PIM
Docker image for Akeneo PIM projects.


## Run

### With docker
```
docker run --rm -d --name pim -v /YOUR_PIM_PROJECT_FOLDER:/var/www/html -p 80:80 jeanberu/akeneo-pim
```

### With docker-compose

Assuming you have this `docker-compose.yml` file in your project root folder :
```
# docker-compose.yml
app:
  image: jeanberu/akeneo-pim
  container_name: akeneo_pim
  links:
    - mysql:mysql
    - mongo:mongo
  volumes:
    - .:/var/www/html

mysql:
  image: mysql:latest
  container_name: akeneo_pim_mysql
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: akeneo_pim
    MYSQL_USER: akeneo_pim
    MYSQL_PASSWORD: akeneo_pim

mongo:
  image: mongo:2.4
  container_name: akeneo_pim_mongo
```

Run from your project root folder :
```
# Run server
docker-compose up -d
```


## Install dependencies

### With docker
```
docker exec pim composer install --optimize-autoloader --prefer-dist
docker exec pim php app/console pim:install --env=prod
```

### With docker-compose
```
docker-compose exec app composer install --optimize-autoloader --prefer-dist
docker-compose exec app php app/console pim:install --env=prod
```
