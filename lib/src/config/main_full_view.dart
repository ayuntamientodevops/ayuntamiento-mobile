import 'dart:ui';

import 'package:asdn/src/config/setting_widget.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class MainFullViewer extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final Widget contentBody;

  const MainFullViewer(
      {Key key,
      @required this.child,
      this.animationController,
      this.contentBody})
      : super(key: key);

  _MainFullViewerState createState() => _MainFullViewerState();
}

class _MainFullViewerState extends State<MainFullViewer> {
  AuthenticationService authenticationService = AuthenticationService();
  double topBarOpacity = 1;
  Animation<double> topBarAnimation;
  VoidCallback onSignOut;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: SettingWidget(),
      body: AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return Stack(
            children: [topBarHeader(context, child), widget.contentBody],
          );
        },
      ),
    );
  }

  Widget topBarHeader(BuildContext context, Widget child) {
    return Container(
      height: 133,
      child: FadeTransition(
        opacity: topBarAnimation,
        child: Transform(
          transform: Matrix4.translationValues(
              0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.nearlyDarkOrange.withOpacity(topBarOpacity),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(65.0),
                bottomRight: Radius.circular(65.0),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Image(
                                        image: AssetImage("assets/logo.png"),
                                        height: 40.0,
                                        width: 40.0,
                                      ),
                                    ),
                                    Text(
                                      "ASDN " /* snapshot.data.firstName*/,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18 + 6 - 6 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.white),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      child: CircularProgressIndicatorWidget(),
                                      height: 40.0,
                                      width: 40.0,
                                    )
                                  ]);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Container(
                                child: IconButton(
                                  iconSize: 30,
                                  onPressed: () =>
                                      {Scaffold.of(context).openDrawer()},
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
      ),
    );
  }
}
