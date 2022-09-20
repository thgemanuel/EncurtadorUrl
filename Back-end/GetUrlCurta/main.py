from typing import Union
import pymongo
import urllib

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
    return True if 'url_encurtada' in input\
        else False

def buscaUrl(url_encurtada):
    urls_column = selected_database['UrlsEncurtadas']
    try:
        url = urls_column.find_one({'url_encurtada': url_encurtada})
        return url
    except:
        return None

def obtemUrlOriginal(url_encurtada) -> Union[dict, int]:
    url_original = buscaUrl(url_encurtada)
    if url_original is not None:
        message_to_request = {
            "message": "Url original encontrada!",
            "url_original": url_original["url_original"],
        }
        return message_to_request,200
    else: 
        message_to_request = {
            "message": "Url original nao encontrada!",
            "url_original": "-",
        }
        return message_to_request,404

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
            url_encurtada = request.args.get("url_encurtada")
            message_to_request, status_code = obtemUrlOriginal(url_encurtada)
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
