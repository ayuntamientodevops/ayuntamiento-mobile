import 'package:asdn/src/config/app_theme.dart';
import 'package:asdn/src/config/main_full_view.dart';
import 'package:asdn/src/models/Invoices.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/services/request_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceListSection extends StatefulWidget {
  static final routeName = '/invoce';

  const InvoiceListSection(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _InvoiceListSectionState createState() => _InvoiceListSectionState();
}

class _InvoiceListSectionState extends State<InvoiceListSection>
    with TickerProviderStateMixin {
  AnimationController animationController;

  final RequestService requestService = RequestService();
  final AuthenticationService authenticationService = AuthenticationService();
  String statusInvoice;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestService.getInvocesHistory(
          user: authenticationService.getUserLogged()),
      builder: (context, AsyncSnapshot<Invoices> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicatorWidget());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error al cargar facturas"));
        }

        if (snapshot.data == null) {
          return Container(
            margin: EdgeInsets.only(top: 200),
            alignment: Alignment.center,
            child: Text(
              'No existe ninguna factura',
              style: TextStyle(fontSize: 15),
            ),
          );
        }

        Invoices invoices = snapshot.data ?? null;
        return Container(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape:
                        Border(right: BorderSide(color: AppTheme.grey, width: 5)),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.money_off,
                        color: Colors.green,
                      ),
                      subtitle: Text(
                        "Deuda Pendiente: RD\$${invoices.amountDue}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.grey),
                      ),
                      title: Text(
                        "${invoices.defaultTaxReceiptType.description}",
                      ),
                    ),
                  ),
                ),
                invoices.invoices.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: invoices.invoices.length,
                        itemBuilder: (context, index) {
                          Invoice invoice = invoices.invoices[index];
                          return this.cardWidget(invoice: invoice);
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            'No existe ninguna factura',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardWidget({Invoice invoice}) {
    String dateFormat =
        invoice.date.toString().replaceAll("12:00:00 a. m.", "");

    this.statusInvoice = invoice.status.replaceAll("PEND. ","");
    Color colorsText;

    if(this.statusInvoice == "COBRO")
        colorsText = AppTheme.redText;
      else if(this.statusInvoice == "COBRADA")
        colorsText = AppTheme.greenApp;
      else
        colorsText = AppTheme.nearlyBlue;

      return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 400,
            height: 280,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
               child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned(
                    left: 10.0,
                    right: 10.0,
                    child: ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        width: 200.0,
                        height: 450.0,
                        color: AppTheme.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 150.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                          width: 2.0,
                                          color: colorsText),
                                    ),
                                    child: Center(
                                      child: Text(
                                        invoice.status,
                                        style: TextStyle(color: colorsText),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          "No. Factura: " + invoice.number,
                                          style: TextStyle(
                                              color: AppTheme.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: (this.statusInvoice == "COBRO")? const EdgeInsets.only(top: 10.0): const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  "${invoice.description}",
                                  style: TextStyle(
                                      color: AppTheme.grey,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: (this.statusInvoice == "COBRO")? const EdgeInsets.only(top: 10.0): const EdgeInsets.only(top: 18.0),
                                child: Column(
                                  children: <Widget>[
                                    ticketDetailsWidget(
                                        'Tipo Factura:',
                                        "${invoice.taxReceiptType.description}",
                                        'Fecha',
                                        "$dateFormat"),
                                    Padding(
                                      padding: (this.statusInvoice == "COBRO")? const EdgeInsets.only(top: 10.0): const EdgeInsets.only(top: 18.0),
                                      child: Container(
                                        height: 1.0,
                                        color: AppTheme.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 40.0),
                                      child: Center(
                                        child: Text(
                                          "Detalle: " +
                                              invoice.detail[0].tax.description,
                                          style: TextStyle(
                                            color: AppTheme.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  height: 1.0,
                                  color: AppTheme.grey,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 12.0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "RD\$${invoice.total.toString()}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: AppTheme.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),new InkWell(
                                  onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainFullViewer(
                                            identificationPage: "card")));

                                   setInvoiceData(invoice.total, invoice.number);
                                   },
                                   child: Column(children: [
                                     if(this.statusInvoice == "COBRO")
                                         buttonCollect()
                                   ],
                                   )
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Future<String> setInvoiceData(double amount, String invoiceNum) async {

 final prefs = await SharedPreferences.getInstance();
 await prefs.setDouble('amount', amount);
 await prefs.setString('invoiceNum', invoiceNum);
}
Widget buttonCollect()
{
  return  Container(
    alignment: Alignment.centerRight,
    margin: EdgeInsets.symmetric(
        horizontal: 15, vertical: 10),
    child: ElevatedButton(

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
          "PAGAR",
          textAlign: TextAlign.center,
          style:
          TextStyle(fontWeight: FontWeight.bold,color: AppTheme.white),
        ),
      ),
    ),
  );
}

Widget buttonVoid()
  {
    return  Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: 10),
      child: ElevatedButton(
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
                Color.fromARGB(255, 15, 143, 174),
                Color.fromARGB(255, 13, 140, 194)
              ])),
          padding: const EdgeInsets.all(0),
          child: Text(
            "ANULAR",
            textAlign: TextAlign.center,
            style:
            TextStyle(fontWeight: FontWeight.bold,color: AppTheme.white),
          ),
        ),
      ),
    );
  }
  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: AppTheme.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: AppTheme.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height / 2 + 50.0), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2 + 50.0), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
