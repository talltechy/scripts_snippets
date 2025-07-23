# utils.py

def log_message(message: str) -> None:
    """
    Logs a message with a timestamp.

    Args:
        message (str): The message to log.
    """
    import datetime
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{timestamp} - {message}")

def secure_random_string(length: int) -> str:
    """
    Generates a secure random string of the specified length.

    Args:
        length (int): The length of the random string to generate.

    Returns:
        str: A secure random string.
    """
    import secrets
    import string
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(secrets.choice(characters) for _ in range(length))
