import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/models/Invoices.dart';
import 'package:asdn/src/models/Request.dart';
import 'package:asdn/src/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestService {
  static final RequestService _instancia = new RequestService._internal();
  final String _baseUrl = dotenv.env['BASE_URL'];
  final String _baseUrlInvoces = dotenv.env['BASE_URL_INVOICE'];
  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  factory RequestService() {
    return _instancia;
  }

  RequestService._internal();

  Future<List<dynamic>> requesttype() async {
    try {
      final resp =
          await this._dio.get(_baseUrl + "/RequestWebServer/requesttype",
              options: Options(
                  headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                    HttpHeaders.authorizationHeader: basicAuth,
                    "X-API-KEY": dotenv.env['X-API-KEY']
                  },
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 600;
                  }));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status'] == true) {
          return resp.data['data'];
        }
      }
      return null;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<bool> requestinsert(
      Map<String, dynamic> data, List<String> images) async {
    try {
      Map<String, String> fileMap = {};

      int i = 1;
      images.forEach((image) async {
        // final bytes = File(image.path).readAsBytesSync();
        // String img64 = base64Encode(bytes);
        fileMap[i.toString()] = image;
        i++;
      });

      data['RequestImages'] = fileMap;

      var formData = FormData.fromMap(data);
      final resp = await _dio.post(_baseUrl + '/RequestWebServer/insertrequest',
          data: formData,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 600;
              }));

      if (resp.data['status']) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getRequest({String idUsuario}) async {
    try {
      final List<Request> requests = [];
      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getrequestuser/user/" + idUsuario,
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
        if (resp.data['status'] == false) {
          return {
            "OK": false,
            "mensaje": resp.data['message'],
          };
        }

        if (resp.data['data'].length > 0) {
          for (var item in resp.data['data']) {
            item["images"] = await this
                .getPostImageRequest(idRequest: item["ReclamacionId"]);
            requests.add(Request.fromJson(item));
          }
        }
        return {"OK": true, "data": requests};
      }
      return {"OK": false, "mensaje": "No existe ninguna solicitud pendiente"};
    } on DioError catch (e) {
      return {"OK": false, "mensaje": "Error obtener las solictudes"};
    }
  }

  Future<List<String>> getPostImageRequest({String idRequest}) async {
    try {
      final List<String> images = [];

      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getimagebyrequest/id/" + idRequest,
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
        if (resp.data['status'] == true) {
          if (resp.data['data'].length > 0) {
            for (var image in resp.data['data']) {
              images.add(image['Imagen']);
            }
          }
        }
      }
      return images;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<List<Image>> getImageRequest({String idRequest}) async {
    try {
      final List<Image> images = [];
      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getimagebyrequest/id/" + idRequest,
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
        if (resp.data['status'] == true) {
          if (resp.data['data'].length > 0) {
            for (var item in resp.data['data']) {
              images.add(Image(image: imageFromBase64String(item['Imagen'])));
            }
          }
        }
      }
      return images;
    } on DioError catch (e) {
      return [];
    }
  }

  ImageProvider imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
    // return Image.memory(
    //   base64Decode(base64String),
    //   fit: BoxFit.fitWidth,
    //   width: double.infinity,
    // );
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  Future<String> getInvocesLoginHistory() async {
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

  Future<Invoices> getInvocesHistory({User user}) async {
    final token = await this.getInvocesLoginHistory();
    Invoices invoices;

    String bearerAuth = 'Bearer ' + token;
    final resp = await this._dio.get(
          _baseUrlInvoces + "/api/Taxpayer/" + user.identificationCard,
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
        );
    if (resp.statusCode >= 200 && resp.statusCode < 250) {
      if (resp.data['invoices'] == null) {
        resp.data['invoices'] = [];
      }
      invoices = Invoices.fromJson(resp.data);

      return invoices;
    }
    return null;
  }
}
