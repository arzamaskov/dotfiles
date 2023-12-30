#!/usr/bin/env bash
set -euo pipefail

# Constants
DEVELOP_DIR="Develop"
ENVIRONMENT_DIR="$HOME/$DEVELOP_DIR/environment"
DATABASE_DUMP=""

function check_dependencies() {
    local dependencies=("docker" "docker-compose" "curl" "sed" "id" "mkcert")

    for dependency in "${dependencies[@]}"
    do
        type "$dependency" >/dev/null 2>&1 ||
        {
            echo "ERROR: Executable not found: $dependency."
            exit 1
        }
    done

    docker info >/dev/null 2>&1 || { echo "ERROR: Docker daemon is not running".; exit 1; }
}

function get_project_directory() {
    while true
    do
        read -p "Enter project name (should match project directory name): " choice

        if [[ -z "$choice" ]]
        then
            echo "Project name cannot be empty. Please try again."
        else
            PROJECT=$choice
            PROJECT_PATH="$HOME/$DEVELOP_DIR/$PROJECT"
            break
        fi

    done

    echo -e "\n"
}

function get_php_version() {
    echo "Step 1. Select PHP version"
    echo "The following PHP versions are available:"
    echo "1) PHP 5.6"
    echo "2) PHP 7.1"
    echo "3) PHP 7.3"
    echo "4) PHP 7.4"
    echo "5) PHP 8.0"
    echo "6) PHP 8.1"
    echo "7) PHP 8.2"
    echo "PHP 7.4 will be set as default if no choice is made."

    read -p "Select PHP version [1-7]: " choice

    case $choice in
        1)
            echo "You have selected PHP 5.6."
            PHP_VERSION="php56"
            ;;
        2)
            echo "You have selected PHP 7.1."
            PHP_VERSION="php71"
            ;;
        3)
            echo "You have selected PHP 7.3."
            PHP_VERSION="php73"
            ;;
        4)
            echo "You have selected PHP 7.4."
            PHP_VERSION="php74"
            ;;
        5)
            echo "You have selected PHP 8.0."
            PHP_VERSION="php8"
            ;;
        6)
            echo "You have selected PHP 8.1."
            PHP_VERSION="php81"
            ;;
        7)
            echo "You have selected PHP 8.2."
            PHP_VERSION="php82"
            ;;
        *)
            echo "Invalid choice, PHP 7.4 will be set as default."
            PHP_VERSION="php74"
            ;;
    esac

    echo -e "\n"
}

function get_mysql_version() {
    echo "Step 2. Select MySQL version"
    echo "The following versions are available:"
    echo "1) MySQL 5.6"
    echo "2) MySQL 5.7"
    echo "3) MySQL 8"
    echo "4) MariaDB 10.3"
    echo "5) MariaDB 10.4"
    echo "6) MariaDB 10.5"
    echo "7) MariaDB 10.6"
    echo "MariaDB 10.6 will be set as default if no choice is made."

    read -p "Select MySQL version [1-7]: " choice

    case $choice in
        1)
            echo "You have selected MySQL 5.6."
            MYSQL_VERSION="mysql56"
            ;;
        2)
            echo "You have selected MySQL 5.7."
            MYSQL_VERSION="mysql57"
            ;;
        3)
            echo "You have selected MySQL 8"
            MYSQL_VERSION="mysql8"
            ;;
        4)
            echo "You have selected MariaDB 10.3"
            MYSQL_VERSION="mariadb103"
            ;;
        5)
            echo "You have selected MariaDB 10.4"
            MYSQL_VERSION="mariadb104"
            ;;
        6)
            echo "You have selected MariaDB 10.5"
            MYSQL_VERSION="mariadb105"
            ;;
        7)
            echo "You have selected MariaDB 10.6"
            MYSQL_VERSION="mariadb106"
            ;;
        *)
            echo "Invalid choice, MariaDB 10.6 will be set as default."
            MYSQL_VERSION="mariadb106"
            ;;
    esac

    echo -e "\n"
}

function get_project_url() {
    echo "Step 3. Select URL"
    read -p "Enter the project URL, by which the store will be accessible in the browser: " choice

    if [[ -z "$choice" ]]
    then
        URL="${PROJECT//[- ]/_}.dev"
    else
        URL=$choice
    fi

    echo -e "\n"
}

function database_restore() {
    BACKUP_PATH="$PROJECT_PATH/_backups"

    # Navigate to backups directory
    cd "$BACKUP_PATH"

    MYSQL_HOST="db"
    MYSQL_ROOT_USER="root"
    MYSQL_PASSWORD="root"

# Execute MySQL command with Docker
docker-compose run --rm web bash -c "mysql -h $MYSQL_HOST -u $MYSQL_ROOT_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE << 'EOF'
SET autocommit=0;
SET unique_checks=0;
SET foreign_key_checks=0;

SOURCE /backups/$DATABASE_DUMP;
COMMIT;

SET unique_checks=1;
SET foreign_key_checks=1;
EOF"
}

function get_database_dump_path() {

    sql_files=()
    for file in $(find "$PROJECT_PATH/_backups" -maxdepth 1 -type f -name "*.sql")
    do
        sql_files+=("$file")
    done

    if [[ ${#sql_files[@]} -gt 0 ]]
    then
        echo " .sql:"
        for i in "${!sql_files[@]}"
        do
            echo "$((i+1)): ${sql_files[$i]}"
        done

        # Выбор файла по индексу
        read -p "Выберите номер файла: " selected_file_number

        if [[ "$selected_file_number" =~ ^[0-9]+$ ]] \
            && (( selected_file_number > 0 )) \
            && (( selected_file_number <= ${#sql_files[@]} ))
        then
            local index=$((selected_file_number - 1))
            local selected_file="${sql_files[$index]}"
            echo "Выбран файл: $selected_file"
            DATABASE_DUMP="${selected_file##*/}"
        else
        echo "skip"
        fi
    else
        echo "there's no files"
    fi

    echo -e "\n"
}

function check_project_directory() {
    if ! test -d "$HOME/$DEVELOP_DIR/$PROJECT"
    then
        echo "The directory $PROJECT does not exist."
        read -p "Enter yes (y) to create the $PROJECT directory, any key to cancel: " choice

        if [[ $choice = "y" || $choice = "yes" ]]
        then
            if ! mkdir -p "$HOME/$DEVELOP_DIR/$PROJECT"
            then
                echo "ERROR: Failed to create directory $HOME/$DEVELOP_DIR/$PROJECT."
                exit 1
            fi
        else
            echo "ERROR: Project directory should be specified."
            exit 1
        fi
        echo -e "\n"
    fi
}

function create_directories() {
    local docker_directory="$HOME/$DEVELOP_DIR/$PROJECT/_docker"

    if [[ -n "$(find "$docker_directory" -mindepth 1 -maxdepth 1 -type f)" ]]
    then
        echo "WARNING: Docker files directory exists and is not empty."
        read -p "Enter yes (y) to remove all files from the directory, any key to cancel: " choice

        if [[ $choice = "y" || $choice = "yes" ]]
        then
            rm -rf "$docker_directory"
        fi

    fi

    if ! mkdir -p "$docker_directory"
    then
        echo "ERROR: Failed to create directory $docker_directory."
        exit 1
    fi
    cd $docker_directory || { echo "ERROR: Cannot change directory."; exit 1; }
    mkdir -p nginx || { echo "ERROR: Failed to create nginx directory."; exit 1; }
    mkdir -p php || { echo "ERROR: Failed to create php directory."; exit 1; }
    mkdir -p mysql || { echo "ERROR: Failed to create mysql directory."; exit 1; }
    mkdir -p ssl || { echo "ERROR: Failed to create ssl directory."; exit 1; }
}

function ignore_git() {
    local git_exclude="../.git/info/exclude"
    if [[ -f $git_exclude ]]
    then
        if ! grep -q "^_docker/" $git_exclude
        then
            echo "_docker/" >> $git_exclude
        else
            echo "'.git/info/exclude' already contains '_docker/'"
        fi
    fi
}

function create_dockerfiles() {
    local php_dockerfile="php/Dockerfile"
    local mysql_dockerfile="mysql/Dockerfile"
    local app_root="/app"
    local php_extensions="bcmath mysqli pdo_mysql intl json curl soap exif zip sockets opcache gd"
    local container_path="/app/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    local group_name=$(id -gn)
    local group_id=$(id -g)
    local user_id=$(id -u)
    local user_name=$(id -un)
    local php_image_name
    local phpize_deps="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c"

    # Map OPT_PHP to Docker image name
    case "$PHP_VERSION" in
      "php56") php_image_name="php:5.6-fpm-alpine" ;;
      "php71") php_image_name="php:7.1-fpm-alpine" ;;
      "php72") php_image_name="php:7.2-fpm-alpine" ;;
      "php73") php_image_name="php:7.3-fpm-alpine"
          local redis="redis-5.0.2"
          local packages="vim git bash mysql-client openssh-client oniguruma freetype-dev libjpeg-turbo-dev libpng-dev icu-dev curl-dev libxml2-dev libzip-dev libgomp terminus-font graphviz"
          local install_imagic="" ;;
      "php74") php_image_name="php:7.4-fpm-alpine"
          local redis="redis-7.4"
          local packages="vim git bash mysql-client openssh-client oniguruma imagemagick6-dev freetype-dev libjpeg-turbo-dev libpng-dev icu-dev curl-dev libxml2-dev libzip-dev libgomp terminus-font graphviz"
          local install_imagic="RUN pecl install Imagick && docker-php-ext-enable imagick && docker-php-ext-configure gd --with-freetype=/usr --with-jpeg=/usr" ;;
      "php8") php_image_name="php:8.0-fpm-alpine" ;;
      "php81") php_image_name="php:8.1-fpm-alpine" ;;
      "php82") php_image_name="php:8.2-fpm-alpine" ;;
    esac

    # Create Dockerfile
    cat > $php_dockerfile <<EOF
FROM $php_image_name

RUN apk add --no-cache --virtual \
	.build-deps \
	$phpize_deps

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $packages

$install_imagic

RUN pecl install -o -f $redis && \
	docker-php-ext-enable redis

RUN docker-php-ext-install $php_extensions && apk del .build-deps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -L https://cs.symfony.com/download/php-cs-fixer-v3.phar -o php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

RUN curl -L https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -o phpcs
RUN curl -L https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar -o phpcbf
RUN chmod a+x phpcs phpcbf
RUN mv phpcs phpcbf /usr/local/bin/

RUN mkdir $app_root
WORKDIR $app_root

RUN addgroup -g $group_id $group_name \
    && adduser -u $user_id -G $group_name -D $user_name \
    && chown -R $user_name:$group_name /app

USER $user_name

ADD . $app_root
ENV PATH=$app_root/bin:$container_path

EOF


    # Map OPT_PHP to Docker image name
    case "$MYSQL_VERSION" in
      "mysql56") mysql_image_name="mysql:5.6" ;;
      "mysql57") mysql_image_name="mysql:5.7" ;;
      "mysql8") mysql_image_name="mysql:8" ;;
      "mariadb103") mysql_image_name="mariadb:10.3" ;;
      "mariadb104") mysql_image_name="mariadb:10.4" ;;
      "mariadb105") mysql_image_name="mariadb:10.5" ;;
      "mariadb106") mysql_image_name="mariadb:10.6" ;;
    esac

    # Create Dockerfile
    cat > $mysql_dockerfile <<EOF
FROM $mysql_image_name
EOF
}

# Build PHP docker image
function build_php_docker_image() {
    if ! docker build -t app php
    then
        echo "ERROR: Failed to build PHP docker image."
        exit 1
    fi
}

function build_mysql_docker_image() {
    if ! docker build -t app mysql
    then
        echo "ERROR: Failed to build MySQL docker image."
        exit 1
    fi
}


function create_docker_compose_file() {
    local docker_compose_file="../docker-compose.yml"

    MYSQL_DATABASE=${PROJECT//./_}

    # Creates docker-compose file
    cat > $docker_compose_file <<EOF
version: '3.9'

services:
  nginx:
    image: nginx:alpine
    working_dir: /etc/nginx
    volumes:
      - .:/app:cached
      - ./_docker/nginx:/etc/nginx/conf.d
      - ./_docker/ssl:/etc/nginx/ssl
      - ./_docker/logs/:/var/log/nginx
    ports:
      - "80:80"
      - "443:443"
    restart: always
    networks:
      - cscart

  web:
    build:
      context: "./_docker/php"
    working_dir: /app
    volumes:
      - .:/app:cached
      - ./_docker/php/php.ini:/usr/local/etc/php/conf.d/00-php.ini
      - ./_docker/ssl:/etc/ssl/certs/local
      - ./_backups:/backups/
    depends_on:
      - db
    networks:
      - cscart

  db:
    build:
      context: "./_docker/mysql"
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: admin
      MYSQL_PASSWORD: root
      MYSQL_DATABASE: $MYSQL_DATABASE
    volumes:
      - dbdata:/var/lib/mysql
      - ./_docker/logs:/var/log/mysql
    networks:
      - cscart

  adminer:
    image: adminer:fastcgi
    networks:
      - cscart

  mail:
    image: mailhog/mailhog
    tty: true
    ports:
      - '8025:8025'
    networks:
      - cscart

  redis:
    image: redis:latest
    ports:
      - "127.0.0.1:6379:6379"

volumes:
  dbdata:
    driver: local

networks:
  cscart:
EOF
}

function copy_makefile() {
    if [[ -f $ENVIRONMENT_DIR/Makefile.template ]]
    then
        cp $ENVIRONMENT_DIR/Makefile.template ../Makefile || { echo "ERROR: Failed to copy Makefile."; exit 1; }
    else
        echo "ERROR: There is no Makefile template."
        exit 1;
    fi
}

function copy_configfiles() {
    if [[ -f $ENVIRONMENT_DIR/nginx_conf.template ]]
    then
        cp $ENVIRONMENT_DIR/nginx_conf.template nginx/app.conf || { echo "ERROR: Failed to copy nginx config."; exit 1; }
    else
        echo "ERROR: There is no nginx config template."
        exit 1;
    fi

    if [[ -f $ENVIRONMENT_DIR/php_ini.template ]]
    then
        cp $ENVIRONMENT_DIR/php_ini.template php/php.ini || { echo "ERROR: Failed to copy php.ini."; exit 1; }
    else
        echo "ERROR: There is no php.ini template."
        exit 1;
    fi
}

function create_ssl_certs() {
    # Generate SSL certificates
    mkcert "$URL"

    local ssl_dir="$PROJECT_PATH/_docker/ssl"
    local key_path="$ssl_dir/cert.key"
    local crt_path="$ssl_dir/cert.crt"

    mv "$URL-key.pem" "$key_path"
    mv "$URL.pem" "$crt_path"

    # Set permissions
    chmod 0755 "$ssl_dir"
    chmod 0644 "$key_path" "$crt_path"
}

function build_docker_compose() {
    if ! docker-compose -f "$PROJECT_PATH/docker-compose.yml" build;
    then
        echo "ERROR: Failed to build docker images."
        exit 1
    fi
}

function main() {
    check_dependencies
    get_project_directory
    check_project_directory
    get_php_version
    get_mysql_version
    get_project_url
    get_database_dump_path
    create_directories
    ignore_git
    copy_makefile
    copy_configfiles
    create_ssl_certs
    create_dockerfiles
    build_php_docker_image
    build_mysql_docker_image
    create_docker_compose_file
    build_docker_compose

    if [[ -n $DATABASE_DUMP ]]
    then
        database_restore
    fi
}

main "${@}"

echo "Project successfully created"
