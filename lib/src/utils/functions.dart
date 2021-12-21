import 'dart:io';
import 'dart:ui';

import 'package:asdn/src/config/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<bool> connectionValidate() async {
  try {
    final result = await InternetAddress.lookup('webapi.asdn.gob.do');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

void showAlertDialog(context,String text, bool isSuccess) {

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.w300),
    descTextAlign: TextAlign.center,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: AppTheme.grey,
      ),
    ),
    titleStyle: TextStyle(
      color:(isSuccess)? Colors.green : AppTheme.redText,
    ),
    alertAlignment: Alignment.center,
  );

  Alert(
    context: context,
    style: alertStyle,
    type: (isSuccess)? AlertType.success : AlertType.error,
    title:(isSuccess)? "ÉXITO" : "ERROR",
    desc: text,
    buttons: [
      DialogButton(
        child: Text("CERRAR",
          style: TextStyle(color: AppTheme.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: (isSuccess)? Colors.green : AppTheme.redText,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}