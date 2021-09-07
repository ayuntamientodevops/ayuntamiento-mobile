import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/models/Request.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RequestDetails extends StatefulWidget {
  static final routeName = '/requestdetail';

  const RequestDetails({Key key}) : super(key: key);

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  Widget drawerBox(Request r) {
    DateTime fecha;
    Color color;
    if (r.estatusReclamacion == "Completada") {
      color = Colors.lightGreen;
    } else if (r.estatusReclamacion == "Asignada") {
      color = Colors.orangeAccent;
    } else if (r.estatusReclamacion == "Solicitada") {
      color = Colors.lightBlueAccent;
    }
    if (r.fechaResolucion != null) {
      fecha = DateTime.parse(r.fechaResolucion);
    } else if (r.fechaAsignacion != null) {
      fecha = DateTime.parse(r.fechaAsignacion);
    } else if (r.fechaSolicitud != null) {
      fecha = DateTime.parse(r.fechaSolicitud);
    }
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text('Tipo de solicitud'),
              subtitle: Text(r.tipoReclamacion),
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings, color: color),
              title: Text('Estado'),
              subtitle: Text(r.estatusReclamacion +
                  " el " +
                  DateFormat.yMMMMd('es_PR').format(fecha)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Request;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkOrange,
        iconTheme: IconThemeData(color: AppTheme.white),
        title: Text(
          "Detalle de solicitud ID: #" + args.reclamacionId,
          style: TextStyle(color: AppTheme.white),
        ),
      ),
      // drawer: SettingWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 220,
                child: Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return FadeInImage.assetNetwork(
                      fit: BoxFit.fitWidth,
                      placeholder: 'assets/gallery.png',
                      image: args.images[index],
                    );
                  },
                  itemCount: args.images.length,
                  pagination: SwiperPagination(),
                  control: SwiperControl(),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      args.sector.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    drawerBox(args),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyDarkOrange,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Descripción",
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        args.descripcion,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyDarkOrange,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Localización",
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(double.tryParse(args.latitud),
                                  double.tryParse(args.longitud)),
                              zoom: 15),
                          zoomControlsEnabled: true,
                          markers: <Marker>[
                            Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(double.tryParse(args.latitud),
                                  double.tryParse(args.longitud)),
                            )
                          ].toSet(),
                          zoomGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
