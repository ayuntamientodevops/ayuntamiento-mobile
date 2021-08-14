import 'package:asdn/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Constants.orangeDark),
        backgroundColor: Colors.white);
  }
}
