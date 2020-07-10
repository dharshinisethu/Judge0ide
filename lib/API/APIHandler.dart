import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:judge0_IDE/Model/LanguagesModel.dart';
import 'package:judge0_IDE/Model/OutputModel.dart';


class APIHandler{


  static String judge0ApiKey = '667ba63409msh2c10406af988732p12c5c5jsn61b98bd59443';

  static Future<List<LanguagesModel>> getLanguages() async{

    String baseURL = 'https://judge0.p.rapidapi.com/languages';

    var headers = {
		"x-rapidapi-host": "judge0.p.rapidapi.com",
		"x-rapidapi-key": judge0ApiKey
    };

    Http.Response response = await Http.get(baseURL,headers: headers);

      List body = jsonDecode(response.body);

      List<LanguagesModel> languagesList = [];

      body.forEach((element) {
       languagesList.add( LanguagesModel.fromMap(element) );
      });

    return languagesList ;
  }

  static Future<String> createSubmission(String sourceCode , int languageID) async{

    String baseURL = 'https://judge0.p.rapidapi.com/submissions';

    var headers = {
      "x-rapidapi-host": "judge0.p.rapidapi.com",
      "x-rapidapi-key": judge0ApiKey,
    };

    var requestBody = {
      "language_id": languageID.toString(),
      "source_code": sourceCode,
    };

    Http.Response response = await Http.post(baseURL,headers: headers,body: requestBody);

    Map body = jsonDecode(response.body);

    String token = body['token'];


    return token ;
  }


  static Future<OutPutModel> getSubmission(String token) async{

    String baseURL = 'https://judge0.p.rapidapi.com/submissions/$token';

    var headers = {
      "x-rapidapi-host": "judge0.p.rapidapi.com",
      "x-rapidapi-key": judge0ApiKey,
    };

    Http.Response response = await Http.get(baseURL,headers: headers);

    var body = jsonDecode(response.body);

    OutPutModel output = OutPutModel.fromMap(body);

    return output ;
  }


}