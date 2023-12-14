import 'dart:convert';

class EntregaResponse{
    int? identrega;
    String? idcartilla;
    String? qr;
    int? cantidad;
    String? fecha;
    String? hora;
    String? swsincronizado;
    String? nombre_trabajador;
    String? idtrabajadorxcontratista;
    String? digito;
    String? rut;
    EntregaResponse({
        this.identrega,
         this.idcartilla,
         this.qr,
         this.cantidad,
         this.fecha,
          this.hora,
         this.swsincronizado,
         this.nombre_trabajador,
        this.idtrabajadorxcontratista,
        this.digito,
        this.rut
    });

  
    factory EntregaResponse.fromJson(Map<String, dynamic> json) => EntregaResponse(
        identrega: json["IdEntrega"],
        idcartilla: json["IdCartilla"],
        qr: json["Qr"],
        cantidad: json["Cantidad"],
        fecha: json["Fecha"],
        hora:json["Hora"],
        nombre_trabajador:json["Nombre"],
        swsincronizado: json["SwSincronizado"],
        idtrabajadorxcontratista: json["IdTrabXContratista"],
        digito: json["Digito"],
        rut:json["Rut"]
    );

    Map<String, dynamic> toJson() => {
        "IdEntrega":identrega,
        "IdCartilla": idcartilla,
        "Qr": qr,
        "Cantidad": cantidad,
        "Fecha": fecha,
        "Hora":hora,
        "Nombre":nombre_trabajador,
        "SwSincronizado": swsincronizado,
        "IdTrabXContratista":idtrabajadorxcontratista,
        "Digito":digito,
        "Rut":rut
    };
}
