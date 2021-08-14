import 'package:asdn/src/helpers/helpers.dart';
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
    child:  Scaffold(
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
              child: buildBody(context),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget buildBody(context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, left: 20, right: 20, top: 20),
                    child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        validator: (String name) {
                          if (name.length <= 0) {
                            return "Ingrese el nombre";
                          } else {
                            return null;
                          }
                        },
                        controller: _nameController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color:  Color(0xFFFFAB40))),
                            hintText: "Nombre")),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
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
                        controller: _lastnameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFAB40))),
                            hintText: "Apellido")),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (String doc) {
                          if (doc.length == 0) {
                            return "Ingrese el numero de documento";
                          }

                          if (doc.length < 8 && doc.length > 11) {
                            return "Ingrese un numero de documento correcto";
                          }
                          return null;
                        },
                        controller: _documentNumberController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFAB40))),
                            hintText: "No. Documento")),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (String phone) {
                          if (phone.length <= 0) {
                            return "Ingrese el teléfono";
                          } else if (phone.length != 10) {
                            return "Ingrese un teléfono correcto";
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFAB40))),
                            hintText: "Teléfono")),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                        validator: (String email) {
                          if (email.length <= 0) {
                            return "Ingrese el correo electrónico";
                          } else if (!EmailValidator.validate(email)) {
                            return "Correo electrónico invalido";
                          }
                          return null;
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFAB40))),
                            hintText: "Correo electrónico")),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: TextFormField(
                      validator: (String password)  {
                        if (password.length <= 0) {
                          return "Ingrese la constraseña";
                        } else if (password.length < 6) {
                          return "La constraseña debe tener un minimo de 6 caracteres";
                        }
                        return null;
                      },
                        controller: _passwordController,
                        obscureText: this.isNoVisiblePassword,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        decoration: InputDecoration(
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
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color:  Color(0xFFFFAB40))),
                            hintText: "Contraseña"),

                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: TextFormField(
                        validator: (String password)   {
                          if (password.length <= 0) {
                            return "Ingrese la constraseña";
                          }
                          if (_passwordController.text != password) {
                            return "Las constraseñas no coinciden";
                          }
                          return null;
                        },
                        controller: _password2Controller,
                        obscureText: this.isNoVisiblePassword,
                        style: TextStyle(
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFAB40))),
                            hintText: "Confirmar Contraseña")),
                  )
                ],
               ),
              ),
            ),
          ),
          (this.isRequest)
              ? Padding(
            padding: const EdgeInsets.all(8.0),
          )
              : GestureDetector(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Color(0xFFFFAB40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(

                          child: TextButton(
                            child:
                            Text('Registrar', style: TextStyle( color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: canPressRegisterBtn ? _onSubmit : null,
                          )
                         ),
                    ))),
          ), BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state.loading) {
                  return CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Constants.orangeDark),
                      backgroundColor: Colors.white);
                } else if (state.errorRegistro != "") {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    mostrarSnackbar(state.errorRegistro, Colors.red);
                  });
                }
                return Container();
              }),
          SizedBox()
        ]);

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
