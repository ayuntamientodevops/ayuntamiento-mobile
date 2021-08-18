import 'dart:convert' show base64Encode, json, jsonEncode, utf8;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/models/user.dart';

import 'package:asdn/src/share_prefs/preferences_storage.dart';

class AuthenticationService {
  static final AuthenticationService _instancia =
      new AuthenticationService._internal();

  PreferenceStorage preferenceStorage = PreferenceStorage();
  final String _baseUrl = dotenv.env['BASE_URL'];

  final _dio = new Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'],
    ),
  );

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  factory AuthenticationService() {
    return _instancia;
  }

  AuthenticationService._internal();

  Future<Map<String, dynamic>> signIn(
      {String username, String password}) async {
    try {
      Map<String, String> params = {
        "IdentificationCard": "$username",
        "password": "$password",
      };
      final resp = await this._dio.post("/RequestUsersWebServer/login",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              validateStatus: (status) {
                return status < 600;
              }),
          data: jsonEncode(params));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          var user = json.encode(resp.data['data']);
          await preferenceStorage.setValue(key: "currentUser", value: user);
          return {"OK": true, "mensaje": ''};
        } else {
          return {"OK": false, "mensaje": resp.data['message']};
        }
      }
      return {"OK": false, "mensaje": "Error al al ingresar a la aplicacion"};
    } on Exception catch (e) {
      print(e.toString());
      return {"OK": false, "mensaje": "Error al ingresar a la aplicacion "};
    }
  }

  Future<Map<String, dynamic>> register(
      {String name,
      String lastname,
      String email,
      String password,
      String phone,
      String identificationCard}) async {
    try {
      Map<String, String> params = {
        "first_name": "$name",
        "last_name": "$lastname",
        "email": "$email",
        "password": "$password",
        "phone": "$phone",
        "IdentificationCard": "$identificationCard"
      };

      final resp =
          await this._dio.post(_baseUrl + "/RequestUsersWebServer/registration",
              options: Options(
                  headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                    HttpHeaders.authorizationHeader: basicAuth,
                    "X-API-KEY": dotenv.env['X-API-KEY']
                  },
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 600;
                  }),
              data: jsonEncode(params));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          return {"OK": true, "mensaje": ''};
        } else {
          return {"OK": false, "mensaje": resp.data['message']};
        }
      } else {
        return {"OK": false, "mensaje": resp.data};
      }
    } on DioError catch (e) {
      return {"OK": false, "mensaje": "Error al ingresar a la aplicacion"};
    }
  }

  Future<User> currentUser() async {
    return this.getUserLogged();
  }

  User getUserLogged() {
    Map<String, dynamic> data;
    final jwt = preferenceStorage.getValue(key: "currentUser");
    User user;
    if (jwt != null) {
      data = json.decode(jwt);
      user = User.fromJson(data);
    }
    return user;
  }

  static Future<bool> loggedUser() async {
    PreferenceStorage preferenceStorage = PreferenceStorage();
    final jwt = preferenceStorage.getValue(key: "currentUser");

    if (jwt != null) {
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    return await preferenceStorage.deleteValue(key: "currentUser");
  }
}