# Docker for OMS

## Installation

#### Requirements

* [MySQL](https://dev.mysql.com/downloads/installer/)
* [Docker](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

#### Prepare OMS source

- Import MySQL data for `OMS` data.
- `git clone git@github.com:zalora/oms.git ~/oms`. If you are using MacOSx, it should be in your home folder.

#### Build docker images

> $ `cd ~/oms/docker`

> $ `make build`

#### Configuration
Update `config/build.ini` with respective values for DB configuration. By default, it will be using VN configuration. You can also change venture environment in `docker/config/dev.ini_`

#### Start docker containers
> $ `make run`

### Run migrations
> $ `make migrate`

#### Start the web app
- Go to **_http://localhost:8080/_**


## Docker build for PHP 7.4

### Init docker

1. Download package jdk-12.0.2 ([oracle](https://www.oracle.com/sg/java/technologies/javase/jdk12-archive-downloads.html) | [zalora-slack](https://zalora.slack.com/archives/G01KR0B235Z/p1611652054032500?thread_ts=1611634960.028800&cid=G01KR0B235Z)) and extract to following path `<project-path>/docker/fpm/extensions`

2. Prepare local database (optional)

    Create mysql5.7 local container name `oms_db` with root password is `123456`
    ```
    $ docker run -tid -p 3306:3306 --env MYSQL_ROOT_PASSWORD=123456 --name oms_db mysql:5.7 
    ```

    Create database `oms` on `oms_db` container
    ```
    $ docker exec -it oms_db bash -c "mysql -u root -p123456 -e 'CREATE DATABASE oms DEFAULT CHARACTER SET utf8'" 
    ```

    Retreive `oms_db` host address (ex: 172.17.0.7)
    ```
    $ docker inspect -f '{{ .NetworkSettings.IPAddress }}' oms_db 
    ```

    later on the next process (step [7] Prepare developement configuration) input `Database connection` as follow

    > Database connection
    > - host: <#oms_db host address>
    > - name: oms
    > - user: root
    > - password: 123456

3. Build images

    **Note**: _By running this command all your previous containers will be deleted_

    ```
    # From your project directory, change dir to `<project-path>/docker`
    $ cd ./docker  

    # Run command and follow it's instruction
    $ ./dkcli init
    ```

### Start docker
```
$ ./dkcli start
```

### Run migration
```
$ ./dkcli migrate
```

## Configuration

For development config file locates at `<project-path>/oms/application/config/dev.ini`

Databse connection:
```
; OMS DB configuration
resources.multidb.oms.adapter = "PDO_MYSQL"
resources.multidb.oms.name = 'oms'
resources.multidb.oms.default = true

resources.multidb.oms.host = "<mysql_host>"
resources.multidb.oms.dbname = "<databse_name>"
resources.multidb.oms.username = "<username>"
resources.multidb.oms.password = "<password>"
resources.multidb.oms.charset = "UTF8"
```

Password salt
```
password_salt = "<secret-string>"
```
