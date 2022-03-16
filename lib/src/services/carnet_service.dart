import 'dart:convert';
import 'dart:io';
import 'package:asdn/src/models/HistoryPayment.dart';
import 'package:asdn/src/share_prefs/preferences_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class CardService {
  final _dio = new Dio();
  final String _baseUrlInvoces = dotenv.env['BASE_URL_INVOICE'];
  final String _baseUrlCarnet = dotenv.env['BASE_URL_CARNET'];
  final String _baseUrl = dotenv.env['BASE_URL'];
  String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));
  PreferenceStorage preferenceStorage = PreferenceStorage();


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
  Future<Response> sendDataLogCard(Map<String, dynamic> card, String cardHolder,String messageCode,
      String approval) async{

    final currentUser = preferenceStorage.getValue(key: "currentUser");
    final id_user = json.decode(currentUser);

    Map<String, String> params = {
      "user_name"    : cardHolder,
      "user_created" : id_user["id"],
      "message_code" : messageCode,
      "approval_code": approval
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
      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if((resp.data['status'] == true)){
        return resp.data['data'];
        }
      }
      return null;
  }

  Future<String> getTokenSigem() async {
    Map<String, String> params = {
      "username": dotenv.env['USERNAME_INVOICE'],
      "password": dotenv.env['PASSWORD_INVOICE'],
    };
    final resp = await this._dio.post(
      _baseUrlInvoces + "/api/Account/login",
      options: Options(
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        followRedirects: false,
        validateStatus: (status) {
          return status < 600;
        },
      ),
      data: jsonEncode(params),
    );
    if (resp.statusCode >= 200 && resp.statusCode < 250) {
      return resp.data['token'];
    }
    return null;
  }
  void savePayments(Map<String, dynamic> dataCard) async {
    final token = await this.getTokenSigem();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    Map params = {
      "invoiceId": dataCard['invoice-number'],
      "date": formattedDate,
      "amount": dataCard['amount'],
      "paymentMethod": "TAR"
    };

    String bearerAuth = 'Bearer ' + token;
    await this._dio.post(
      _baseUrlInvoces + "/api/Payments/",
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: bearerAuth,
        },
        followRedirects: false,
        validateStatus: (status) {
          return status < 600;
        },
      ),
      data: jsonEncode(params)
    );
  }

  Future<Map<String, dynamic>> getPaymentHistory({String userId, String code}) async {
    try {
    List<HistoryPayment> historyPayment = [];
    final resp = await this._dio.get(
      _baseUrl + "/CarnetWebServer/getpaymenthistory/id/" + userId+"/code/"+code,
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

    if (resp.statusCode >= 200 && resp.statusCode < 250) {

      if (resp.data['data'].length > 0) {
        for (var item in resp.data['data']) {
          historyPayment.add(HistoryPayment.fromJson(item));
        }
      }

      return {"OK": true, "data": historyPayment};
    }

    return {"OK": false, "mensaje": "No existe ninguna solicitud pendiente"};
  } on DioError  catch (e) {
  print(e.error);
  return {"OK": false, "mensaje": "Error obtener las solictudes"};
  }
  }
}