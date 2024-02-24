#!/usr/bin/env bash
set -euo pipefail

# Constants
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'  # No Color
HOMEBREW_DIR="/opt/homebrew"
SERVERS_DIR="$HOMEBREW_DIR/etc/nginx/servers"
DEFAULT_54="$HOMEBREW_DIR/etc/nginx/default-54.conf"
DEFAULT_55="$HOMEBREW_DIR/etc/nginx/default-55.conf"
DEVELOP_DIR="$HOME/Develop"
SSL_DIR="$HOMEBREW_DIR/etc/nginx/ssl"

create-nginx-server ()
{
    local path=${1:-}

    if [[ ! $path ]]; then
        echo -e "${RED}ERROR${NC}: Missing project name."; exit 1;
    fi
    echo -e "Is the name of the web server \"${GREEN}$path${NC}\" correct?\n";
    read -p "Type \"yes\" to continue or any other key (and then enter) to abort " choice

    if [[ $choice != "yes" ]]; then
        echo -e "Aborting...${GREEN}[OK]${NC}"
        exit 0;
    fi

    local pattern=$(echo "$path" | awk -F'.' '{print $1}')
    local project_dirs=$(find . -maxdepth 1 -type d -name "*$pattern*" | sed 's/^\.\///g')

    options=($(echo "$project_dirs"))
    if [ "${#options[@]}" -eq 1 ]; then
        local project_dir="${options[0]}"
    else
        echo -e "Found several direcrories:\n";
        PS3="Select a directory (enter a number): "
        select project_dir in "${options[@]}"; do
            if [ -n "$project_dir" ]; then
                echo -e "A directory has been selected: $project_dir"
                break
            else
                echo "Incorrect choice. Please enter the directory number."
            fi
        done
    fi

    local suffix=$(echo "$project_dir" | grep -oE '[0-9]{2}$');

    if [[ "$suffix" == "55" ]]; then
        version=5
    elif [[ "$suffix" == "54" ]]; then
        version=4
    else
        read -p "Enter X-Cart version 4 for X-Cart 5.4 or 5 for X-Cart 5.5: " user_input
        if [[ "$user_input" == "4" || "$user_input" == "5" ]]; then
            version="$user_input"
        else
            echo -e "An incorrect value has been entered. Setting the default value: 4\n"
            version=4
        fi
    fi

    local conf_file="prj-${path}-xc5${version}.conf";
    local host="${path}.x";

    echo -e "Copying files...";
    if [[ $version == "4" ]]; then
        if [[ ! -e "$DEFAULT_54" ]]; then
            wget https://gist.github.com/arzamaskov/9a96c7bd9c869806ae0e98df415be2bb -O "$DEFAULT_54";
        fi
        cp "$DEFAULT_54" "$SERVERS_DIR/$conf_file" || { echo -e "${RED}ERROR${NC}: Failed to copy config file."; exit 1; }
        local root="${DEVELOP_DIR}/${project_dir}"
    else
        if [[ ! -e "$DEFAULT_54" ]]; then
            wget https://gist.github.com/arzamaskov/2d22cf3ab13ed5ecd921de8e0a153079 -O "$DEFAULT_55";
        fi
        cp "$DEFAULT_55" "$SERVERS_DIR/$conf_file"
        local root="${DEVELOP_DIR}/${project_dir}/public" || { echo -e "${RED}ERROR${NC}: Failed to copy config file."; exit 1; }
    fi
    echo -e "${GREEN}Done.${NC}";

    echo -e "Parsing files...";
    sed -i '' "s:{{host}}:${host}:" "${SERVERS_DIR}/$conf_file" || { echo -e "${RED}ERROR${NC}: Failed to parse host name."; exit 1; }
    sed -i '' "s:{{root}}:${root}:" ${SERVERS_DIR}/$conf_file || { echo -e "${RED}ERROR${NC}: Failed to root directory."; exit 1; }
    echo -e "${GREEN}Done.${NC}";

    echo -e "Creating certificates...";
    mkcert "$host" || { echo -e "${RED}ERROR${NC}: Failed to create ssl-certificates."; exit 1; }
    echo -e "${GREEN}Done.${NC}";

    if [[ ! -d $SSL_DIR ]]; then
        mkdir -p $SSL_DIR
        chmod 0755 "$SSL_DIR"
    fi

    local key_path="$SSL_DIR/${host}.key"
    local crt_path="$SSL_DIR/${host}.crt"

    echo -e "Moving certificates...";
    mv "${host}-key.pem" "$key_path" || { echo -e "${RED}ERROR${NC}: Failed to move ${host}-key.pem file."; exit 1; }
    mv "${host}.pem" "$crt_path" || { echo -e "${RED}ERROR${NC}: Failed to move ${host}.pem file."; exit 1; }
    echo -e "${GREEN}Done.${NC}";

    echo -e "Setting premissions...";
    chmod 0644 "$key_path" "$crt_path" || { echo -e "${RED}ERROR${NC}: Failed to set permissions."; exit 1; }
    echo -e "${GREEN}Done.${NC}";

    echo -e "Reload nginx config...";
    sudo nginx -s reload || { echo -e "${RED}ERROR${NC}: Failed to reload nginx config."; exit 1; }
    echo -e "${GREEN}Done.${NC}";

    echo -e "${GREEN}SUCCESS.${NC} Web-server has created with parameters:.\n"
    echo -e "Project directory: ${GREEN}$project_dir${NC}"
    echo -e "Config file: ${GREEN}${SERVERS_DIR}${conf_file}${NC}"
    echo -e "SSL key: ${GREEN}${key_path}${NC}"
    echo -e "SSL cert: ${GREEN}${crt_path}${NC}"
    echo -e "HTTP host: ${GREEN}http://${host}${NC}"
    echo -e "HTTPS host: ${GREEN}https://${host}${NC}\n"
}

main ()
{
    create-nginx-server "$@";
}

main "$@"
