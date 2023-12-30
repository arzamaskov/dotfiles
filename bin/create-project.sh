#!/usr/bin/bash
set -euo pipefail

# Set the cleanup function to be called on normal exit
trap cleanup EXIT

function cleanup() {
    # Check if OPT_PROJECT is set before proceeding
    if [[ -z ${OPT_PROJECT+x} ]]
    then
        return
    fi

    # Check if Docker is running before proceeding
    if ! docker info &> /dev/null;
    then
        return
    fi

    echo "Stopping Docker container..."
    docker-compose -f "$HOME/$DEVELOP_DIR/$OPT_PROJECT/docker-compose.yml" down
}

# Constants
ARGS=("${@}")
DEVELOP_DIR="Develop"
DOCKER_TEMPLATE_DIR="$HOME/$DEVELOP_DIR/docker-compose-php"
MYSQL_VERSIONS=("mysql56" "mysql57" "mysql8" "mariadb103" "mariadb104" "mariadb105" "mariadb106")
PHP_VERSIONS=("php56" "php71" "php72" "php73" "php74" "php8" "php81" "php82")

# Check dependencies
function check_dependencies() {
    local dependencies=("docker" "docker-compose" "curl" "sed" "getopt")

    for dependency in "${dependencies[@]}"; do
        which "$dependency" || { echo "ERROR: Executable not found: $dependency"; exit 1; }
    done
}

# Check if the docker daemon running
function check_docker() {
    docker info >/dev/null 2>&1 || { echo "ERROR: Docker daemon is not running"; exit 1; }
}

# Clone docker-compose-php repository if not present
function clone_docker_repo() {
    if [[ ! -d "$DOCKER_TEMPLATE_DIR" ]]
    then
        check_dependencies
        git clone git@github.com:arzamaskov/docker-compose-php.git "$DOCKER_TEMPLATE_DIR"
    fi
}

function print_help() {
cat <<- HELP
Usage: $(basename ${0}) <project_name> [php_version] [mysql_version]

Supported PHP versions:
  ${PHP_VERSIONS[@]}

Supported MySQL versions:
  ${MYSQL_VERSIONS[@]}

Example:
  $(basename ${0}) localhost.dev php74 mariadb106

HELP
}

function parse_args() {
    OPTS=$(/usr/bin/getopt \
        --options "h" \
        --longoptions "help" \
        --name "$0" \
        -- "${ARGS[@]}"
    )

    eval set -- "$OPTS"

    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help)
                print_help
                exit 0
                ;;
            --)
                shift
                break
                ;;
        esac
    done

    shift $((OPTIND-1))

    if [[ "$#" -eq 0 ]]
    then
        print_help
        exit 0
    else
        OPT_PROJECT=$1
        OPT_PHP=${2:-php74}
        OPT_MYSQL=${3:-mariadb106}
    fi

    if [[ ! " ${PHP_VERSIONS[*]} " =~ " ${OPT_PHP} " ]]
    then
        echo "ERROR: You should select a PHP version from the next values: ${PHP_VERSIONS[*]}"
        exit 1
    fi

    if [[ ! " ${MYSQL_VERSIONS[*]} " =~ " ${OPT_MYSQL} " ]]
    then
        echo "ERROR: You should select a MySQL version from the next values: ${MYSQL_VERSIONS[*]}"
        exit 1
    fi
}

function create_project() {
    # Set up project directory
    PROJECT_DIR="$HOME/$DEVELOP_DIR/$OPT_PROJECT"
    mkdir -p "$PROJECT_DIR"

    # Copy docker-compose env to project directory
    cp -R "$DOCKER_TEMPLATE_DIR"/* "$PROJECT_DIR"/

    # Remove unnecessary files
    rm -rf "$PROJECT_DIR"/.git
    rm "$PROJECT_DIR"/README.md
    find "$PROJECT_DIR" -type f -name .gitkeep -delete

    # Copy and update .env file
    MYSQL_DATABASE=${OPT_PROJECT//./_}
    echo $MYSQL_DATABASE
    mv -n "$PROJECT_DIR"/dev.env "$PROJECT_DIR"/.env
    sed -i "s/^PROJECT_NAME=.*/PROJECT_NAME=$OPT_PROJECT/" "$PROJECT_DIR"/.env
    sed -i "s/^PHP_VERSION=.*/PHP_VERSION=$OPT_PHP/" "$PROJECT_DIR"/.env
    sed -i "s/^MYSQL_VERSION=.*/MYSQL_VERSION=$OPT_MYSQL/" "$PROJECT_DIR"/.env
    sed -i "s/^MYSQL_DATABASE=.*/MYSQL_DATABASE=$MYSQL_DATABASE/" "$PROJECT_DIR"/.env

    if [[ "$OPT_PROJECT" != "app" ]]; then
        rm -rf "$PROJECT_DIR"/app
        mkdir -p "$PROJECT_DIR/$OPT_PROJECT"
    fi
}

function create_ssl_certs() {
    # Generate SSL certificates
    mkcert "$OPT_PROJECT" "*.$OPT_PROJECT"

    local ssl_dir="$PROJECT_DIR/config/ssl"
    local key_path="$ssl_dir/cert.key"
    local crt_path="$ssl_dir/cert.crt"

    mv "$OPT_PROJECT+1-key.pem" "$key_path"
    mv "$OPT_PROJECT+1.pem" "$crt_path"

    # Set permissions
    chmod 0755 "$ssl_dir"
    chmod 0644 "$key_path" "$crt_path"
}

function build() {
    if ! docker-compose -f "$HOME/$DEVELOP_DIR/$OPT_PROJECT/docker-compose.yml" build;
    then
        echo "ERROR: Failed to build docker images."
        exit 1
    fi
}

function main() {
    check_docker
    clone_docker_repo
    parse_args
    create_project
    create_ssl_certs
    build
}

main
