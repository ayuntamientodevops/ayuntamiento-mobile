import 'package:asdn/src/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChangePassworPage extends StatefulWidget {
  ChangePassworPage({Key key}) : super(key: key);

  @override
  _ChangePassworPageState createState() => _ChangePassworPageState();
}

class _ChangePassworPageState extends State<ChangePassworPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: showModal,
        child: Text(
          'Recupera aquí ',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Constants.orangeDark),
        ),
      ),
    );
  }

  Future showModal() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Recuperar Contrasena",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkResponse(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                Divider(),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "La instrucciones de recuperacion de contrasena se enviaran al correo electronico",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Correo Electronico",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.orangeDark.withOpacity(0.5)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Constants.orangeDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Constants.orangeDark),
                          child: Text("Enviar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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
