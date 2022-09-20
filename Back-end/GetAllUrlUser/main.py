from typing import Union
import pymongo
import urllib
import jwt
from flask import request
from functools import wraps

secret_key = 'Wh$hOPdRhXyypJvVQ0%HRnM#wCD$7vRL2aORTFOhsS%DRycvhp'

# Definições para conexão com o banco de dados MongoDB.
mongo_cluster_password = urllib.parse.quote('senha123')
database = 'EncurtadorUrl'

connection_string = f"mongodb://encurtador:{mongo_cluster_password}@ac-najnv2m-shard-00-00.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-01.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-02.fwwgsf4.mongodb.net:27017/?ssl=true&replicaSet=atlas-11dfhp-shard-0&authSource=admin&retryWrites=true&w=majority" 

mongo_client = pymongo.MongoClient(connection_string)
selected_database = mongo_client[database]

#Checa se o parâmetro input possui todos os seguintes atributos.
def check_input(input):
    """
    Checks the input
    """
    return True if 'token' in input\
        else False

def buscaUrlsUser(username):
    urls_column = selected_database['UrlsEncurtadas']
    try:
        urls = urls_column.find({'user_id': username})
        return urls
    except:
        return None

def obtemUrlsUser(username) -> Union[dict, int]:
    urls = buscaUrlsUser(username)
    if urls is not None:
        listUrl = []
        for url in urls:
            new_url = {
                'url_original': url['url_original'],
                'url_encurtada': url['url_encurtada'],
                'timestamp': url['timestamp'],
            }
            listUrl.append(new_url)

        message_to_request = {
            "message": "Urls encontradas!",
            "urls": listUrl,
        }
        return message_to_request,200
    else: 
        message_to_request = {
            "message": "Urls nao encontradas!",
            "urls": "-",
        }
        return message_to_request,404

def check_user(username):
    user_column = selected_database['Usuarios']
    try:
        user = user_column.find_one({"_id": username})
        if user is None:
            return False
        else:
            return True 
    except:
        return False


def token_required(f):
    @wraps(f)
    def decorated(self, *args, **kwargs):
        request_data = request.args
        if not('token' in request_data):
            return ({'message':'Token missing!'}, 403)
        token = request_data['token']
        try:
            data = jwt.decode(token, key=secret_key, algorithms="HS256")
            if not check_user(data['user']):
                return ({'message': 'This user doesn’t have permission'}, 401) 
        except :
            return ({'message': 'Token is invalid'}, 403)
        return f(self,*args, **kwargs)
    return decorated

@token_required
def main(request):

    message_to_request: dict
    status_code: int
    request_method = request.method
    headers = {
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'access-control-allow-headers,Access-Control-Allow-Origin,Content-Type',
            'Access-Control-Max-Age': '3600',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Request-Headers': '*',
        }
        
    
    if request.method == 'OPTIONS':
        return ('', 200, headers)


    if request_method == "GET":
        has_url = check_input(request.args)
        if has_url:
            user_info = jwt.decode(request.args['token'], key=secret_key, algorithms="HS256")
            username = user_info['user']
            message_to_request, status_code = obtemUrlsUser(username)
            # print(type(message_to_request))
            # print(status_code)
            return message_to_request, status_code,headers
        else:
            return ({
                "message": "Bad body"
            }, 400)
    else:
        return ({
            "message": "Method not allowed."
        }, 405)
