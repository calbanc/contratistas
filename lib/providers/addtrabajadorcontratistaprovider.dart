
import 'dart:io';
import 'dart:convert';
import 'package:contratistas/response/response.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AddTrabajadorContratistaProvider extends ChangeNotifier{
  GlobalKey<FormState> formaddkey =  GlobalKey<FormState>();
  TextEditingController controlladornombre=TextEditingController();
  String Rut='';
  String Digito='';
  String Nombre='';
  String Qr='';
  static Database? _database;
  int cantidad=0;
  int _cantidadentregas=0;
  int get CantidadEntregas=>_cantidadentregas;

  bool _validarut=false;
  bool get validarut=>_validarut;
  

  bool isValidateForm() {
    return formaddkey.currentState?.validate() ?? false;
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  set validarut(bool value){
    _validarut=value;
    notifyListeners();
  } 
  set setCantidadEntregas(int entrega){
    _cantidadentregas=entrega;
    notifyListeners();
  }

  Future<Database> get database async=>_database ??= await initDB();
  Future<Database> initDB() async{

    Directory documentsDirectory=await getApplicationDocumentsDirectory();
    final path=join(documentsDirectory.path,'VerfrutContratista.db');

    return await openDatabase(
      path,
      version:1,
      onUpgrade: (Database db,int olverion,int newverion)async{
      },
      onOpen:(db)=>{},
    );
  }


  Future<int>insertnewtrabajadorcontratista(Trabajador trabajador)async{
    final db=await database;
    String rut=trabajador.rut!;
    String qr=trabajador.qr;
    final res1=await db.query('TRABAJADORESXCONTRATISTA',where:'Rut=?',whereArgs: [rut]);
    List<Trabajador>listado=res1.map((e) => Trabajador.fromJson(e)).toList();
    if(listado.length>0){
      final res2=await db.rawUpdate('''UPDATE TRABAJADORESXCONTRATISTA SET Qr= '$qr' WHERE Rut='$rut' ''');
      final res3=await db.query('TRABAJADORESXCONTRATISTA',where:'Rut<>? AND Qr=? ' ,whereArgs: [rut,qr]);
      List<Trabajador>listado1=res3.map((e) => Trabajador.fromJson(e)).toList();
      if(listado1.length>0){
        String newqr=listado1[0].rut!;
        final res2=await db.rawUpdate('''UPDATE TRABAJADORESXCONTRATISTA SET Qr= '$newqr' WHERE Rut='$newqr' ''');
      }

      return res2;

    }else{
      final res=await db.insert('TRABAJADORESXCONTRATISTA', trabajador.toJson());
      return res;
    }



  }
  Future<int>insertentry(Entrega entry)async{
    final db=await database;
    final res=await db.insert('ENTREGAS',entry.toJson());
    return res;
  }
    Future<List<QrCartillaResponse>>getcartillasdisponibles()async{
    
    final now=DateTime.now();
    DateTime fecha = new DateTime(now.year, now.month, now.day);
  
    
    
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE FechaInicio='$fecha' and HoraTermino is null 
      ''');

    return List.generate(res.length, (index) => QrCartillaResponse(
        idcartilla: res[index]['IdCartilla'],
        cuartel: res[index]['Cuartel'],
        labor:res[index]['Labor'],
        fechainicio: res[index]['FechaInicio'],
        fechatermino: res[index]['FechaTermino'],
        swunoauno: res[index]['SwUnoaUno'],
        swSincronizado: res[index]['SwSincronizado']
    ));
  }
  Future<List<QrCartillaResponse>>getfechainiciobyidcartilla(String idcartilla)async{
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE IdCartilla='$idcartilla' and HoraInicio is null
      ''');

    return List.generate(res.length, (index) => QrCartillaResponse(
        idcartilla: res[index]['IdCartilla'],
        cuartel: res[index]['Cuartel'],
        labor:res[index]['Labor'],
        fechainicio: res[index]['FechaInicio'],
        fechatermino: res[index]['FechaTermino'],
        swunoauno: res[index]['SwUnoaUno'],
        swSincronizado: res[index]['SwSincronizado']
    ));
  }
  Future<int> updatehorainicio(String idCartilla)async{
    final hora=DateTime.now();
    final db=await database;
    final res=await db.rawUpdate(''' 
      UPDATE CARTILLAS SET HoraInicio= '$hora' , SwSincronizado='0' WHERE IdCartilla='$idCartilla'
    ''');
    return res;
  }
  Future<List<Trabajador>?>gettrabajadorbyrut(String rut)async{
    final db=await database;
    final res=await db.rawQuery(
        ''' SELECT * FROM TRABAJADORESXCONTRATISTA WHERE Rut='$rut' '''
    );
    return res.isNotEmpty?
    res.map((e) => Trabajador.fromJson(e)).toList()
        :null;
  }
}