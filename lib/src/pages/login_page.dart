import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/pages/register_page.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:asdn/src/widgets/logo_widget.dart';
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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFFFAB40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 3),
                        child: Hero(
                          tag: 'hero-login',
                          child: Image.asset(
                              "assets/logo_paqueno.png",
                              width: 215,
                              height: 215,
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: Color(0xFFF3F3F5),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0),
                  )),
              child: buildBody(context, state),
            ),
          ),
        ],
      ),
    );

    });
  }

  Widget buildBody(context, state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: state.authenticated == false
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Form(
                    key: formKey,
                    child: Column(
                        children: [
                    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .singleLineFormatter
                      ],
                      validator: (String user) {
                        if (user.length <= 0) {
                          return "Ingrese el no. documento";
                        } else {
                          return null;
                        }
                      },
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color:  Color(0xFF0F2E48),
                          fontSize: 14),
                      autofocus: false,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/i_user.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color:  Color(0xFFFFAB40))),
                          hintText: "No. Documento")),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .singleLineFormatter
                      ],
                      validator: (String password) {
                        if (password.length <= 0) {
                          return "Ingrese la constraseña";
                        } else {
                          return null;
                        }
                      },
                      controller: _passwordController,
                      focusNode: focus,
                      obscureText: this.isNoVisiblePassword,
                      style: TextStyle(
                          color: Color(0xFF0F2E48),
                          fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/i_password.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (this.isNoVisiblePassword)
                                    this.isNoVisiblePassword = false;
                                  else
                                    this.isNoVisiblePassword = true;
                                });
                              },
                              child: (this.isNoVisiblePassword)
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/i_eye_close.png",
                                  width: 15,
                                  height: 15,
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/i_eye_open.png",
                                  width: 15,
                                  height: 15,
                                ),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color:  Color(0xFFFFAB40))),
                          hintText: "***********")),
                ),
                (this.isRequest)
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),

                )
                    :  Padding(padding: const EdgeInsets.all(8.0),
                ),GestureDetector(
                  onTap: () {
                    /*     widget.callLogin(
                        context,
                        setIsRequest,
                        this._textEditingControllerUser.text,
                        this._textEditingControllerPassword.text
                    );*/
                  },

                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color:  Color(0xFFFFAB40),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),

                                ),
                                  onPressed: _onSubmit
                              )),
                          )),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<
                              Color>(
                              Constants.orangeDark),
                          backgroundColor: Colors.white);
                    } else if (state.isErrorAuth &&
                        clickLogin) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) {
                        mostrarSnackbar(state.errorLogin);
                      });
                    }
                    return Container();
                  },
                ),
                Padding(padding: const EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                      child: Center(
                        child: TextButton(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Si no tienes cuenta?"+ ' \n',
                            style: TextStyle(
                                color: Color(0xFF0F2E48),
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                        TextSpan(
                            text: "Registrate aqui",
                            style: TextStyle(
                                color:  Color(0xFFFFAB40),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                           ]),
                             ),
                          onPressed: () {
                            SchedulerBinding.instance
                                .addPostFrameCallback((_) {
                              Navigator.pushReplacementNamed(
                                  context,
                                  RegisterPage.routeName);
                            });
                          },
                           ),
                         ),
                        ),
                      ),
                    ]
                 ),
                ),
              ],
            ): CircularProgressIndicatorWidget(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox()
        ),
      ],
    );
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
