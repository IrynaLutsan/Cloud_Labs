from app.my_project import db

# "стикувальна таблиця" user_object_access
user_object_access = db.Table('user_object_access',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id'), primary_key=True),
    db.Column('object_id', db.Integer, db.ForeignKey('objects.id'), primary_key=True),
    db.Column('access_level', db.Integer, default=1)
)

class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(45), unique=True, nullable=False)
    email = db.Column(db.String(87), unique=True, nullable=False)
    password_hash = db.Column(db.String(45), nullable=False)
    full_name = db.Column(db.String(160), nullable=False)
    phone = db.Column(db.String(30), nullable=False)
    role = db.Column(db.String(60), default='user')
    is_active = db.Column(db.Boolean, default=True)


    objects = db.relationship('Objects', secondary=user_object_access,
                              back_populates='users_with_access')
    
 
    system_notifications = db.relationship('SystemNotifications', back_populates='user')
    notification_settings = db.relationship('NotificationSettings', back_populates='user')


class Objects(db.Model):
    __tablename__ = 'objects'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(45), nullable=False)
    address = db.Column(db.String(45), nullable=False)
    description = db.Column(db.String(100))

   
    users_with_access = db.relationship('Users', secondary=user_object_access,
                                        back_populates='objects')
    
    
    zones = db.relationship('Zones', back_populates='object')
    system_notifications = db.relationship('SystemNotifications', back_populates='object')
    notification_settings = db.relationship('NotificationSettings', back_populates='object')

class SensorTypes(db.Model):
    __tablename__ = 'sensor_types'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(150))
    
    sensors = db.relationship('Sensors', back_populates='sensor_type')

class Zones(db.Model):
    __tablename__ = 'zones'
    id = db.Column(db.Integer, primary_key=True)
    object_id = db.Column(db.Integer, db.ForeignKey('objects.id'), nullable=False)
    name = db.Column(db.String(45), nullable=False)
    description = db.Column(db.String(100))
    access_level = db.Column(db.Integer, nullable=False)

    object = db.relationship('Objects', back_populates='zones')
    rooms = db.relationship('Rooms', back_populates='zone')

class Rooms(db.Model):
    __tablename__ = 'rooms'
    id = db.Column(db.Integer, primary_key=True)
    zone_id = db.Column(db.Integer, db.ForeignKey('zones.id'), nullable=False)
    name = db.Column(db.String(70), nullable=False)
    room_type = db.Column(db.String(45))
    floor_number = db.Column(db.Integer, nullable=False)
    created = db.Column(db.DateTime, default=db.func.current_timestamp())

    zone = db.relationship('Zones', back_populates='rooms')
    sensors = db.relationship('Sensors', back_populates='room')

class Sensors(db.Model):
    __tablename__ = 'sensors'
    id = db.Column(db.Integer, primary_key=True)
    sensor_type_id = db.Column(db.Integer, db.ForeignKey('sensor_types.id'), nullable=False)
    room_id = db.Column(db.Integer, db.ForeignKey('rooms.id'), nullable=False)
    name = db.Column(db.String(30), nullable=False)
    last_maintenance = db.Column(db.Date)

    sensor_type = db.relationship('SensorTypes', back_populates='sensors')
    room = db.relationship('Rooms', back_populates='sensors')
    settings = db.relationship('SensorSettings', back_populates='sensor')
    notifications = db.relationship('SensorNotifications', back_populates='sensor')

class SensorSettings(db.Model):
    __tablename__ = 'sensor_settings'
    id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.id'), nullable=False)
    parameter_name = db.Column(db.String(45), nullable=False)
    parameter_value = db.Column(db.String(100), nullable=False)

    sensor = db.relationship('Sensors', back_populates='settings')

class SensorNotifications(db.Model):
    __tablename__ = 'sensor_notifications'
    id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.id'), nullable=False)
    notification_type = db.Column(db.String(45), nullable=False)
    severity = db.Column(db.Integer, nullable=False)
    message = db.Column(db.String(100), nullable=False)
    created = db.Column(db.DateTime, default=db.func.current_timestamp())

    sensor = db.relationship('Sensors', back_populates='notifications')

class NotificationSettings(db.Model):
    __tablename__ = 'notification_settings'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    object_id = db.Column(db.Integer, db.ForeignKey('objects.id'), nullable=False)
    notification_type = db.Column(db.String(50), nullable=False)
    delivery_method = db.Column(db.String(45), nullable=False)
    is_enabled = db.Column(db.Boolean, nullable=False)
    min_severity = db.Column(db.Integer, default=1, nullable=False)

    user = db.relationship('Users', back_populates='notification_settings')
    object = db.relationship('Objects', back_populates='notification_settings')

class SystemNotifications(db.Model):
    __tablename__ = 'system_notifications'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    object_id = db.Column(db.Integer, db.ForeignKey('objects.id'), nullable=False)
    title = db.Column(db.String(45), nullable=False)
    message = db.Column(db.String(45), nullable=False)
    notification_type = db.Column(db.String(45), nullable=False)
    severity = db.Column(db.Integer, nullable=False)
    delivery_method = db.Column(db.String(45))
    delivery_status = db.Column(db.String(45))
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp(), nullable=False)

    user = db.relationship('Users', back_populates='system_notifications')
    object = db.relationship('Objects', back_populates='system_notifications')
    
class ObjectContacts(db.Model):
    __tablename__ = 'object_contacts'
    id = db.Column(db.Integer, primary_key=True)
    
    # ми додаємо ForeignKey, хоча MySQL не має його фізично.
    # Це потрібно, щоб SQLAlchemy коректно відображав зв'язок 1:M.
    object_id = db.Column(db.Integer, db.ForeignKey('objects.id'), nullable=False)
    
    contact_person = db.Column(db.String(100), nullable=False)
    contact_phone = db.Column(db.String(30))
    contact_role = db.Column(db.String(50))

    # Зв'язок з батьківською таблицею Objects
    object_rel = db.relationship('Objects', backref='contacts')