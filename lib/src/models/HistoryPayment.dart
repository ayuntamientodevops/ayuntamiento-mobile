// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';


List<HistoryPayment> requestFromJson(String str) =>
    List<HistoryPayment>.from(json.decode(str).map((x) => HistoryPayment.fromJson(x)));

String requestToJson(List<HistoryPayment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryPayment {
  HistoryPayment({
    this.id,
    this.userName,
    this.card,
    this.expire,
    this.cvv,
    this.amount,
    this.clientIp,
    this.currency,
    this.environment,
    this.idempotencyKey,
    this.invoiceNumber,
    this.merchantId,
    this.terminalId,
    this.referenceNumber,
    this.tax,
    this.tip,
    this.token,
    this.approvalCode,
    this.messageCode,
    this.dateCreated,
    this.userCreated
  });
 String id;
 String userName;
  String card;
  String expire;
  String cvv;
  String amount;
  String clientIp;
  String currency;
  String environment;
  String idempotencyKey;
  String invoiceNumber;
  String merchantId;
  String terminalId;
  String referenceNumber;
  String tax;
  String tip;
  String token;
  String approvalCode;
  String messageCode;
  String dateCreated;
  String userCreated;

  factory HistoryPayment.fromJson(Map<String, dynamic> json) => HistoryPayment(
      id: json["id"],
      userName: json["user_name"],
      card: json["card_number"],
      expire: json["expire"],
      cvv: json["cvv"],
      amount : json["amount"],
      clientIp : json["client_ip"],
      currency : json["currency"],
      environment : json["environment"],
      idempotencyKey : json["idempotency_key"],
      invoiceNumber : json["invoice_number"],
      merchantId : json["merchant_id"],
      terminalId : json["terminal_id"],
      referenceNumber : json["reference_number"],
      tax : json["tax"],
      tip : json["tip"],
      token : json["token"],
      approvalCode : json["approval_code"],
      messageCode : json["message_code"],
      dateCreated : json["date_created"],
      userCreated : json["user_created"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "card": card,
    "expire": expire,
    "cvv": cvv,
    "amount" : amount,
    "clientIp" : clientIp,
    "currency" : currency,
    "environment" : environment,
    "idempotencyKey" : idempotencyKey,
    "invoiceNumber" : invoiceNumber,
    "merchantId" : merchantId,
    "terminalId" : terminalId,
    "referenceNumber" : referenceNumber,
    "tax" : tax,
    "tip" : tip,
    "token" : token,
    "approvalCode" : approvalCode,
    "messageCode" :  messageCode,
    "dateCreated" :  dateCreated,
    "userCreated" :  userCreated
  };
  static Map<String, dynamic> toMap(HistoryPayment historyPayment) => {
    "id": historyPayment.id,
    "userName": historyPayment.userName,
    "card"        : historyPayment.card,
    "expire"      : historyPayment.expire,
    "cvv"         : historyPayment.cvv,
    "amount"      : historyPayment.amount,
    "clientIp"    : historyPayment.clientIp,
    "currency"    : historyPayment.currency,
    "environment" : historyPayment.environment,
    "idempotencyKey"  : historyPayment.idempotencyKey,
    "invoiceNumber"   : historyPayment.invoiceNumber,
    "merchantId"      : historyPayment.merchantId,
    "terminalId"      : historyPayment.terminalId,
    "referenceNumber" : historyPayment.referenceNumber,
    "tax"             : historyPayment.tax,
    "tip"             : historyPayment.tip,
    "token"           : historyPayment.token,
    "approvalCode"    : historyPayment.approvalCode,
    "messageCode"     : historyPayment.messageCode,
    "dateCreated"     : historyPayment.dateCreated,
    "userCreated"     : historyPayment.userCreated
  };
  static String encode(List<HistoryPayment> paymentHistory) => json.encode(
    paymentHistory
        .map<Map<String, dynamic>>((paymentHistory) => HistoryPayment.toMap(paymentHistory))
        .toList(),
  );
  static List<HistoryPayment> decode(String paymentHistory) {
    List<HistoryPayment> list = [];
    final hp = json.decode(paymentHistory);
    for (var item in hp) {
      final r = HistoryPayment.fromJson(item);
      if (r != null) {
        list.add(r);
      }
    }
    return list;
  }
}
