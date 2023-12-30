#!/usr/bin/env bash
set -euo pipefail

# Constants
DEVELOP_DIR="Develop"
MYSQL_VERSIONS=("mariadb103" "mariadb104" "mariadb105" "mariadb106")
PHP_VERSIONS=("php56" "php71" "php72" "php73" "php74" "php8" "php81" "php82")

# Checks dependencies
function check_dependencies() {
    local dependencies=("docker" "docker-compose" "curl" "sed" "id")

    for dependency in "${dependencies[@]}"; do
        type "$dependency" >/dev/null 2>&1 || { echo "ERROR: Executable not found: $dependency."; exit 1; }
    done
}

# Checks if the docker daemon running
function check_docker() {
    docker info >/dev/null 2>&1 || { echo "ERROR: Docker daemon is not running".; exit 1; }
}

# Prints help
function print_help() {
cat <<- HELP
Usage: $(basename ${0}) "<project_name> [php_version] [mysql_version]

Supported PHP versions:
  ${PHP_VERSIONS[@]}

Supported MySQL versions:
  ${MYSQL_VERSIONS[@]}

Example:
  $(basename ${0}) laravel-app php74 mariadb106

HELP
}

# Parses arguments
function parse_args() {
    FORCE=0
    local args=()

    for arg in "$@"; do
        case "$arg" in
            -f|--force)
                FORCE=1
                ;;
            -*)
                echo "ERROR: Unknown option: $arg"
                print_help
                exit 1
                ;;
            *)
                args+=("$arg")
                ;;
        esac
    done

    if [[ ${#args[@]} -lt 1 ]]; then
        print_help
        exit 0
    fi

    OPT_PROJECT=${args[0]}
    OPT_PHP=${args[1]:-php74}
    OPT_MYSQL=${args[2]:-mariadb106}

    if [[ ! " ${PHP_VERSIONS[*]} " =~ " ${OPT_PHP} " ]]
    then
        echo "ERROR: You should select a PHP version from the next values: ${PHP_VERSIONS[*]}."
        exit 1
    fi

    if [[ ! " ${MYSQL_VERSIONS[*]} " =~ " ${OPT_MYSQL} " ]]
    then
        echo "ERROR: You should select a MySQL version from the next values: ${MYSQL_VERSIONS[*]}."
        exit 1
    fi
}

# Creates project directory
function create_project_dir() {
    PROJECT_DIR="$HOME/$DEVELOP_DIR/$OPT_PROJECT"
    # Removes directory if it exsists
    if [[ -d $PROJECT_DIR ]];
    then
        if [[ -n "$(ls -A "$PROJECT_DIR")" ]]; then
            if [[ $FORCE -eq 1 ]]; then
                rm -rf "$PROJECT_DIR"
            else
                echo "ERROR: Directory exists and is not empty."
                exit 1
            fi
        fi
    fi

    if ! mkdir -p "$PROJECT_DIR"; then
        echo "ERROR: Failed to create directory $PROJECT_DIR."
        exit 1
    fi
}

# Creates Dockerfile
function create_dockerfile() {
    local dockerfile="$PROJECT_DIR/Dockerfile"
    local app_root="/app"
    local packages="vim nodejs yarn git bash mysql-client"
    local php_extensions="bcmath mysqli pdo_mysql"
    local container_path="/app/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    local group_name=$(id -gn)
    local group_id=$(id -g)
    local user_id=$(id -u)
    local user_name=$(id -un)
    local php_image_name

    # Map OPT_PHP to Docker image name
    case "$OPT_PHP" in
      "php56") php_image_name="php:5.6-fpm-alpine" ;;
      "php71") php_image_name="php:7.1-fpm-alpine" ;;
      "php72") php_image_name="php:7.2-fpm-alpine" ;;
      "php73") php_image_name="php:7.3-fpm-alpine" ;;
      "php74") php_image_name="php:7.4-fpm-alpine" ;;
      "php8") php_image_name="php:8.0-fpm-alpine" ;;
      "php81") php_image_name="php:8.1-fpm-alpine" ;;
      "php82") php_image_name="php:8.2-fpm-alpine" ;;
    esac

    # Create Dockerfile
    cat > $dockerfile <<EOF
FROM $php_image_name

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $packages

RUN docker-php-ext-install $php_extensions

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

EXPOSE 8000
CMD php artisan serve -h 0.0.0.0 -p 8000

EOF
}

# Build docker image
function build_docker_image() {
    if ! docker build -t app "$PROJECT_DIR"; then
        echo "ERROR: Failed to build docker image."
        exit 1
    fi
}

# Creates laravel project
function create_laravel_project() {
    docker run -it -v $PROJECT_DIR:/app app bash -c "composer create-project --prefer-dist laravel/laravel tmp"

    mv $PROJECT_DIR/tmp/* $PROJECT_DIR
    mv $PROJECT_DIR/tmp/.[!.]* $PROJECT_DIR
    rmdir $PROJECT_DIR/tmp

    # Check that the build is OK
    if ! docker build -t app $PROJECT_DIR; then
        echo "ERROR: Failed to build docker image."
        exit 1
    fi
}

# Creates docker-compose file
function create_docker_compose_file() {
    local docker_compose_file="$PROJECT_DIR/docker-compose.yml"

    # Map OPT_MYSQL to Docker image name
    case "$OPT_MYSQL" in
      "mariadb103") mysql_image_name="mariadb:10.3" ;;
      "mariadb104") mysql_image_name="mariadb:10.4" ;;
      "mariadb105") mysql_image_name="mariadb:10.5" ;;
      "mariadb106") mysql_image_name="mariadb:10.6" ;;
    esac

    MYSQL_DATABASE=${OPT_PROJECT//./_}

    # Creates docker-compose file
    cat > $docker_compose_file <<EOF
version: '3.9'

services:
  web:
    build: .
    volumes:
      - .:/app:cached
      - ~/.ssh:/root/.ssh
      - ~/.bash_history:/root/.bash_history
    ports:
      - 8000:8000
    depends_on:
      - db
    command: php artisan serve --host '0.0.0.0' --port 8000

  db:
    image: $mysql_image_name
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: admin
      MYSQL_PASSWORD: root
      MYSQL_DATABASE: $MYSQL_DATABASE
    volumes:
      - dbdata:/var/lib/mysql

  adminer:
    image: adminer
    ports:
      - 8080:8080

volumes:
  dbdata:
    driver: local
EOF
}

# Creates Makefile
function create_makefile() {
    local makefile="$PROJECT_DIR/Makefile"

    # Creates docker-compose file
    cat > $makefile <<EOF
up:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

restart:
	docker-compose restart

down:
	docker-compose down

clean:
    docker-compose down -v

ps:
	docker-compose ps

logs:
	docker-compose logs --tail=100 -f nginx || true

dblogs:
	docker-compose logs --tail=100 -f db || true

console:
	docker-compose run --rm web bash
EOF
}

# Creates PHP-CS-Fixer config
function create_php_cs_fixer_config() {
    local config="$PROJECT_DIR/.php-cs-fixer.php"

    # Creates docker-compose file
    printf "\
<?php

\$config = new PhpCsFixer\Config();

return \$config->setRules([
    '@Symfony' => true,
    'full_opening_tag' => true,
    'concat_space' => ['spacing' => 'one'],
    'single_quote' => true,
    'array_syntax' => ['syntax' => 'short'],
    'yoda_style' => false,
    'combine_consecutive_unsets' => true,
    'no_alias_language_construct_call' => false,
    'global_namespace_import' => [
        'import_classes' => true,
        'import_constants' => true,
        'import_functions' => true,
    ],
    'no_useless_else' => true,
    'group_import' => true,
    'single_import_per_statement' => false,
]);

" > $config
}

# Builds docker compose images
function build_docker_compose() {
    if ! docker-compose -f "$PROJECT_DIR/docker-compose.yml" build;
    then
        echo "ERROR: Failed to build docker images."
        exit 1
    fi
}

function main() {
    check_dependencies
    check_docker
    parse_args "${@}"
    create_project_dir
    create_dockerfile
    build_docker_image
    create_laravel_project
    create_docker_compose_file
    create_makefile
    build_docker_compose
}

main "${@}"

echo "Project successfully created"
