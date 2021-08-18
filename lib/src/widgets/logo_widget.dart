import 'package:asdn/src/config/background.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return FlutterLogo(
    //   size: 100,
    //   style: FlutterLogoStyle.markOnly,
    // );

    return Background(
      child: Image(
        width: 200,
        image: AssetImage('assets/logo_paqueno.png'),
      ),
    );
  }
}
