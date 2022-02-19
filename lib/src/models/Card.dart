// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';

Card profilesFromJson(String str) => Card.fromJson(json.decode(str));

class Card {
  Card({
    this.card,
    this.expire,
    this.cvv
  });

  String card;
  String expire;
  String cvv;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    card: json["card"],
    expire: json["expire"],
    cvv: json["cvv"]

  );

  Map<String, dynamic> toJson() => {
    "card": card,
    "expire": expire,
    "cvv": cvv
  };
}


