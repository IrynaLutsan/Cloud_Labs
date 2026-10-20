import os

class Config:
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # Читаємо параметри зі змінних середовища. 
    # Якщо змінна не задана, береться дефолтне значення після коми.
    DB_USER = os.getenv("DB_USER", "app_user")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "app_password")
    DB_HOST = os.getenv("DB_HOST", "db:3306")
    DB_NAME = os.getenv("DB_NAME", "Security_system")

    # Формуємо рядок підключення для SQLAlchemy з драйвером pymysql
    SQLALCHEMY_DATABASE_URI = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"