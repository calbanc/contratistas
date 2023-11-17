import 'dart:io';

import 'package:contratistas/response/qrcartilla_response.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBProvider extends ChangeNotifier{
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  static Database? _database;
  static final DBProvider db=DBProvider._();
  DBProvider._();

  Future<Database> get database async=>_database ??= await initDB();

  Future<Database> initDB() async{
    Directory documentsDirectory=await getApplicationDocumentsDirectory();
    final path=join(documentsDirectory.path,'VerfrutContratista.db');
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db)=>{},
        onCreate: (Database db,int version)async{
          await db.execute(
            '''
            CREATE TABLE CARTILLAS(
            IdCartilla TEXT,
            Cuartel TEXT,
            Labor TEXT,
            FechaInicio TEXT,
            FechaTermino TEXT)
            '''
          );
        }
    );
  }


  
  Future<List<QrCartillaResponse>> consultaqr  (QrCartillaResponse qrcartilla)async{
    String idcartilla=qrcartilla.idcartilla;
   
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE IdCartilla='$idcartilla'  
      ''');
    return List.generate(res.length, (index) => QrCartillaResponse(
      idcartilla: res[index]['IdCartilla'],
      cuartel: res[index]['Cuartel'],
      labor:res[index]['Labor'],
      fechainicio: res[index]['FechaInicio'],
      fechatermino: res[index]['FechaTermino']
    ));
  } 

  Future<int>insertarqr(QrCartillaResponse qrcartilla)async{

    final db=await database;
    final res=await db.insert('CARTILLAS', qrcartilla.toMap());
    return res;
  }


  Future<List<QrCartillaResponse>>getcartillasdisponibles()async{
    String fecha=DateTime.now().toString();
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE FechaTermino>='$fecha'  
      ''');

    return List.generate(res.length, (index) => QrCartillaResponse(
        idcartilla: res[index]['IdCartilla'],
        cuartel: res[index]['Cuartel'],
        labor:res[index]['Labor'],
        fechainicio: res[index]['FechaInicio'],
        fechatermino: res[index]['FechaTermino']
    ));
  }


}