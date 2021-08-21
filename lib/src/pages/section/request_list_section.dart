import 'dart:io';
import 'dart:ui';
import 'package:asdn/src/bloc/request/request_bloc.dart';
import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/models/search_response_geolocation.dart';
import 'package:asdn/src/pages/mapa_page.dart';
import 'package:asdn/src/services/request_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestListSection extends StatefulWidget {
  const RequestListSection(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _RequestListSectionState createState() => _RequestListSectionState();
}

class _RequestListSectionState extends State<RequestListSection>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<File> images = [];

  String _valueTypeRequest = "0";

  Result location;
  final formKey = GlobalKey<FormState>();
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  final _detail = TextEditingController();
  final _direction = TextEditingController();

  bool isSubmit = false;
  bool canPressRegisterBtn = true;
  bool loading = false;
  Reference ref = FirebaseStorage.instance.ref();
  RequestBloc requestBloc;
  final RequestService requestService = RequestService();
  final AuthenticationService authenticationService = AuthenticationService();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    requestBloc = RequestBloc();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                typeService(),
                inputDetails(),
                inputLocation(),
                loadEvidencia(context),
                this.images.length > 0
                    ? _boxPicture(context: context)
                    : Container(),
                (isSubmit && this.images.length == 0)
                    ? Container(
                        child: Text(
                          'Debe seleccionar al menos una foto',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                btnCargarEvidencia(),
                loading ? CircularProgressIndicatorWidget() : Container(),
              ],
            ),
          ),
        ),
    );
  }

  Widget btnCargarEvidencia() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      width: 290,
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: canPressRegisterBtn
            ? () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  isSubmit = true;
                });

                if ((formKey.currentState.validate() == false) ||
                    (this.images.length == 0) ||
                    (location == null)) return;

                formKey.currentState.save();

                Map<String, dynamic> data = {
                  "Description": _detail.text,
                  "UserRequested": authenticationService.getUserLogged().id,
                  "Latitude": location.geometry.location.lat,
                  "Longitude": location.geometry.location.lng,
                  "RequestType": _valueTypeRequest,
                  "Sector": location.formattedAddress,
                  "ReferenceAddress": _direction.text
                };

                setState(() {
                  loading = true;
                  canPressRegisterBtn = false;
                });

                List<String> imageSt = [];
                int i = 1;
                for (File image in images) {
                  String imageName =
                      authenticationService.getUserLogged().id.toString() +
                          '-$i' +
                          DateTime.now().toIso8601String();
                  TaskSnapshot addImg = await ref
                      .child("images/" +
                          authenticationService.getUserLogged().id.toString() +
                          "/$imageName")
                      .putFile(image);

                  if (addImg.state == TaskState.success) {
                    final String downloadUrl =
                        await addImg.ref.getDownloadURL();
                    imageSt.add(downloadUrl);
                  }
                  i++;
                }

                bool resp = await requestService.requestinsert(data, imageSt);

                setState(() {
                  loading = false;
                });

                if (resp) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    requestBloc.add(RequestLoad(load: false));
                    this.resetForm();
                    this.mostrarSnackbar(context,
                        "Solicitud Creada correctamente", Colors.green);
                  });
                } else {
                  setState(() {
                    loading = false;
                    canPressRegisterBtn = true;
                  });
                  this.mostrarSnackbar(
                      context, "Error al crear su solicitud", Colors.red);
                }
              }
            : null,
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(80.0),
              gradient: new LinearGradient(colors: [
                Color.fromARGB(255, 255, 136, 34),
                Color.fromARGB(255, 255, 177, 41)
              ])),
          padding: const EdgeInsets.all(0),
          child: Text(
            "CREAR INCIDENCIA",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget loadEvidencia(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Cargar Evidencia',
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.orangeDark,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: Constants.orangeDark))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Image(
                      image: AssetImage('assets/gallery.png'),
                    ),
                    onPressed: () {
                      if (images.length >= 4) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          this.mostrarSnackbar(context,
                              "Ha superado el limite de fotos", Colors.red);
                        });
                        return;
                      }
                      this._procesarImageClient(type: ImageSource.gallery);
                    },
                  ),
                  Text("Galeria")
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: Image(
                      image: AssetImage('assets/camera.png'),
                    ),
                    onPressed: () {
                      if (images.length >= 4) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          this.mostrarSnackbar(context,
                              "Ha superado el limite de fotos", Colors.red);
                        });

                        return;
                      }
                      this._procesarImageClient(type: ImageSource.camera);
                    },
                  ),
                  Text("Foto")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

/*
 * Crea el input para lococar el detalle de la solicitud
 */
  Widget inputDetails() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Detalle',
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.orangeDark,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: Constants.orangeDark))
            ],
          ),
          TextFormField(
            controller: _detail,
            validator: (String detail) {
              if (detail.length <= 0) {
                return "Debe colocar el detalle de la solicutud";
              }
              return null;
            },
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            autofocus: false,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Constants.orangeDark.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.orangeDark,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white60),
                hintText: "Escribir el detalle de la solicitud"),
          )
        ],
      ),
    );
  }

/*
 * Crea el input para lococar el tipo de solicitud
 */
  Widget typeService() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Tipo de servicio',
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.orangeDark,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: Constants.orangeDark))
            ],
          ),
          _dropdownSolicitud(),
        ],
      ),
    );
  }

  Widget _boxPicture({BuildContext context}) {
    return Row(
      children: images
          .asMap()
          .map(
            (key, value) => MapEntry(
              key,
              Container(
                padding: EdgeInsets.only(left: 18),
                child: _pictureUploaded(
                    context: context, image: value, index: key),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  void _procesarImageClient({ImageSource type}) async {
    await _procesarImagen(type: type);
    setState(() {});
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    final permission = await Permission.camera.isGranted;
    if (!permission) {
      // Map<Permission, PermissionStatus> statuses = await [
      //   Permission.camera,
      // ].request();
      Permission.camera.request();
      // print(statuses[Permission.location]);
      return false;
    } else {
      return true;
    }
  }

  Future<File> _procesarImagen({ImageSource type}) async {
    File image;
    if (await checkAndRequestCameraPermissions()) {
      final permiso = await Permission.camera.isGranted;
      if (!permiso) {
        return image;
      }

      final pickedFile = await ImagePicker().pickImage(source: type);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      if (image != null) {
        images.add(image);
      }
    }
    return image;
  }

  Widget _pictureUploaded({BuildContext context, File image, int index}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(7),
            height: 85,
            width: MediaQuery.of(context).size.width / 5.2,
            color: Theme.of(context).accentColor.withOpacity(0.2),
            child: Image(
              image: image?.path == null
                  ? AssetImage('assets/logo.png')
                  : FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images.removeAt(index);
                });
              },
              child: Image(
                image: AssetImage('assets/remove.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarSnackbar(BuildContext context, String mensaje, Color color) {
    if (mounted) {
      final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 2500),
        backgroundColor: color,
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    // var currentScaffold = globalScaffoldKey.currentState;
    // currentScaffold
    //     .hideCurrentSnackBar(); // If there is a snackbar visible, hide it before the new one is shown.
    // currentScaffold.showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Widget _dropdownSolicitud() {
    RequestService requestService = RequestService();
    return FutureBuilder<List<dynamic>>(
        future: requestService.requesttype(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicatorWidget();
          }
          List<dynamic> data = [];
          data.add({
            "TipoReclamacionId": "0",
            "Descripcion": "Seleccione un tipo de servicio",
            "Activo": "1"
          });

          if (snapshot.hasData) {
            data.addAll(snapshot.data
                .where((element) => element['Activo'] == "1")
                .toList());
          }

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Constants.orangeDark.withOpacity(0.5)),
              ),
            ),
            isExpanded: true,
            value: _valueTypeRequest,
            validator: (value) {
              if (value == "0") {
                return "Debe seleccionar el tipo solicutud";
              }
              return null;
            },
            onChanged: (type) => setState(() => _valueTypeRequest = type),
            items: data
                .map<DropdownMenuItem<String>>(
                    (value) => new DropdownMenuItem<String>(
                          value: value["TipoReclamacionId"],
                          child: new Text(value["Descripcion"]),
                        ))
                .toList(),
          );
        });
  }

  Widget inputLocation() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text('Ubicacion',
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.orangeDark,
                      fontWeight: FontWeight.bold)),
              Text(
                ' * ',
                style: TextStyle(fontSize: 15, color: Constants.orangeDark),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              var result = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new MapaPage(),
                      fullscreenDialog: true));
              if (result != null) {
                setState(() {
                  location = result;
                });
              }
            },
            child: Image(
              width: 50,
              image: AssetImage('assets/location.png'),
            ),
          ),
          location != null
              ? ListTile(
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: Constants.orangeDark,
                  ),
                  title: Text(location.formattedAddress),
                  subtitle: Text(
                      '${location.geometry.location.lat},${location.geometry.location.lng}'),
                )
              : Container(),
          (isSubmit && location == null)
              ? Container(
                  child: Text(
                    'Debe seleccionar una ubicacion',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Container(),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Direccion de Referencia',
                      style: TextStyle(
                          fontSize: 15,
                          color: Constants.orangeDark,
                          fontWeight: FontWeight.bold)),
                  Text(' * ',
                      style:
                          TextStyle(fontSize: 15, color: Constants.orangeDark))
                ],
              ),
              TextFormField(
                controller: _direction,
                validator: (String direccion) {
                  if (direccion.length <= 0) {
                    return "Debe colocar una direccion de referencia";
                  }
                  return null;
                },
                minLines: 1,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                autofocus: false,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.orangeDark.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants.orangeDark,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white60),
                    hintText: "Escribir una direccion de referencia"),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void resetForm() {
    _detail.clear();
    _direction.clear();
    setState(() {
      _valueTypeRequest = "0";
      location = null;
      isSubmit = false;
      images = [];
      canPressRegisterBtn = true;
    });
  }
}
