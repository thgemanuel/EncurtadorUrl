from datetime import datetime, timedelta
from math import trunc
from select import select
from bson.objectid import ObjectId
from typing import Union
import pymongo
import urllib
import jwt
import hashlib


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
    return True if 'username' in input \
        and 'url_original' in input\
        else False

def salvaUrlEncurtada(username, url_original, url_encurtada):
    #Pegando timestamp da requisição
    datetime_now = datetime.now()
    timestamp = datetime.timestamp(datetime_now)

    #Truncando timestamp (Transforma double em int)
    timestamp = trunc(timestamp)

    #Selecionar database
    event_column = selected_database['UrlsEncurtadas']

    event_obj = {
        'user_id': username,
        'url_original': url_original,
        'url_encurtada': f"https://{url_encurtada}",
        'timestamp': timestamp
    }

    try:
        #Insere no Banco de Dados
        event_column.insert_one(event_obj)
        return True
    except:
        return False


def teste_url(url_encurtada):
    url_column = selected_database['UrlsEncurtadas']
    
    user_row_result = url_column.find_one({'user_id': '-','url_encurtada': url_encurtada})

    if user_row_result is not None:
        return True

    return False

def generate_message_to_request(url_encurtada) -> dict:
    message_to_request = {
        "message": "Url encurtada!",
        "url_encurtada": f"https://{url_encurtada}",
    }
    return message_to_request

def encurtaUrl(username, url_original) -> Union[dict, int]:
   
    hash_object = hashlib.sha256(url_original.encode('utf-8'))
    url_encurtada = hash_object.hexdigest()[:7]
    url_ja_encurtada = teste_url(url_encurtada)
    message_to_request = generate_message_to_request(url_encurtada)

    if url_ja_encurtada:
        return message_to_request,200

    salvaUrlEncurtada(username, url_original, url_encurtada)
    return message_to_request,201


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
        has_user_and_url = check_input(body_request)
        if has_user_and_url:
            username = body_request.get("username")
            url_original = body_request.get("url_original")
            message_to_request, status_code = encurtaUrl(username, url_original)
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
