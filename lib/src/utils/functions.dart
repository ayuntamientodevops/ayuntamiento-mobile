import 'dart:io';

Future<bool> connectionValidate() async {
  try {
    final result = await InternetAddress.lookup('webapi.asdn.gob.do');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}
