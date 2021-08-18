import 'package:asdn/src/config/top_bar_view.dart';
import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/ui_view/title_view.dart';
import 'package:flutter/material.dart';

import 'invoice_list_section.dart';

class SectionsInvoiceScreen extends StatefulWidget {
  const SectionsInvoiceScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _SectionsInvoiceScreenState createState() => _SectionsInvoiceScreenState();
}

class _SectionsInvoiceScreenState extends State<SectionsInvoiceScreen>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    addAllListData();

    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Facturas',
        subTxt: "Consulta las últimas 10 facturas.",
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      InvoiceListSection(
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
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            getMainListViewUI(),
            Container(
              child: TopBarView(
                animationController: widget.animationController,
              ),
            ),
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
//            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  40,
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
}
