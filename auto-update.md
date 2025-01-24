# Auto-Update Script for Alpine Linux

## Overview

The `auto-update.sh` script is designed to automate the process of updating and upgrading packages on an Alpine Linux system. It includes error handling, logging, and email notifications to ensure that each step is completed successfully and to provide detailed information about the process. The script also checks if it is running on Alpine Linux and exits if it is not. Additionally, the script can auto-generate the `.env` file if it doesn't exist and defaults to sending an email to the root user locally if no email is configured.

## Usage

### Setting the Email Environment Variable

#### Using a Configuration File

1. **Create a configuration file:**

   If the configuration file `/etc/auto-update.env` does not exist, the script will automatically create it with the following default content:

   ```sh
   AUTO_UPDATE_EMAIL=""
   ENABLE_SMTP="false"

   # Optional settings for secure email relay
   SMTP_SERVER="smtp.example.com"
   SMTP_PORT="587"
   SMTP_USER="your-smtp-username"
   SMTP_PASSWORD_ENCRYPTED="your-encrypted-smtp-password"
   ```

2. **Secure the configuration file:**

   Ensure the configuration file has restricted permissions:

   ```sh
   chmod 600 /etc/auto-update.env
   ```

3. **Encrypt the SMTP password:**

   Use `gpg` to encrypt your SMTP password and store the encrypted password in the configuration file:

   ```sh
   echo "your-smtp-password" | gpg --symmetric --cipher-algo AES256
   ```

   Copy the output and set it as the value for `SMTP_PASSWORD_ENCRYPTED` in the configuration file.

4. **Store the GPG passphrase in `pass`:**

   Use `pass` to securely store the GPG passphrase:

   ```sh
   pass insert auto-update/gpg-passphrase
   ```

### Running the Script

1. **Make the script executable:**

   ```sh
   chmod +x /usr/local/bin/auto-update.sh
   ```

2. **Run the script:**

   ```sh
   /usr/local/bin/auto-update.sh
   ```

## Script Details

- **Logging:**
  The script logs each step to `/var/log/auto-update.log`. This log file contains timestamps and messages indicating the success or failure of each operation. The log file has restricted permissions to ensure security.

- **Error Handling:**
  If any step fails (updating the package list, upgrading packages, or cleaning the cache), the script logs the failure, sends an email notification, and exits with a non-zero status code.

- **Email Notification:**
  The script sends an email notification with the log file content to a specified email address upon completion. The email address is set using the `AUTO_UPDATE_EMAIL` environment variable from the configuration file. If optional SMTP settings are provided and valid, and `ENABLE_SMTP` is set to `true`, the script uses them to send the email via a secure email relay. If no email address is configured or the SMTP settings are invalid, the script logs a warning and skips the email notification. Ensure that `msmtp` or a similar secure email sending tool is installed and configured on your system.

- **OS Check:**
  The script checks if it is running on Alpine Linux by looking for the `/etc/alpine-release` file. If the file is not found, the script logs a message and exits.

- **Auto-Generate .env File:**
  If the `/etc/auto-update.env` file does not exist, the script will create it with default values and set the appropriate permissions.

- **Input Validation:**
  The script validates the email address and SMTP settings to ensure they contain expected values before proceeding.

- **GPG Encryption:**
  The script uses `gpg` to decrypt the SMTP password before sending an email.

- **Pass Integration:**
  The script retrieves the GPG passphrase from `pass` before decrypting the SMTP password.

## Script Steps

1. **Check the operating system:**
   The script verifies that it is running on Alpine Linux.

2. **Auto-generate the .env file:**
   If the `/etc/auto-update.env` file does not exist, the script creates it with default values.

3. **Validate input:**
   The script validates the email address and SMTP settings.

4. **Update the package list:**
   The script runs `apk update` to refresh the list of available packages.

5. **Upgrade all installed packages:**
   The script runs `apk upgrade` to upgrade all installed packages to their latest versions.

6. **Clean up the package cache:**
   The script runs `apk cache clean` to remove any cached package files that are no longer needed.

7. **Send email notification:**
   The script sends an email notification with the log file content upon completion, if the SMTP settings are valid and `ENABLE_SMTP` is set to `true`.

## Example Log Output

Here is an example of what the log file might contain:

```log
2023-10-01 12:00:00 - Running on Alpine Linux.
2023-10-01 12:00:00 - Starting package list update...
2023-10-01 12:00:05 - Package list update completed successfully.
2023-10-01 12:00:05 - Starting package upgrade...
2023-10-01 12:05:00 - Package upgrade completed successfully.
2023-10-01 12:05:00 - Cleaning up package cache...
2023-10-01 12:05:02 - Package cache cleaned successfully.
2023-10-01 12:05:02 - System update and upgrade completed.
2023-10-01 12:05:02 - SMTP settings are not valid or SMTP is disabled. Skipping email notification.
```

## Notes

- Ensure that you have the necessary permissions to write to `/var/log/auto-update.log`.
- You may need to run the script as root or with `sudo` to perform system updates and upgrades.
- Set the `AUTO_UPDATE_EMAIL` and `ENABLE_SMTP` environment variables in the configuration file.
- Ensure that `msmtp` or a similar secure email sending tool is installed and configured on your system.
- Use `gpg` to encrypt your SMTP password and store the GPG passphrase in `pass`.
