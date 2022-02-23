import 'dart:convert';
import 'dart:io';

import 'package:asdn/src/models/Card.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CardService {
  final _dio = new Dio();
  final String _baseUrlCarnet = dotenv.env['BASE_URL_CARNET'];
  final String _baseUrl = dotenv.env['BASE_URL'];
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  Future<String> getIdempotencyKey() async {

  final resp = await this._dio.post(
    _baseUrlCarnet + "/api/payment/idenpotency-keys",
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

  Future<Response> sendDataCarnet(Map<String, dynamic> dataCard) async {

    final resp = await this._dio.post(
      _baseUrlCarnet + "/api/payment/transactions/sales",
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
}