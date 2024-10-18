![Logo](https://github.com/HacktivistRO/Bug-Bounty-Wordlists/assets/49992837/71eb3178-b66c-4981-8da0-229499b61fee)

![Profile_Views](https://komarev.com/ghpvc/?username=HacktivistRO&style=for-the-badge)

# Setting up crAPI on Linux

## Overview

This repository provides a Bash script to install Docker on a Linux system and set up **crAPI** (Completely Ridiculous API) using Docker. The setup has been developed and tested on various Linux distributions, including Ubuntu, Kali, Parrot OS, Fedora, and CentOS.

## Prerequisites

Before running the setup, ensure:
- You are running a **Unix-based OS** (Linux distributions such as Ubuntu, Kali, Parrot, Fedora, CentOS, etc.).
- You have **root** user access or can execute commands with `sudo`.
- An active internet connection is required to download Docker and crAPI resources.

## Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/HacktivistRO/CrAPI-Linux-Setup
cd CrAPI-Linux-Setup
```

### 2. Run the Setup Script as Root

To install Docker and set up crAPI, make the script executable and run it as **root** or with `sudo`:

```bash
chmod +x run-me.sh
sudo ./run-me.sh
```

### 3. Post-Installation (Optional step)

Once the script is completed:
- **Docker** and **Docker Compose** will be installed.
- **crAPI** will be running in Docker containers.

Verify the running containers with the following command:

```bash
docker ps
```

### 4. Access crAPI

Access **crAPI** in your browser at `http://localhost:8888` and crAPI mails at `http://localhost:8025`.

## Troubleshooting

- Ensure you run the script as **root** or with `sudo` privileges.
- If Docker installation fails, check if Docker is installed:

    ```bash
    docker --version
    ```

- For issues with crAPI, check Docker Compose logs:

    ```bash
    docker-compose logs -f
    ```

- If you encounter port conflicts, make sure that ports **8888** and **8025** are free before running the script:

    ```bash
    sudo netstat -tulnp | grep ':8888\|:8025'
    ```

- To free up a port if it's in use, identify the process and kill it:

    ```bash
    sudo netstat -tulnp | grep :<port>
    sudo kill <PID>
    ```

## Script Overview

- **docker_install.sh**: Installs Docker and Docker Compose.
- **setup-crapi.yml**: Defines the Docker Compose services for crAPI.
- **run-me.sh**: Executes the Docker installation script and sets up crAPI using Docker Compose.

## Tested Environments

- **Ubuntu 20.04**
- **Ubuntu 22.04**
- **Kali Linux**
- **Parrot OS**
- **Fedora**
- **CentOS**

## Disclaimer

This setup is intended for testing and educational purposes. Please ensure crAPI is run in a controlled environment and not exposed to the internet without appropriate security controls.

## License

This repository is licensed under the [MIT License](LICENSE).

## Author

Developed by [@HacktivistRO](https://github.com/HacktivistRO/). Please create an issue or pull request on GitHub for issues or contributions.
