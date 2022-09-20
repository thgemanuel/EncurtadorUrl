from datetime import datetime, timedelta
from select import select
from bson.objectid import ObjectId
from typing import Union
import pymongo
import urllib
import jwt

secret_key = 'Wh$hOPdRhXyypJvVQ0%HRnM#wCD$7vRL2aORTFOhsS%DRycvhp'

# Definições para conexão com o banco de dados MongoDB.
mongo_cluster_password = urllib.parse.quote('senha123')
database = 'EncurtadorUrl'

connection_string = f"mongodb://encurtador:{mongo_cluster_password}@ac-najnv2m-shard-00-00.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-01.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-02.fwwgsf4.mongodb.net:27017/?ssl=true&replicaSet=atlas-11dfhp-shard-0&authSource=admin&retryWrites=true&w=majority" 

mongo_client = pymongo.MongoClient(connection_string)

#Checa se o parâmetro input possui todos os seguintes atributos.
def check_input(input):
    """
    Checks the input
    """
    return True if 'username' in input \
        and 'password' in input\
        else False

def get_user_info(username):
    selected_database = mongo_client[database]

    user_column = selected_database['Usuarios']
    
    user_row_result = user_column.find_one({'_id': username}, {'password': 1, 'email': 1,'name': 1, 'profile_picture': 1})

    return user_row_result

def generate_message_to_request(user_info, token) -> dict:
    message_to_request = {
        "message": "User authenticated!",
        "username": user_info.get("_id"),
        "name": user_info.get("name"),
        "profile_picture": user_info.get("profile_picture"),
        "token":  token,
    }
    return message_to_request

def check_password(user_pw, password):
    if(user_pw == password):
        return True
    
    # password_encoded = password.encode("UTF-8")
    # is_a_valid_password = bcrypt.checkpw(password_encoded, user_pw)
    # return is_a_valid_password
    return False

def login(username, password) -> Union[dict, int]:
    user_db_info = get_user_info(username)
    message_to_request = {
        'message': 'User not authorized or not exist!',
    }
    status_code = 401
    if user_db_info is not None:
        user_password_in_db = user_db_info.get("password")
        is_a_valid_password = check_password(
            user_pw=user_password_in_db,
            password=password
        )
        # verificando se a senha esta correta 
        if is_a_valid_password:
            one_day_foward = timedelta(hours=24)
            json_web_token = jwt.encode({'user': username, 'exp': datetime.utcnow()
                                         + one_day_foward}, secret_key)
            message_to_request = \
                generate_message_to_request(
                    user_info=user_db_info, token=json_web_token)
            status_code = 200
        else:
            pass
    return message_to_request, status_code

def main(request):

    message_to_request: dict
    status_code: int
    request_method = request.method
    headers = {
            'Access-Control-Allow-Methods': 'POST',
            'Access-Control-Allow-Headers': 'access-control-allow-headers,Access-Control-Allow-Origin,Content-Type',
            'Access-Control-Max-Age': '3600',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Request-Headers': '*',
        }
        
    
    if request.method == 'OPTIONS':
        return ('', 200, headers)


    if request_method == "POST":
        body_request = request.get_json()
        has_user_and_pw = check_input(body_request)
        if has_user_and_pw:
            username = body_request.get("username")
            password = body_request.get("password")
            message_to_request, status_code = login(username, password)
            print(type(message_to_request))
            print(status_code)
            return message_to_request, status_code,headers
        else:
            return ({
                "message": "Bad body"
            }, 400)
    else:
        return ({
            "message": "Method not allowed."
        }, 405)
