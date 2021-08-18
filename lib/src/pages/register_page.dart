import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/config/background.dart';
import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:asdn/src/widgets/logo_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:asdn/src/widgets/input_widget.dart';
import 'package:asdn/src/bloc/register/register_bloc.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static final routeName = '/register';

  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isRequest = false;
  bool isNoVisiblePassword = true;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  RegisterBloc registerBloc;
  bool canPressRegisterBtn = true;

  @override
  void initState() {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.registrado) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mostrarSnackbar("Registrado Correctamente", Colors.green);
            this.resetForm();
          });
          setState(() {
            canPressRegisterBtn = false;
          });
        }
      },
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.28),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _nameController,
                          icon: Icon(AntDesign.adduser,
                              color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Nombre",
                          validator: (String name) {
                            if (name.length <= 0) {
                              return "Ingrese el nombre";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _lastnameController,
                          icon:
                              Icon(AntDesign.user, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Apellidos",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String lasname) {
                            if (lasname.length <= 0) {
                              return "Ingrese los apellidos";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _documentNumberController,
                          icon: Icon(FontAwesome5.id_card,
                              color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          labelText:
                              "No. Documento (Ejemplo: Cedula, RNC, etc...)",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (String doc) {
                            if (doc.length == 0) {
                              return "Ingrese el numero de documento";
                            }

                            if (doc.length < 8 && doc.length > 11) {
                              return "Ingrese un numero de documento correcto";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _phoneNumberController,
                          icon: Icon(Icons.phone, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          labelText: "Numero de telefono",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (String phone) {
                            if (phone.length <= 0) {
                              return "Ingrese el telefono";
                            } else if (phone.length != 10) {
                              return "Ingrese un telefono correcto";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _emailController,
                          icon:
                              Icon(AntDesign.mail, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Correo Electronico",
                          validator: (String email) {
                            if (email.length <= 0) {
                              return "Ingrese el correo electronico";
                            } else if (!EmailValidator.validate(email)) {
                              return "Correo electronico invalido";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _passwordController,
                          icon:
                              Icon(AntDesign.lock, color: Constants.orangeDark),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          labelText: "Contraseña",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String password) {
                            if (password.length <= 0) {
                              return "Ingrese la constraseña";
                            } else if (password.length < 6) {
                              return "La constraseña debe tener un minimo de 6 caracteres";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _password2Controller,
                          icon: Icon(Icons.lock_sharp,
                              color: Constants.orangeDark),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          labelText: "Confirmar contraseña",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String password) {
                            if (password.length <= 0) {
                              return "Ingrese la constraseña";
                            }
                            if (_passwordController.text != password) {
                              return "Las constraseñas no coinciden";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: RaisedButton(
                          onPressed: canPressRegisterBtn ? _onSubmit : null,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0),
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
                              "REGISTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                        if (state.loading) {
                          return CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Constants.orangeDark),
                              backgroundColor: Colors.white);
                        } else if (state.errorRegistro != "") {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            mostrarSnackbar(state.errorRegistro, Colors.red);
                          });
                        }
                        return Container();
                      }),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Ya tienes una cuenta? ",
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
        ),
      ),
    );
  }
  void _onSubmit() async {
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

  void resetForm() {
    _nameController.clear();
    _lastnameController.clear();
    _documentNumberController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _passwordController.clear();
    _password2Controller.clear();
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

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }
}