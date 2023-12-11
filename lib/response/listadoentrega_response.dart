import 'dart:convert';

class ListadoEntregaResponse{
    
    String? cuartel;
    String? labor;
    int? cantidad;
    String? nombre;
    String? idcartilla;
    int? identrega;
    
    ListadoEntregaResponse({
        this.cuartel,
         this.labor,
         this.cantidad,
         this.nombre,
         this.idcartilla,
         this.identrega
    });

  
    factory ListadoEntregaResponse.fromJson(Map<String, dynamic> json) => ListadoEntregaResponse(
        cuartel: json["Cuartel"],
        labor: json["Labor"],
        nombre: json["Nombre"],
        cantidad: json["Cantidad"],
        idcartilla: json["IdCartilla"],
        identrega: json["IdEntrega"],
        
    );

    Map<String, dynamic> toJson() => {
        "Cuartel":cuartel,
        "Labor": labor,
        "Nombre": nombre,
        "Cantidad": cantidad,
        "IdCartilla":idcartilla,
        "IdEntrega":identrega
    };
}
