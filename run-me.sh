#!/bin/bash

# Color definitions
GREEN='\033[0;32m'  # Green color for success messages
RED='\033[0;31m'    # Red color for error messages
NC='\033[0m'        # No Color

# Function to check if the script is run as root
check_if_root() {
    echo "Checking if running as root..."
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}This script must be run as root. Please switch to the root user and try again.${NC}"
        echo -e "\nTroubleshooting steps:"
        echo "1. Use 'sudo su' to switch to the root user."
        exit 1
    fi
    echo -e "${GREEN}Root user check passed.${NC}"
    sleep 2  # Delay for 2 seconds
}

# Function to check if specific ports are in use
check_ports_in_use() {
    echo "Checking if ports 8888 and 8025 are open..."
    ports=(8888 8025)
    for port in "${ports[@]}"; do
        if netstat -tuln | grep -q ":$port"; then
            echo -e "${RED}Port $port is already in use. Please free it before running the script.${NC}"
            echo -e "\nTroubleshooting steps:"
            echo "1. Identify which process is using the port with 'sudo netstat -tulnp | grep :$port'."
            echo "2. Kill the process if necessary: 'sudo kill <PID>'."
            exit 1
        fi
    done
    echo -e "${GREEN}Port usage check completed. Ports 8888 and 8025 are free.${NC}"
    sleep 2  # Delay for 2 seconds
}

# Function to check if the Docker containers are running successfully
check_docker_containers() {
    echo "Checking if Docker containers are running..."
    container_status=$(sudo docker ps --filter "name=crapi" --format "{{.Status}}")
    
    if [[ -z "$container_status" ]]; then
        echo -e "${RED}Docker containers did not execute successfully. Setup unsuccessful.${NC}"
        echo -e "\nTroubleshooting steps:"
        echo "1. Check Docker service status with 'sudo systemctl status docker'."
        echo "2. Review Docker logs with 'sudo docker logs <container_id>'."
        exit 1
    fi
    echo -e "${GREEN}Docker containers are running successfully.${NC}"
    sleep 2  # Delay for 2 seconds

    # Open URLs in the default browser
    echo "Opening CrAPI URLs in your default web browser..."
    xdg-open http://localhost:8888
    xdg-open http://localhost:8025
    sleep 2  # Delay for 2 seconds
}

# Function to run the Docker setup
run_docker_setup() {
    echo "Starting Docker installation..."
    sudo bash docker_install.sh
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Docker installation failed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Docker installation completed.${NC}"
    sleep 2  # Delay for 2 seconds

    echo "Starting CrAPI setup..."
    sudo docker-compose -f setup-crapi.yml --compatibility up -d
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}CrAPI setup failed.${NC}"
        echo -e "\nTroubleshooting steps:"
        echo "1. Ensure Docker is running with 'sudo systemctl start docker'."
        echo "2. Review logs with 'sudo docker-compose logs"
        exit 1
    fi

    # Check if containers are running successfully
    check_docker_containers
    echo -e "${GREEN}You may access CrAPI now at http://localhost:8888 and http://localhost:8025${NC}"
}

# Main script logic
check_if_root
check_ports_in_use
run_docker_setup
