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
