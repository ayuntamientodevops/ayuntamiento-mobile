import 'package:asdn/src/models/tabIcon_data.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/pages/section/request_list_section.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/ui_view/title_view.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';

class SectionsRequestScreen extends StatefulWidget {
  const SectionsRequestScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _SectionsRequestScreenState createState() => _SectionsRequestScreenState();
}

class _SectionsRequestScreenState extends State<SectionsRequestScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 1;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();
    AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Reportar nuevo incidente',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      RequestListSection(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = AuthenticationService();
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(authenticationService),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
            ),
            itemCount: listViews.length,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI(AuthenticationService authenticationService) {
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
                              /*       child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      child: Image(
                                        image: AssetImage("assets/home/menu.png"),
                                        height: 30.0,
                                        width: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/
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
        )
      ],
    );
  }
}
