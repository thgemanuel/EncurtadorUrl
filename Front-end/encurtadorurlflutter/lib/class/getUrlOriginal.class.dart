import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUrlOriginal(String url) async {
  // final queryParams = <String, String>{'token': token};

  // final uriDF = Uri.https(
  //     'southamerica-east1-encurtador-url-thg.cloudfunctions.net',
  //     '/geturlsuser',
  //     queryParams);

  final response = await http.get(
    Uri.parse('http://127.0.0.1:2020?url_encurtada='+ url),
    // uriDF,
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
