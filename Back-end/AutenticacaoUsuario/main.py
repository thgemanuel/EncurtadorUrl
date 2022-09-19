
import pymongo
import urllib

secret_key = 'Wh$hOPdRhXyypJvVQ0%HRnM#wCD$7vRL2aORTFOhsS%DRycvhp'

# Definições para conexão com o banco de dados MongoDB.
mongo_cluster_password = urllib.parse.quote('senha123')
database = 'EncurtadorUrl'

connection_string = f"mongodb://encurtador:{mongo_cluster_password}@ac-najnv2m-shard-00-00.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-01.fwwgsf4.mongodb.net:27017,ac-najnv2m-shard-00-02.fwwgsf4.mongodb.net:27017/?ssl=true&replicaSet=atlas-11dfhp-shard-0&authSource=admin&retryWrites=true&w=majority" 

try:
    client = pymongo.MongoClient(connection_string,)
    client.server_info() # force connection on a request as the
                         # connect=True parameter of MongoClient seems
                         # to be useless h      
    print("foi")
except pymongo.errors.ServerSelectionTimeoutError as err:
    # do whatever you need
    print("n foi")
    
    print(err)