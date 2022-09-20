import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUrlOriginal(String url) async {
  final queryParams = <String, String>{'url_encurtada': url};

  final uriDF = Uri.https(
      'southamerica-east1-encurtador-url-thg.cloudfunctions.net',
      '/geturloriginal',
      queryParams);

  final response = await http.get(
    uriDF,
    headers: <String, String>{
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json'
    },
  );

  Map<String, dynamic> urls_information = {
    'status_code': response.statusCode,
    'body':jsonDecode(response.body),
  } ;
 
  return urls_information;
}
