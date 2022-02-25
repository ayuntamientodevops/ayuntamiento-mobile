import 'dart:convert';
import 'dart:io';

import 'package:asdn/src/share_prefs/preferences_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CardService {
  final _dio = new Dio();

  final String _baseUrl = dotenv.env['BASE_URL'];
  String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));
  PreferenceStorage preferenceStorage = PreferenceStorage();


  Future<String> getIdempotencyKey(String urlCarnet) async {

  final resp = await this._dio.post(
       urlCarnet + "/api/payment/idenpotency-keys",
      options: Options(
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      followRedirects: false,
      validateStatus: (status) {
        return status < 600;
      },
    )
  );
  if (resp.statusCode >= 200 && resp.statusCode < 250) {
    String ikey = resp.toString().replaceAll("ikey:", "");
    return ikey;
  }
  return null;
 }
  String cardHide(card) {
    final hideNum = [];
    for(int i = 0; i < card.length; i++){
      if(i < card.length-4){
        hideNum.add("*");
      }else{
        hideNum.add(card[i]);
      }
    }
    return hideNum.join("");
  }
  Future<Response> sendDataLogCard(Map<String, dynamic> card) async{
    final currentUser = preferenceStorage.getValue(key: "currentUser");
    final id_user = json.decode(currentUser);

    Map<String, String> params = {
      "user_name": "name",
      "user_created": id_user["id"]
    };
      for(var i =0; i < card.length; i++) {
        card["card-number"] = cardHide(card["card-number"]);
        card.addAll(params);
      }

      final resp = await this._dio.post(
       _baseUrl + "/CarnetWebServer/insertlogcard",
       options: Options(
         headers: {
           HttpHeaders.contentTypeHeader: "application/json",
           HttpHeaders.authorizationHeader: basicAuth,
           "X-API-KEY": dotenv.env['X-API-KEY']
         },
         followRedirects: false,
         validateStatus: (status) {
           return status < 600;
         },
       ),
      data: card,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 250) {
      return resp;
    }
    return null;
  }
  Future<Response> sendDataCarnet(Map<String, dynamic> dataCard, String urlCarnet) async {

    final resp = await this._dio.post(
      urlCarnet + "/api/payment/transactions/sales",
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json"
        },
        followRedirects: false,
        validateStatus: (status) {
          return status < 600;
        },
      ),
      data: dataCard,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 250) {
      this.sendDataLogCard(dataCard);
      return resp;
    }
    return null;
  }

  Future<Map<String, dynamic>> getMessageCode(String id) async {
      final resp = await this._dio.get(
        _baseUrl + "/CarnetWebServer/geterrorcode/code/" + id,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: basicAuth,
            "X-API-KEY": dotenv.env['X-API-KEY']
          },
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );
       return  resp.data['data'];
  }

  Future<Map<String, dynamic>> getConfigCarnet(String id) async {
    final resp = await this._dio.get(
      _baseUrl + "/CarnetWebServer/getconfigcarnet/id/" + id,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: basicAuth,
          "X-API-KEY": dotenv.env['X-API-KEY']
        },
        followRedirects: false,
        validateStatus: (status) {
          return status < 600;
        },
      ),
    );
    return resp.data['data'];
  }
}