# Azure CLI Uploader

Azure CLI Uploader is a bash-based command-line tool designed for a seamless file upload experience to Microsoft Azure Blob storage. This tool simplifies the upload process, allowing users to easily authenticate with Azure and upload files directly to a specified container.

## Features

1. **Easy Authentication:**
   - Quickly authenticate with Microsoft Azure for seamless access.

2. **Direct File Upload:**
   - Upload multiple files directly to Azure Blob storage containers.

3. **Generate Shareable Links:**
   - Easily generate links for uploaded files, making sharing a breeze.

4. **Simple Installation:**
   - Follow the straightforward installation process to get started.

## Prerequisites and Setup

Before using Azure CLI Uploader, ensure you have the following:

- A chosen cloud provider (Microsoft Azure is used in this project).
- An active Azure subscription.
- Azure CLI tool installed and authenticated.
- A Bash environment available on Linux/Unix, WSL (Windows Subsystem for Linux), or macOS.

## Installation and Usage

Follow these steps to install and use Azure CLI Uploader:

1. Clone the repository to your local machine.
   ```bash
   git clone https://github.com/your-username/Azure-CLI-Uploader.git
2. Navigate to project directory
   ```bash
   cd Azure-CLI-Uploader
3. Run the installation script
   ```bash
   ./install.sh
4. After installation, use the following command to upload files
   ```bash
   ./uploader.sh upload /path/to/files azure-container
