import 'dart:ui';
import 'package:asdn/src/bloc/request/request_bloc.dart';
import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/models/HistoryPayment.dart';
import 'package:asdn/src/models/Request.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/services/carnet_service.dart';
import 'package:asdn/src/share_prefs/preferences_storage.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key key, this.animationController})
      : super(key: key);
  final AnimationController animationController;

  @override
  _PaymentHistoryScreenState createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  CardService carnetService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<HistoryPayment> _items = [];
  bool isLoading = true;
  HistoryPaymentBloc historyPaymentBloc;
  PreferenceStorage preferenceStorage;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    carnetService = new CardService();
    _refreshIndicatorKey.currentState?.show();
    historyPaymentBloc = HistoryPaymentBloc();
    _loadItems(load: false);
  }
  void filterSearchResults(String query) {

    List<HistoryPayment> listData = List<HistoryPayment>();

    if(query != ""){
      _loadItems(load: false);
      var result = _items.indexWhere((element) => element.approvalCode.contains(query));
      if (result >= 0) {
        listData.add(_items[result]);

        if (mounted) {
          setState(() {
            _items.clear();
            _items.addAll(listData);
          });
        }
        return;
      }else{
        _items.clear();
      }
    }else{
      _loadItems(load: false);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicatorWidget());
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _loadItems(load: true),
      child: Container(
        margin:  EdgeInsets.only(top: 150),
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                cursorColor: AppTheme.nearlyDarkOrange,
                decoration: InputDecoration(
                  labelText: "Codigo...",
                  hintText: "",
                  hintStyle: TextStyle(color: AppTheme.nearlyDarkOrange ),
                  prefixIcon: Icon(Icons.search, color: AppTheme.nearlyDarkOrange),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: AppTheme.nearlyDarkOrange ),

                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: AppTheme.nearlyDarkOrange ),

                  ),
                ),
              ),
            ),
            _items.length == 0
                ? Container(
              margin: EdgeInsets.only(top: 200),
              alignment: Alignment.center,
              child: Text(
                'No se encontraron solicitudes.',
                style: TextStyle(fontSize: 15),
              ),
            )
                : new Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 3),
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  print(_items[index]);
                  return cardWidget(historyPayment: _items[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _loadItems({bool load}) async {

    if (mounted) {
      if (load == false) {
        preferenceStorage = PreferenceStorage();

        if (preferenceStorage.getValue(key: "historyPaymentLoad") == 'true') {
          setState(() {
            _items = HistoryPayment.decode(
                preferenceStorage.getValue(key: "historyPayments").toString());
            isLoading = false;
          });
          return;
        }
      }

      AuthenticationService auth = AuthenticationService();
      final User user = auth.getUserLogged();
      final items = await carnetService.getPaymentHistory(userId: user.id);

      if (items['OK']) {
        historyPaymentBloc.add(HistoryPaymentLoad(load: true, historyPayments: items['data']));
        setState(() {
          _items = items['data'];
          isLoading = false;
        });
        _refreshIndicatorKey.currentState?.show();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget drawerBox(HistoryPayment historyPayment) {
    return Column(
      children: [
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.monetization_on_rounded,
                  size: 22,
                  color: AppTheme.greenApp,
                ),
              ),
              TextSpan(
                style: TextStyle(color: Colors.black),
                text: "100.0",
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget cardWidget({HistoryPayment historyPayment}) {
    print(historyPayment.card);
    String formattedDate = "";//DateFormat.yMMMMd('es_PR').format(DateTime.parse(historyPayment.dateCreated.toString()));

    return GestureDetector(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer, 
            elevation: 22,
            child: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container( 
                      margin: const EdgeInsets.only(top: 13),
                      child: ListTile(
                          title: Text(historyPayment.invoiceNumber,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text(formattedDate),
                          trailing: drawerBox(historyPayment)),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      height: 20.0,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          gradient: new LinearGradient(colors: [
                            AppTheme.nearlyDarkOrange,
                            AppTheme.nearlyOrgane
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Codigo: #" + historyPayment.approvalCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
