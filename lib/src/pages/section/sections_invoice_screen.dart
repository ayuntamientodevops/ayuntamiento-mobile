import 'package:asdn/src/config/main_full_view.dart';
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
            Container(
              child: MainFullViewer(
                animationController: widget.animationController,
                contentBody: getMainListViewUI(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.925,
      padding: const EdgeInsets.only( top: 135),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ListView.builder(
            itemCount: listViews.length,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        },
      ),
    );
  }
}
