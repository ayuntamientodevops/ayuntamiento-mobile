import 'package:asdn/src/helpers/helpers.dart';
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("$label",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(DateFormat.yMMMMd('es_PR').format(DateTime.parse(fecha)),
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Tipo: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  r.tipoReclamacion,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text("Estado: ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.circle,
                          size: 12,
                          color: color,
                        ),
                      ),
                    ),
                    TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: r.estatusReclamacion,
                    ),
                  ],
                ),
              )
            ]),
            //
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Request;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detalle de Solicitud",
          style: TextStyle(color: Colors.white),
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
                    getFechas(args),
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
                        color: Constants.orangeDark,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Descripcion",
                              style: TextStyle(
                                  color: Colors.white,
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
                        color: Constants.orangeDark,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Localización",
                              style: TextStyle(
                                  color: Colors.white,
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
