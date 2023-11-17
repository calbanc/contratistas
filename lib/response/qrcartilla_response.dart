import 'dart:convert';

class QrCartillaResponse{
    String idcartilla;
    String cuartel;
    String labor;
    String fechainicio;
    String fechatermino;

    QrCartillaResponse({
        required this.idcartilla,
        required this.cuartel,
        required this.labor,
        required this.fechainicio,
        required this.fechatermino,
    });

    factory QrCartillaResponse.fromJson(String str) => QrCartillaResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory QrCartillaResponse.fromMap(Map<String, dynamic> json) => QrCartillaResponse(
        idcartilla: json["idcartilla"],
        cuartel: json["cuartel"],
        labor: json["labor"],
        fechainicio: json["fechainicio"],
        fechatermino: json["fechatermino"],
    );

    Map<String, dynamic> toMap() => {
        "IdCartilla": idcartilla,
        "Cuartel": cuartel,
        "Labor": labor,
        "Fechainicio": fechainicio,
        "Fechatermino": fechatermino,
    };
}
