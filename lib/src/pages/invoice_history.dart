import 'package:asdn/src/models/Invoices.dart';
import 'package:asdn/src/services/auth_service.dart';
import 'package:asdn/src/services/request_service.dart';
import 'package:asdn/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';

class InvoiceHistory extends StatelessWidget {
  static final routeName = '/invoce';
  InvoiceHistory({Key key}) : super(key: key);
  final RequestService requestService = RequestService();
  final AuthenticationService authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Facturas",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
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
              return Center(
                child: Text(
                  'No existe ninguna factura',
                  style: TextStyle(fontSize: 15),
                ),
              );
            }

            Invoices invoices = snapshot.data ?? null;

            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          Icons.money_off,
                          color: Colors.green,
                        ),
                        subtitle: Text(
                          "Deuda Pendiente: RD\$${invoices.amountDue}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        title: Text(
                          "${invoices.defaultTaxReceiptType.description}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    'Historico de factura',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'No existe ninguna factura',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget cardWidget({Invoice invoice}) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, RequestDetails.routeName,
        //     arguments: request);
      },
      child: SizedBox(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 2,
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            invoice.description,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Fecha Factura :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" ${invoice.date}"),
                    ],
                  ),
                  Divider(),
                  Wrap(
                    children: [
                      Text(
                        "Tipo Factura :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" ${invoice.taxReceiptType.description}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Numero Factura :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" ${invoice.number}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Estado Factura :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" ${invoice.status}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Detalle Factura :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" ${invoice.detail[0].tax.description}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "RD\$${invoice.total.toString()}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
