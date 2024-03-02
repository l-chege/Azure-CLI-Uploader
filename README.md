# Cloud CLI Uploader

This capstone project is an integral part of the [Learn to Cloud](https://learntocloud.guide/) guide. The project aligns with the learning objectives outlined in the guide, providing hands-on experience with cloud technologies. 

## Features

1. **Direct File Upload:**
   - Upload multiple files directly to Azure Blob storage containers.

2. **Generate Shareable Links:**
   - Easily generate links for uploaded files, making sharing a breeze.

3. **Simple Installation:**
   - Follow the straightforward installation process to get started.

## Prerequisites and Setup

Before using Cloud CLI Uploader, ensure you have the following:

- A chosen cloud provider (Microsoft Azure is used in this project).
- An active Azure subscription.
- Azure CLI tool installed and authenticated.
- A Bash environment available on Linux/Unix, WSL (Windows Subsystem for Linux), or macOS.

Setup your Azure resources - checkout the [documentation](https://github.com/l-chege/CLI-Uploader/tree/master/azuresetup) I wrote giving a detailed step by step guide. 

## Installation and Usage

Follow these steps to install and use Cloud CLI Uploader:

1. Clone the repository to your local machine.
   ```bash
   git clone https://github.com/your-username/CLI-Uploader.git
2. Navigate to project directory
   ```bash
   cd CLI-Uploader
3. Run the installation script
   ```bash
   ./installscript.sh
4. After installation, use the following command to upload files
- Upload a file
   ```bash
   ./cliscript.sh <azure container> /path/to/file

- Upload multiple files
   ```bash
   ./cliscript.sh <azure container> /path/to/file1 /path/to/file2 ...