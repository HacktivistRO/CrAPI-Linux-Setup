#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if script is run as root
check_if_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}This script must be run as root. Please switch to the root user and try again.${NC}"
        exit 1
    fi
}

# Function to check if the system is running a Unix-based OS
check_if_unix() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     os_type=Linux;;
        Darwin*)    os_type=Mac;;
        *)          os_type="UNKNOWN";;
    esac
    
    if [[ "$os_type" != "Linux" && "$os_type" != "Mac" ]]; then
        echo -e "${RED}Unsupported OS detected. This script only supports Unix-based systems (Linux/macOS).${NC}"
        exit 1
    else
        echo -e "${GREEN}Detected $os_type system. Proceeding...${NC}"
    fi
}

# Function to check if Docker is installed
check_docker_installed() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker is already installed.${NC}"
        return 0
    else
        echo -e "${RED}Docker is not installed. Installing Docker now...${NC}"
        return 1
    fi
}

# Function to check if Docker Compose is installed
check_docker_compose_installed() {
    if command -v docker-compose &> /dev/null; then
        echo -e "${GREEN}Docker Compose is already installed.${NC}"
        return 0
    else
        echo -e "${RED}Docker Compose is not installed. It will be installed along with Docker.${NC}"
        return 1
    fi
}

# Function to run 'docker hello-world' and check if Docker is installed successfully
check_docker_hello_world() {
    hello_world_output=$(sudo docker run hello-world 2>&1)
    if echo "$hello_world_output" | grep -q "Hello from Docker!"; then
        echo -e "${GREEN}Docker installation successful! 'hello-world' ran as expected.${NC}"
    else
        echo -e "${RED}Docker installation unsuccessful. 'hello-world' did not return the expected output.${NC}"
        echo -e "${YELLOW}Troubleshooting tips:${NC}"
        echo -e "${YELLOW}1. Ensure Docker service is running: sudo systemctl start docker${NC}"
        echo -e "${YELLOW}2. Check for Docker logs: sudo journalctl -u docker.service${NC}"
        echo -e "${YELLOW}3. Verify your user is in the docker group (or use sudo with Docker commands).${NC}"
        exit 1
    fi
}

# Function to install Docker on Kali Linux
install_docker_kali() {
    echo -e "${GREEN}Detected Kali Linux. Proceeding with Docker installation.${NC}"
    
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg -y
    done
    
    sudo apt update
    sudo apt install ca-certificates curl gnupg lsb-release -y
    
    sudo mkdir -p /etc/apt/keyrings
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    check_docker_hello_world
}

# Function to install Docker on Ubuntu
install_docker_ubuntu() {
    echo -e "${GREEN}Detected Ubuntu. Proceeding with Docker installation.${NC}"
    
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg -y
    done
    
    sudo apt update
    sudo apt install ca-certificates curl gnupg lsb-release -y
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    check_docker_hello_world
}

# Function to install Docker on Parrot OS
install_docker_parrot() {
    echo -e "${GREEN}Detected Parrot OS. Proceeding with Docker installation.${NC}"
    
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg -y
    done
    
    sudo apt update
    sudo apt install ca-certificates curl gnupg lsb-release -y
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    check_docker_hello_world
}

# Function to install Docker on Debian
install_docker_debian() {
    echo -e "${GREEN}Detected Debian. Proceeding with Docker installation.${NC}"
    
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg -y
    done
    
    sudo apt update
    sudo apt install ca-certificates curl gnupg lsb-release -y
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    check_docker_hello_world
}

# Function to install Docker on Fedora
install_docker_fedora() {
    echo -e "${GREEN}Detected Fedora. Proceeding with Docker installation.${NC}"
    
    sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    sudo systemctl start docker
    sudo systemctl enable docker
    
    check_docker_hello_world
}

# Function to install Docker on CentOS/RHEL/AlmaLinux/Rocky
install_docker_rhel() {
    echo -e "${GREEN}Detected CentOS/RHEL/AlmaLinux/Rocky. Proceeding with Docker installation.${NC}"
    
    sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
    
    sudo systemctl start docker
    sudo systemctl enable docker
    
    check_docker_hello_world
}

# Function to install Docker on openSUSE/SLES
install_docker_suse() {
    echo -e "${GREEN}Detected openSUSE/SLES. Proceeding with Docker installation.${NC}"
    
    sudo zypper remove -y docker docker-compose
    sudo zypper install -y docker docker-compose
    
    sudo systemctl enable docker
    sudo systemctl start docker
    
    check_docker_hello_world
}

# Function to detect Linux distribution and install Docker
detect_distro_and_install_docker() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distro=$ID

        case "$distro" in
            kali)
                install_docker_kali
                ;;
            ubuntu)
                install_docker_ubuntu
                ;;
            parrot)
                install_docker_parrot
                ;;
            debian)
                install_docker_debian
                ;;
            fedora)
                install_docker_fedora
                ;;
            centos|rhel|almalinux|rocky)
                install_docker_rhel
                ;;
            opensuse|sles)
                install_docker_suse
                ;;
            *) 
                echo -e "${YELLOW}Unable to detect the Linux distribution. Proceeding with Debian.${NC}"
                install_docker_debian
                ;;
        esac
    else
        
        exit 1
    fi
}

# Main script logic
check_if_root
check_if_unix
check_docker_installed
docker_installed=$?

check_docker_compose_installed
docker_compose_installed=$?

# If either Docker or Docker Compose is not installed, proceed with installation
if [ $docker_installed -ne 0 ] || [ $docker_compose_installed -ne 0 ]; then
    detect_distro_and_install_docker
else
    echo -e "${GREEN}Docker and Docker Compose are already set up.${NC}"
    check_docker_hello_world  # Check if Docker is working properly
fi