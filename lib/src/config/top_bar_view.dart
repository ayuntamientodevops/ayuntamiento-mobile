import 'dart:ui';

import 'package:asdn/src/bloc/auth/auth_bloc.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';

class TopBarView extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;

  const TopBarView({Key key, @required this.child, this.animationController})
      : super(key: key);

  _TopBarViewState createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> {
  AuthenticationService authenticationService = AuthenticationService();
  double topBarOpacity = 1;
  Animation<double> topBarAnimation;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyDarkOrange.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(42.0),
                      bottomRight: Radius.circular(42.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.nearlyDarkOrange
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 26,
                            right: 16,
                            top: 26 - 8.0 * topBarOpacity,
                            bottom: 23 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: FutureBuilder<User>(
                                  future: authenticationService.currentUser(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Image(
                                              image:
                                              AssetImage("assets/logo.png"),
                                              height: 30.0,
                                              width: 30.0,
                                            ),
                                          ),
                                          Text(
                                            "ASDN " /* snapshot.data.firstName*/,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                18 + 6 - 6 * topBarOpacity,
                                                letterSpacing: 1.2,
                                                color: AppTheme.white),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            child:
                                            CircularProgressIndicatorWidget(),
                                            height: 40.0,
                                            width: 40.0,
                                          )
                                        ]);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () => _showDialog(context),
                                        icon: Icon(Icons.more_vert),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDialog(BuildContext contexts) {
    // flutter defined function
    showDialog(
      context: contexts,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Ajustes"),
          content: new Container(
            height: 100,
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: () =>
                  BlocProvider.of<AuthBloc>(contexts).add(LoggedOut()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    gradient: new LinearGradient(colors: [
                      Color.fromARGB(250, 255, 8, 36),
                      Color.fromARGB(255, 255, 80, 100)
                    ])),
                padding: const EdgeInsets.all(0),
                child: Text(
                  "SALIR",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
