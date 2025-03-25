# Scripts & Snippets

## Overview

This repository contains a collection of scripts and snippets designed to automate various tasks across different operating systems and applications. The scripts are organized into directories based on their functionality, such as bash, batch, excel, powershell, python, and windows.

## Contents

### Bash
- **auto-update.sh**: Automates system updates and upgrades.
- **first_boot_fedora.sh**: Configures a Fedora system upon first boot.
- **init_fedora.sh**: Initializes a Fedora system with necessary packages and settings.
- **qemu_guest_agent.sh**: Installs and configures the QEMU Guest Agent for enhanced virtual machine management.
- **ssh_key.sh**: Generates SSH keys for secure remote access.

### Batch
- **gpresult_verbose.bat**: Retrieves detailed Group Policy results.
- Additional scripts in the `old` directory are deprecated or less commonly used.

### Excel
- Various VBA macros and scripts to automate tasks within Excel, such as extracting hyperlinks, managing drop-down lists, and more.
- Additional scripts in the `old` directory are deprecated or less commonly used.

### PowerShell
- **datadog-download-install.ps1**: Downloads and installs Datadog agent.
- **powershell_function_download_file.ps1**: A reusable function to download files via PowerShell.
- Additional scripts in the `old` directory are deprecated or less commonly used.

### Python
- **file_validation.py**: Validates file formats and contents.
- **github_fix_watched_repos.py**: Fixes issues with watched repositories on GitHub.
- **logger.py**: Provides logging functionality for Python applications.
- **rename_files.py**: Renames files in a specified directory based on certain criteria.
- Additional scripts in the `old` directory are deprecated or less commonly used.

### Vulnerability Fix
- Scripts to address specific vulnerabilities, such as CVE-2013-3900 and Adobe Flash uninstallation.
- Additional scripts in the `VULN Fix` directory are designed to fix various security issues.

### Windows
- Registry modification scripts to disable or enable certain features, such as DDE Auto and Windows Defender Security Center.
- Additional scripts in the `old` directory are deprecated or less commonly used.

## Usage Instructions

### Bash Scripts
To run a bash script, navigate to the `bash` directory and execute the script using the following command:
```bash
./script_name.sh
```
For example, to run `auto-update.sh`, use:
```bash
cd bash
./auto-update.sh
```

### Batch Scripts
To run a batch script, navigate to the `batch` directory and double-click the script file or execute it using the following command in Command Prompt:
```cmd
script_name.bat
```
For example, to run `gpresult_verbose.bat`, use:
```cmd
cd batch
gpresult_verbose.bat
```

### Excel Scripts
To run an Excel VBA macro, open the Excel workbook and press `Alt + F8` to access the Macro dialog. Select the desired macro and click "Run."

### PowerShell Scripts
To run a PowerShell script, navigate to the `powershell` directory and execute the script using the following command in PowerShell:
```powershell
.\script_name.ps1
```
For example, to run `datadog-download-install.ps1`, use:
```powershell
cd powershell
.\datadog-download-install.ps1
```

### Python Scripts
To run a Python script, navigate to the `python` directory and execute the script using the following command in your terminal or command prompt:
```bash
python script_name.py
```
For example, to run `file_validation.py`, use:
```bash
cd python
python file_validation.py
```

### Windows Registry Scripts
To run a registry modification script, navigate to the `windows/registry` directory and double-click the `.reg` file or execute it using the following command in Command Prompt:
```cmd
script_name.reg
```
For example, to run `disable_ddeauto.reg`, use:
```cmd
cd windows\registry
disable_ddeauto.reg
```

## Examples

### Bash Example: Auto-Update Script
The `auto-update.sh` script automates the process of updating and upgrading a Fedora system. It ensures that all packages are up-to-date and installs any necessary updates.

### Excel Example: Extract Hyperlinks Macro
The `Extract_Hyperlinks.bas` macro extracts hyperlinks from an Excel worksheet and lists them in a new sheet, making it easy to manage and review links.

### PowerShell Example: Datadog Agent Installation
The `datadog-download-install.ps1` script downloads the latest version of the Datadog agent and installs it on your system, enabling monitoring and management capabilities.

### Python Example: File Validation Script
The `file_validation.py` script checks if a file meets specific criteria, such as file type and content format. It can be used to validate user-uploaded files or ensure data integrity in automated processes.

## Troubleshooting

If you encounter issues while using the scripts, refer to the following troubleshooting tips:

- **Bash Scripts**: Ensure that the script has execute permissions. You can set this by running `chmod +x script_name.sh`.
- **Batch Scripts**: Make sure that your system is configured to run batch files. Check your system's security settings and file associations.
- **Excel Scripts**: Verify that macros are enabled in Excel. Go to "File" > "Options" > "Trust Center" > "Trust Center Settings" > "Macro Settings" and select an appropriate option.
- **PowerShell Scripts**: Ensure that PowerShell is running with the necessary permissions. You may need to run PowerShell as an administrator or adjust your execution policy using `Set-ExecutionPolicy`.
- **Python Scripts**: Make sure that Python is installed on your system and that the script is compatible with your version of Python.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](../../tags).

## Authors

- **Matt Wyen** - *Initial work* - [talltechy](https://github.com/talltechy)

See also the list of [contributors](../../contributors) who participated in this project.

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

## Acknowledgments

- **Billie Thompson** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)
- Hat tip to anyone whose code is used
- Inspiration
- etc
