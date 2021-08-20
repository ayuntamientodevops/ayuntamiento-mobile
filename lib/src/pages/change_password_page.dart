import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/config/background.dart';
import 'package:asdn/src/helpers/helpers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:asdn/src/widgets/input_widget.dart';

import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isRequest = false;
  bool isNoVisiblePassword = true;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.38),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "La instrucciones de recuperación de contraseña se enviarán al correo electrónico.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: InputWidget(
                        controller: _emailController,
                        icon: Icon(AntDesign.mail, color: Constants.orangeDark),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        labelText: "Correo electrónico",
                        validator: (String email) {
                          if (email.length <= 0) {
                            return "Ingrese el correo electrónico";
                          } else if (!EmailValidator.validate(email)) {
                            return "Correo electrónico invalido";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () => resetForm(),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                      side: BorderSide(color: AppTheme.white))),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: new LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "ENVIAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()))
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Ya recuerdas la contraseña? ",
                                style: TextStyle(
                                    color: AppTheme.dark_grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                            TextSpan(
                                text: "Inicia aqui",
                                style: TextStyle(
                                    color: AppTheme.nearlyDarkOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*  void _onSubmit() async {
    if (!formKey.currentState.validate()) return;
    registerBloc.add(
      RegisterButtonPressed(
          name: _nameController.text,
          lastname: _lastnameController.text,
          documentNumber: _documentNumberController.text,
          phone: _phoneNumberController.text,
          email: _emailController.text,
          password: _passwordController.text),
    );
  }*/

  void resetForm() {
    _emailController.clear();
  }
  void mostrarSnackbar(String mensaje, Color color) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 5000),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /* void resetForm() {
    _nameController.clear();
  }*/

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
