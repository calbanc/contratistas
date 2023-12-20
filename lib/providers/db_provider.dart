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
            FechaTermino TEXT,
            SwUnoaUno TEXT,
            HoraInicio TEXT,
            HoraTermino TEXT,
            SwSincronizado TEXT
            )
            '''
          );


          await db.execute(
            '''
            CREATE TABLE TRABAJADORESXCONTRATISTA(
              
              IdEmpresa TEXT,
              Rut TEXT,
              Digito TEXT,
              Nombre TEXT,
              Qr TEXT,
              Fecha TEXT,
              IdTrabXContratista TEXT
            )
            '''
          );

          await db.execute('''
            CREATE TABLE ENTREGAS(
              IdEntrega integer primary key,
              IdCartilla TEXT,
              Qr TEXT,
              Cantidad integer,
              Fecha TEXT,
              Hora TEXT,
              SwSincronizado TEXT
            )


          ''');


        },
        onUpgrade: (Database db,int olversion,int newverion)async{
          if (olversion < newverion) {

            // you can execute drop table and create table
          //  await db.execute("ALTER TABLE TRABAJADORESXCONTRATISTA ADD COLUMN IdTrabXContratista TEXT");
          }
        }
    );
  }


  Future<List<QrCartillaResponse>> consultaqr  (QrCartillaResponse qrcartilla)async{
    String idcartilla=qrcartilla.idcartilla;
   
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE IdCartilla='$idcartilla'  and HoraTermino is null
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

  Future<int>insertarqr(QrCartillaResponse qrcartilla)async{

    final db=await database;
    final res=await db.insert('CARTILLAS', qrcartilla.toMap());
    return res;
  }



  Future<List<QrCartillaResponse>>getcartillasdisponibles()async{

    final now=DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    String fecha=today.toString();
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE FechaInicio='$fecha'  
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


}