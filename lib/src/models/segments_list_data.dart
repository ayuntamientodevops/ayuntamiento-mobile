import 'dart:ffi';

class SegmentListData {
  SegmentListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  Object startColor;
  Object endColor;
  List<String> meals;
  int kacl;

  static List<SegmentListData> tabIconsList = <SegmentListData>[
    SegmentListData(
      imagePath: 'assets/home/invoice.png',
      titleTxt: 'Facturas',
      kacl: 10,
      meals: <String>['Consulta', 'tus últimas', '10 factuas.'],
      startColor: 0xff4a70cb,
      endColor: 0xff4a70cb,
    ),
    SegmentListData(
      imagePath: 'assets/home/report.png',
      titleTxt: 'Reporte',
      kacl: 602,
      meals: <String>['Reporta', 'incidentes en', 'tu sector.'],
      startColor: 0xFF213333,
      endColor: 0xFF3A5160,
    ),
    SegmentListData(
      imagePath: 'assets/home/news.png',
      titleTxt: 'Noticias',
      kacl: 602,
      meals: <String>['Enterate de', 'las novedades', 'de tu sector'],
      startColor: 0xffa4c639,
      endColor: 0xffa4c639,
    ),
  ];
}
