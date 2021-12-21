import 'package:asdn/src/bloc/auth/auth_bloc.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart';
import 'main_full_view.dart';

class SettingWidget extends StatelessWidget {
  final AuthenticationService authenticationService = AuthenticationService();

  SettingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 1,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.nearlyDarkOrange,
              ),
              child: FutureBuilder<User>(
                  future: authenticationService.currentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40.0,
                            backgroundImage:
                                AssetImage("assets/home/profile.png"),
                          ),
                          Text(
                            toBeginningOfSentenceCase(snapshot.data.firstName) +
                                ' ' +
                                toBeginningOfSentenceCase(
                                    snapshot.data.lastName),
                            style: TextStyle(
                                fontSize: 15.0,
                                color: AppTheme.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 3),
                          Text(
                            snapshot.data.email,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: AppTheme.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      );
                    }
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicatorWidget(),
                            height: 40.0,
                            width: 40.0,
                          )
                        ]);
                  }),
            ),
           /* _createDrawerItem(
                icon: Icons.password,
                text: 'Cambiar Contraseña',
                color: Constants.orangeDark,
                onTap: () {
                  Navigator.pushNamed(context, ResetPassword.routeName);
                }),*/
            _createDrawerItem(
                icon: Icons.home,
                text: 'Inicio',
                color: AppTheme.dark_grey,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainFullViewer(
                              identificationPage: "home")));
                }),
            _createDrawerItem(
                icon: Icons.book_outlined,
                text: 'Facturas',
                color: AppTheme.dark_grey,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainFullViewer(
                              identificationPage: "invoice")));
                }),
            _createDrawerItem(
                icon: Icons.format_list_numbered,
                text: 'Incidencias',
                color: AppTheme.dark_grey,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainFullViewer(
                              identificationPage: "request")));
                }),

            Row(
                children: <Widget>[
                  Expanded(
                      child: Divider()
                  ),

                  Expanded(
                      child: Divider()
                  ),
                ]
            ),
            _createDrawerItem(
                icon: Icons.logout,
                text: 'Cerrar Sesión',
                color: AppTheme.redText,
                onTap: () {
                  BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                }),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon,
      String text,
      Color color = Colors.black54,
      GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                  color: color, fontSize: 15.0, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
