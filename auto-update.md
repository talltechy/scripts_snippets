# Auto-Update Script for Alpine Linux

## Overview

The `auto-update.sh` script is designed to automate the process of updating and upgrading packages on an Alpine Linux system. It includes error handling and logging to ensure that each step is completed successfully and to provide detailed information about the process.

## Usage

1. **Make the script executable:**

   ```sh
   chmod +x /Users/mattwyen/github/scripts_snippets/bash/auto-update.sh
   ```

2. **Run the script:**

   ```sh
   /Users/mattwyen/github/scripts_snippets/bash/auto-update.sh
   ```

## Script Details

- **Logging:**
  The script logs each step to `/var/log/auto-update.log`. This log file contains timestamps and messages indicating the success or failure of each operation.

- **Error Handling:**
  If any step fails (updating the package list, upgrading packages, or cleaning the cache), the script logs the failure and exits with a non-zero status code.

## Script Steps

1. **Update the package list:**
   The script runs `apk update` to refresh the list of available packages.

2. **Upgrade all installed packages:**
   The script runs `apk upgrade` to upgrade all installed packages to their latest versions.

3. **Clean up the package cache:**
   The script runs `apk cache clean` to remove any cached package files that are no longer needed.

## Example Log Output

Here is an example of what the log file might contain:

```log
2023-10-01 12:00:00 - Starting package list update...
2023-10-01 12:00:05 - Package list update completed successfully.
2023-10-01 12:00:05 - Starting package upgrade...
2023-10-01 12:05:00 - Package upgrade completed successfully.
2023-10-01 12:05:00 - Cleaning up package cache...
2023-10-01 12:05:02 - Package cache cleaned successfully.
2023-10-01 12:05:02 - System update and upgrade completed.
```

## Notes

- Ensure that you have the necessary permissions to write to `/var/log/auto-update.log`.
- You may need to run the script as root or with `sudo` to perform system updates and upgrades.
