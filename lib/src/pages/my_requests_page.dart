import 'package:asdn/src/bloc/request/request_bloc.dart';
import 'package:asdn/src/helpers/helpers.dart';
import 'package:asdn/src/models/user.dart';
import 'package:asdn/src/pages/request_details.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/services/request_service.dart';
import 'package:asdn/src/share_prefs/preferences_storage.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
import 'package:asdn/src/models/Request.dart';

import 'package:intl/intl.dart';

class MyIncidentsPage extends StatefulWidget {
  MyIncidentsPage();

  @override
  _MyIncidentsPageState createState() => _MyIncidentsPageState();
}

class _MyIncidentsPageState extends State<MyIncidentsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  RequestService requestService;

  List<Request> _items = [];
  bool isLoading = true;
  RequestBloc requestBloc;
  PreferenceStorage preferenceStorage;
  @override
  void initState() {
    super.initState();
    requestService = new RequestService();
    _refreshIndicatorKey.currentState?.show();
    requestBloc = RequestBloc();
    _loadItems(load: false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicatorWidget());
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _loadItems(load: true),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Mis Solicitudes",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Constants.orangeDark,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(),
            _items.length == 0
                ? Container(
                    child: Text(
                      'No existe ninguna solicitud pendiente',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : new Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return cardWidget(request: _items[index]);
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future _loadItems({bool load}) async {
    if (mounted) {
      if (load == false) {
        preferenceStorage = PreferenceStorage();

        if (preferenceStorage.getValue(key: "requestLoad") == 'true') {
          setState(() {
            _items = Request.decode(
                preferenceStorage.getValue(key: "requests").toString());
            isLoading = false;
          });
          return;
        }
      }

      AuthenticationService auth = AuthenticationService();
      final User user = auth.getUserLogged();
      var items = await requestService.getRequest(idUsuario: user.id);
      if (items['OK']) {
        requestBloc.add(RequestLoad(load: true, requests: items['data']));
        setState(() {
          _items = items['data'];
          isLoading = false;
        });
        _refreshIndicatorKey.currentState?.show();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget getFechas(Request r) {
    String fecha;
    String label;
    Color color;
    if (r.fechaResolucion != null) {
      fecha = r.fechaResolucion;
      label = "Fecha Resolucion";
      color = Colors.lightGreen;
    } else if (r.fechaAsignacion != null) {
      fecha = r.fechaAsignacion;
      label = "Fecha Asignacion";
      color = Colors.yellow;
    } else if (r.fechaSolicitud != null) {
      fecha = r.fechaSolicitud;
      label = "Fecha Solicitud";
      color = Colors.red;
    }
    return Column(
      children: [
        Text('Estado'),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.circle,
                  size: 12,
                  color: color,
                ),
              ),
              TextSpan(
                style: TextStyle(color: Colors.black),
                text: r.estatusReclamacion,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget cardWidget({Request request}) {
    String formattedDate = DateFormat.yMMMMd('es_PR')
        .format(DateTime.parse(request.fechaSolicitud));

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RequestDetails.routeName,
            arguments: request);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 240.0,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 2,
            child: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      placeholder: 'assets/gallery.png',
                      image: request.images[0],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListTile(
                          title: Text(request.descripcion,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text(formattedDate),
                          trailing: getFechas(request)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
