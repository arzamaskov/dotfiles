#!/usr/bin/env bash
set -euo pipefail

# Constants
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'  # No Color

function get_php_version() {
    echo "Step 1. Select PHP version"
    echo "The following PHP versions are available:"
    # echo "1) PHP 5.6"
    # echo "2) PHP 7.1"
    # echo "3) PHP 7.3"
    echo "4) PHP 7.4"
    echo "5) PHP 8.0"
    echo "6) PHP 8.1"
    echo "7) PHP 8.2"
    echo "PHP 8.1 will be set as default if no choice is made."

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
            PHP_VERSION="7.4.33"
            ;;
        5)
            echo "You have selected PHP 8.0."
            PHP_VERSION="8.0.30"
            ;;
        6)
            echo "You have selected PHP 8.1."
            PHP_VERSION="8.1.24"
            ;;
        7)
            echo "You have selected PHP 8.2."
            PHP_VERSION="8.2.13"
            ;;
        *)
            echo "Invalid choice, PHP 8.1 will be set as default."
            PHP_VERSION="8.1.24"
            ;;
    esac

    echo -e "\n"
}

function switch_php_version {
    local is_phpfpm_running=$(lsof -i -n -P | rg php-fpm)

    if [[ $is_phpfpm_running ]]; then
        echo "Stopping PHP-FPM...";
        killall php-fpm || { echo -e "${RED}ERROR${NC}: Failed to kill php-fpm process."; exit 1; };
        echo -e "${GREEN}Done.${NC}"
    fi


    echo "Switching PHP from to PHP $PHP_VERSION...";
    asdf global php $PHP_VERSION || { echo -e "${RED}ERROR${NC}: Failed to switch php version."; exit 1; };
    echo -e "${GREEN}Done.${NC}"

    echo "Runnig PHP-FPM..."
    asdf exec php-fpm -R 2>/dev/null || { echo -e "${RED}ERROR${NC}: Failed to run PHP-FPM."; exit 1; };
    echo -e "${GREEN}Done.${NC}"
}

function main() {
    get_php_version
    switch_php_version
}

main

echo -e "${GREEN}SUCCESS.${NC} PHP version has changed."
