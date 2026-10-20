from app.my_project import db
from app.my_project.dao.models import Users, NotificationSettings, SystemNotifications, Objects
from app.my_project.dto.schemas import users_schema, user_schema, object_schema
from sqlalchemy import text

def get_all_users():
    all_users = Users.query.all()
    
    return users_schema.dump(all_users)

def get_user_by_id(user_id):

    user = Users.query.get_or_404(user_id) 
    return user_schema.dump(user)

def create_user(data):
    
    new_user = user_schema.load(data, session=db.session)
    
    db.session.add(new_user)
    
    db.session.commit()
    
    return user_schema.dump(new_user)

def update_user(user_id, data):
    
    user = Users.query.get_or_404(user_id)
    
    user = user_schema.load(data, instance=user, session=db.session, partial=True)
    db.session.add(user)
    db.session.commit()
    return user_schema.dump(user)

def delete_user(user_id):
    user = Users.query.get_or_404(user_id)

    NotificationSettings.query.filter_by(user_id=user_id).delete()

    SystemNotifications.query.filter_by(user_id=user_id).delete()

    db.session.delete(user)

    db.session.commit()

    return "", 204

def get_object_by_id(object_id):
    obj = Objects.query.get_or_404(object_id)

    return object_schema.dump(obj)

def get_users_for_object(object_id):
    obj = Objects.query.get_or_404(object_id)

    users_list = obj.users_with_access

    return users_schema.dump(users_list)

def add_object_contact_via_sp(object_id, contact_person, contact_phone, contact_role):
    """Викликає збережену процедуру MySQL для додавання нового контакту об'єкта."""
    
    sql_call = text("CALL sp_add_object_contact(:p_object_id, :p_contact_person, :p_contact_phone, :p_contact_role)")
    
    db.session.execute(sql_call, {
        'p_object_id': object_id,
        'p_contact_person': contact_person,
        'p_contact_phone': contact_phone,
        'p_contact_role': contact_role
    })
    
    db.session.commit()
    
    return {"message": "Контакт успішно додано через збережену процедуру."}

def grant_object_access_via_sp(username, object_name, access_level):
    """
    Викликає збережену процедуру MySQL для надання користувачу доступу до об'єкта 
    за їхніми іменами (M:M зв'язок).
    """
    
    sql_call = text("CALL sp_grant_object_access(:p_username, :p_object_name, :p_access_level)")
    
    db.session.execute(sql_call, {
        'p_username': username,
        'p_object_name': object_name,
        'p_access_level': access_level
    })
    
    db.session.commit()
    
    return {"message": f"Доступ рівня {access_level} успішно надано користувачу '{username}' до об'єкта '{object_name}'."}

def insert_ten_noname_contacts_sp():
    """
    Викликає збережену процедуру MySQL, яка вставляє 10 тестових записів
    у таблицю Object_Contacts (імітація пакету).
    """
    
    sql_call = text("CALL sp_insert_ten_noname_contacts()")
    
    db.session.execute(sql_call)
    
    db.session.commit()
    
    return {"message": "Успішно додано 10 тестових контактів Noname у таблицю Object_Contacts."}

def get_user_id_statistic_sp():
    """
    Викликає збережену процедуру MySQL, яка, своєю чергою, викликає 
    користувацьку функцію (UDF) для отримання агрегованої статистики (SUM ID).
    """
    
    sql_call = text("CALL sp_show_total_user_ids()")
    
    # *** ВИПРАВЛЕННЯ: Використовуємо контекстний менеджер для коректного закриття результату ***
    with db.session.execute(sql_call) as result_cursor:
        result = result_cursor.fetchone()
    # result_cursor автоматично закривається тут, очищуючи з'єднання.
    
    # db.session.commit() - не потрібно для GET-запиту, але не завадить

    if result:
        return {
            'statistic_name': result[0],
            'statistic_result': result[1]
        }
    
    return {"message": "Не вдалося отримати статистику."}

def split_users_data_sp():
    
    sql_call = text("CALL sp_split_users_data()")
    
    # *** ВИПРАВЛЕННЯ: Використовуємо контекстний менеджер для коректного закриття результату ***
    with db.session.execute(sql_call) as result_cursor:
        result = result_cursor.fetchone() # Зчитуємо потрібний рядок
    # result_cursor автоматично закривається тут, очищуючи з'єднання.
    
    # Тепер COMMIT може бути виконаний без помилки "out of sync"
    db.session.commit() 
    
    if result:
        return {
            "table_a": result[0],
            "table_b": result[1],
            "status": result[2]
        }
    
    return {"message": "Не вдалося запустити процедуру розподілу даних."}
