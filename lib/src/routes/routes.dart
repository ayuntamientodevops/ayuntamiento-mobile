import 'package:flutter/material.dart';
import 'package:asdn/src/pages/mapa_page.dart';
import 'package:asdn/src/pages/request_details.dart';
import 'package:asdn/src/pages/acceso_gps_page.dart';
import 'package:asdn/src/pages/loading_page.dart';
import 'package:asdn/src/pages/register_page.dart';
import 'package:asdn/src/pages/home_page.dart';
import 'package:asdn/src/pages/login_page.dart';

Map<String, WidgetBuilder> getApplicationsRoutes() {
  return <String, WidgetBuilder>{
    LoginPage.routeName: (BuildContext context) => LoginPage(),
    HomePage.routeName: (BuildContext context) => HomePage(),
    LoadingPage.routeName: (BuildContext context) => LoadingPage(),
    RegisterPage.routeName: (BuildContext context) => RegisterPage(),
    AccesoGpsPage.routeName: (BuildContext context) => AccesoGpsPage(),
    MapaPage.routeName: (BuildContext context) => MapaPage(),
    RequestDetails.routeName: (BuildContext context) => RequestDetails(),
  };
}
