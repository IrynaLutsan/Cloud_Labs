from flask import Flask
from app.config.config import Config 
from app.my_project import db, ma     

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)
ma.init_app(app)

# ВАЖЛИВО: Імпортуємо контролери тут, щоб вони зареєстрували маршрути в app
with app.app_context():
    from app.my_project.dao import models  
    from app.my_project.controller import controllers 

if __name__ == '__main__':
    # Використовуйте порт 5001, щоб уникнути конфліктів macOS
    app.run(debug=True, port=5001)