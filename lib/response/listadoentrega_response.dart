import 'dart:convert';

class ListadoEntregaResponse{
    
    String? cuartel;
    String? labor;
    int? cantidad;
    String? nombre;
    String? idcartilla;
    int? identrega;
    String? qr;
    String? rut;
    String? digito;
    ListadoEntregaResponse({
        this.cuartel,
         this.labor,
         this.cantidad,
         this.nombre,
         this.idcartilla,
         this.identrega,
         this.qr,
        this.rut,
        this.digito
    });

  
    factory ListadoEntregaResponse.fromJson(Map<String, dynamic> json) => ListadoEntregaResponse(
        cuartel: json["Cuartel"],
        labor: json["Labor"],
        nombre: json["Nombre"],
        cantidad: json["Cantidad"],
        idcartilla: json["IdCartilla"],
        identrega: json["IdEntrega"],
        qr:json["Qr"],
        rut: json["Rut"],
        digito: json["Digito"]
        
    );

    Map<String, dynamic> toJson() => {
        "Cuartel":cuartel,
        "Labor": labor,
        "Nombre": nombre,
        "Cantidad": cantidad,
        "IdCartilla":idcartilla,
        "IdEntrega":identrega,
        "Qr":qr,
        "Rut":rut,
        "Digito":digito

    };
}
