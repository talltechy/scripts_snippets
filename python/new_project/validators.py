# main.py

from utils import log_message, secure_random_string
from validators import validate_email, validate_password

def main():
    log_message("Starting application...")

    # Example usage of utility functions
    random_string = secure_random_string(16)
    log_message(f"Generated secure random string: {random_string}")

    # Example usage of validation functions
    email = "example@example.com"
    password = "ExamplePassword123!"

    if validate_email(email):
        log_message(f"Email '{email}' is valid.")
    else:
        log_message(f"Email '{email}' is invalid.")

    password_validation_result = validate_password(password)
    if password_validation_result is True:
        log_message(f"Password is valid.")
    else:
        log_message(f"Password validation error: {password_validation_result}")

if __name__ == "__main__":
    main()
