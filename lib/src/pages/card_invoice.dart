
import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/models/tabIcon_data.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/services/carnet_service.dart';
import 'package:asdn/src/utils/functions.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:awesome_card/awesome_card.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class CardInvoiceScreen extends StatefulWidget {
  const CardInvoiceScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _CardInvoiceScreenState createState() =>
      _CardInvoiceScreenState();
}

class _CardInvoiceScreenState
    extends State<CardInvoiceScreen> with TickerProviderStateMixin {

  AnimationController animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  final formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _expireController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameCardController = TextEditingController();
  double amount = 0.0;
  String clientIp = '12.0.0.1';
  String currency = '214';
  String environment = 'ECommerce';
  String idempotencyKey = '';
  String invoiceNumber = '';
  String merchantId = '349000000';
  String terminalId = '58585858';
  String referenceNumber = '20200506162757';
  int tax = 0;
  int tip = 0;
  String token = '98e894';

  String cardNumber = '4594 1300 0000 3243';
  String cardHolderName = 'Jose Garcia';
  String expiryDate = '03/24';
  String cvv = '432';
  bool showBack = false;

  FocusNode _focusNode;
  bool canPressRegisterBtn = true;
  final CardService cardService = CardService();
  final AuthenticationService authenticationService = AuthenticationService();


  @override
  void initState() {
    super.initState();
    this._getValueFromPreferences();
    _focusNode = FocusNode();
    _cardController.text= '4594130000003243';
    _expireController.text = '03/24';
    _nameCardController.text = 'Jose Garcia';
    _cvvController.text = '432';
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Factura No.: " + invoiceNumber),
        backgroundColor: AppTheme.nearlyDarkOrange,
      ),
      body: Container(
      height: MediaQuery.of(context).size.height * 0.922,
      margin: const EdgeInsets.only(bottom: 80),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              bankName: '',
              showBackSide: showBack,
              frontBackground: CardBackgrounds.custom(0xFF17262A),
              backBackground: CardBackgrounds.custom(0xFF17262A),
              showShadow: false,
              mask: getCardTypeMask(cardType: CardType.americanExpress),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: _cardController,
                    decoration: InputDecoration(hintText: 'No. Tarjeta'),
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final newCardNumber = value.trim();
                      var newStr = '';
                      final step = 4;

                      for (var i = 0; i < newCardNumber.length; i += step) {
                        newStr += newCardNumber.substring(
                            i, math.min(i + step, newCardNumber.length));
                        if (i + step < newCardNumber.length) newStr += ' ';
                      }

                      setState(() {
                        cardNumber = newStr;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: _expireController,
                    decoration: InputDecoration(hintText: 'Exp.'),
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      var newDateValue = value.trim();
                      final isPressingBackspace =
                          expiryDate.length > newDateValue.length;
                      final containsSlash = newDateValue.contains('/');

                      if (newDateValue.length >= 2 &&
                          !containsSlash &&
                          !isPressingBackspace) {
                        newDateValue = newDateValue.substring(0, 2) +
                            '/' +
                            newDateValue.substring(2);
                      }
                      setState(() {
                        _expireController.text = newDateValue;
                        _expireController.selection = TextSelection.fromPosition(
                            TextPosition(offset: newDateValue.length));
                        expiryDate = newDateValue;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: _nameCardController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Nombre'),
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cvvController,
                    decoration: InputDecoration(hintText: 'CVV'),
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        cvv = value;
                      });
                    },
                    focusNode: _focusNode,
                  ),
                ),
                btnSave()
              ],
            ),
          ],
        ),
        ),
      ),
      )
    );
  }

  Widget btnSave() {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: canPressRegisterBtn ? runProcces : null,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                  side: BorderSide(color: AppTheme.white))),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            gradient: new LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 136, 34),
                Color.fromARGB(255, 255, 177, 41)
              ],
            ),
          ),
          padding: const EdgeInsets.all(0),
          child: Text(
            "PROCESAR PAGO RD\$ " + amount.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  String encryptInvoiceNumer(String invoice){
    final key = encrypt.Key.fromUtf8("my32lengthsupersecretnooneknows1");
    final iv = encrypt.IV.fromLength(16);

    final encrypter =  encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(invoice, iv: iv);
    //final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return encrypted.base64;
  }
  _getValueFromPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      amount = prefs.getDouble("amount");
      invoiceNumber = prefs.getString("invoiceNum");
    });
  }
  void runProcces() async {
    clientIp = await Ipify.ipv4();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    idempotencyKey = await cardService.getIdempotencyKey();

    token = encryptInvoiceNumer(invoiceNumber);

    Map<String, dynamic> data = {
      "amount"        : amount,
      "card-number"   : _cardController.text,
      "client-ip"     : clientIp,
      "currency"      : currency,
      "cvv"           : _cvvController.text,
      "environment"   : environment,
      "expiration-date" : _expireController.text,
      "idempotency-key": idempotencyKey,
      "invoice-number" : invoiceNumber,
      "merchant-id"   : merchantId,
      "terminal-id"   : terminalId,
      "reference-number" : referenceNumber,
      "tax"           : tax,
      "tip"           : tip,
      "token"         : token
    };

    setState(() {
      canPressRegisterBtn = false;
    });
  if(_cardController.text == "" || _expireController.text == "" || _cvvController.text == "" || _nameCardController.text == ""){
    showAlertDialog(context,"Para completar el pago debe llenar todos los campos", false);
    setState(() {
      canPressRegisterBtn = true;
    });
  }else{
    Response resp = await cardService.sendDataCarnet(data);
    final code = await cardService.getMessageCode(resp.data["response-code"]);
    if(code['codigo'] == "00"){
    SchedulerBinding.instance.addPostFrameCallback((_) {

      setState(() {
        canPressRegisterBtn = true;
        _expireController.clear();
        _cardController.clear();
        _cvvController.clear();
        _nameCardController.clear();
          });
        });

        showAlertDialog(context,code['descripcion'] +' - codigo: '+ resp.data["approval-code"], true, ifCard: true);
        }else{
          setState(() {
           canPressRegisterBtn = true;
        });
        showAlertDialog(context,code['descripcion'] +' - codigo: '+ resp.data["approval-code"], false, ifCard: false);
      }
    }
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

