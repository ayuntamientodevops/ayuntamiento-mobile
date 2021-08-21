import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/config/background.dart';
import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/pages/change_password_page.dart';
import 'package:asdn/src/pages/register_page.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:asdn/src/widgets/input_widget.dart';
import 'package:asdn/src/bloc/auth/auth_bloc.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static final routeName = '/login';

  //model of key words used in login

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthBloc authBloc;
  bool clickLogin = false;
  bool isNoVisiblePassword = true;
  bool isRequest = false;
  final focus = FocusNode();
  final bool isLoginRequest = false;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();

    if (authBloc.state.authenticated) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.authenticated) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
        });
      }
    }, builder: (context, state) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: state.authenticated == false
                ? Column(
                    children: <Widget>[
                      SizedBox(height: size.height * 0.34),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: InputWidget(
                                controller: _usernameController,
                                icon: Icon(AntDesign.user,
                                    color: Constants.orangeDark),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                labelText: "No. Documento",
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
                                ],
                                validator: (String user) {
                                  if (user.length <= 0) {
                                    return "Ingrese el numero de documento";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Container(
                              alignment: Alignment.center,
                              child: InputWidget(
                                icon: Icon(AntDesign.lock,
                                    color: Constants.orangeDark),
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                controller: _passwordController,
                                labelText: "Contraseña",
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
                                ],
                                validator: (String password) {
                                  if (password.length <= 0) {
                                    return "Ingrese la contrasena";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChangePasswordPage())),

                                child: Text(
                                  "Olvidaste la contraseña?",
                                  style: TextStyle(
                                      fontSize: 12, color: AppTheme.dark_grey),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () => _onSubmit(),
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                          side: BorderSide(
                                              color: AppTheme.white))),
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
                                    "ENTRAR",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state.loading) {
                                  return CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              AppTheme.nearlyDarkOrange),
                                      backgroundColor: AppTheme.white);
                                } else if (state.isErrorAuth && clickLogin) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    mostrarSnackbar(state.errorLogin);
                                  });
                                }
                                return Container();
                              },
                            ),
                          ],
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
                                    builder: (context) => RegisterPage()))
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "No tienes una cuenta? ",
                                  style: TextStyle(
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13)),
                              TextSpan(
                                  text: "Registrate aqui",
                                  style: TextStyle(
                                      color: AppTheme.nearlyDarkOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicatorWidget(),
          ),
        ),
      );
    });
  }

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }

  void _onSubmit() async {
    FocusScope.of(context).unfocus();
    print(context);
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      clickLogin = true;
    });

    authBloc.add(LoginButtonPressed(
        user: _usernameController.text, password: _passwordController.text));
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1000),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
