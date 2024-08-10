#!/bin/bash

# Set up a Python virtual environment and install dependencies
setup_python_env() {
    echo "Setting up Python virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
}

# Install necessary system packages and tools
install_system_dependencies() {
    echo "Installing system dependencies..."

    # Update package lists
    sudo apt-get update

    # Install Python3 and pip
    sudo apt-get install -y python3 python3-venv python3-pip

    # Install Ansible
    sudo apt-get install -y ansible

    # Install Terraform
    sudo apt-get install -y wget unzip
    wget https://releases.hashicorp.com/terraform/1.4.0/terraform_1.4.0_linux_amd64.zip
    unzip terraform_1.4.0_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.4.0_linux_amd64.zip

    # Install Vagrant
    sudo apt-get install -y vagrant

    # Install Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    # Install Kubernetes tools (kubectl, minikube)
    sudo apt-get install -y kubectl
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Install Jenkins (optional: as a service)
    sudo apt-get install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install -y jenkins

    # Install GitLab Runner (optional)
    sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
    sudo chmod +x /usr/local/bin/gitlab-runner
    sudo gitlab-runner install
    sudo gitlab-runner start

    # Install ELK stack (optional: Elasticsearch, Logstash, Kibana)
    sudo apt-get install -y apt-transport-https
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
    sudo apt-get update && sudo apt-get install -y elasticsearch logstash kibana
    sudo systemctl enable elasticsearch
    sudo systemctl enable logstash
    sudo systemctl enable kibana
}

# Main function to orchestrate setup
main() {
    install_system_dependencies
    setup_python_env
    echo "Setup complete. Virtual environment created and dependencies installed."
    echo "To activate the virtual environment, run 'source venv/bin/activate'."
}

main
