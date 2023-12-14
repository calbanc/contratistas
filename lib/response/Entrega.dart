import 'dart:convert';

class Entrega{
  int? identrega;
  String? idcartilla;
  String? qr;
  int? cantidad;
  String? fecha;
  String? hora;
  String? swsincronizado;

  Entrega({
    this.identrega,
    this.idcartilla,
    this.qr,
    this.cantidad,
    this.fecha,
    this.hora,
    this.swsincronizado,

  });


  factory Entrega.fromJson(Map<String, dynamic> json) => Entrega(
      identrega: json["IdEntrega"],
      idcartilla: json["IdCartilla"],
      qr: json["Qr"],
      cantidad: json["Cantidad"],
      fecha: json["Fecha"],
      hora:json["Hora"],

      swsincronizado: json["SwSincronizado"],

  );

  Map<String, dynamic> toJson() => {
    "IdEntrega":identrega,
    "IdCartilla": idcartilla,
    "Qr": qr,
    "Cantidad": cantidad,
    "Fecha": fecha,
    "Hora":hora,

    "SwSincronizado": swsincronizado,

  };
}
