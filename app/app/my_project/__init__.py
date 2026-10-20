from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

# екземпляри, які будуть "живити" наш DAO та DTO
db = SQLAlchemy()
ma = Marshmallow()