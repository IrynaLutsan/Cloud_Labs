from flask import request, jsonify
from __main__ import app
from app.my_project.service import services 

# --- CRUD для Users ---

@app.route('/users', methods=['GET'])
def get_all_users_controller():
    
    users = services.get_all_users()
    return jsonify(users) 

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user_by_id_controller(user_id):
    
    user = services.get_user_by_id(user_id)
    return jsonify(user)

@app.route('/users', methods=['POST'])
def create_user_controller():
    
    data = request.json 
    user = services.create_user(data)
    return jsonify(user), 201 

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user_controller(user_id):
    
    data = request.json
    user = services.update_user(user_id, data)
    return jsonify(user)

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user_controller(user_id):
    
    response, status_code = services.delete_user(user_id)
    return response, status_code


@app.route('/objects/<int:object_id>', methods=['GET'])
def get_object_by_id_controller(object_id):
    
    obj_with_zones = services.get_object_by_id(object_id)

    return jsonify(obj_with_zones)

@app.route('/objects/<int:object_id>/users', methods=['GET'])
def get_users_for_object_controller(object_id):
    
    users_list = services.get_users_for_object(object_id)

    return jsonify(users_list)

@app.route('/objects/contacts', methods=['POST'])
def create_object_contact_controller():
    data = request.json
    
    result = services.add_object_contact_via_sp(
        data['object_id'], 
        data['contact_person'], 
        data['contact_phone'], 
        data['contact_role']
    )
    return jsonify(result), 201

# --- Надання доступу (M:M) за допомогою Збереженої Процедури ---
@app.route('/access', methods=['POST'])
def grant_object_access_controller():
    
    data = request.json
    
    result = services.grant_object_access_via_sp(
        data['username'], 
        data['object_name'], 
        data['access_level']
    )
    
    return jsonify(result), 200

@app.route('/contacts/generate-test-data', methods=['POST'])
def insert_ten_noname_contacts_controller():
    
    result = services.insert_ten_noname_contacts_sp()
    
    return jsonify(result), 201

# --- Отримання статистики за допомогою Збереженої Процедури та UDF ---
@app.route('/users/statistics', methods=['GET'])
def get_user_id_statistic_controller():
    
    result = services.get_user_id_statistic_sp()

    return jsonify(result), 200

# --- Процедура з Курсором: Динамічний розподіл даних ---
@app.route('/users/split-data', methods=['POST'])
def split_users_data_controller():
    
    result = services.split_users_data_sp()
    
    return jsonify(result), 201
