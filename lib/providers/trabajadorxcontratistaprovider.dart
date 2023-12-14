import 'dart:io';
import 'dart:convert';
import 'package:contratistas/response/response.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;


class TrabajadorxContratistaProvider extends ChangeNotifier{
  GlobalKey<FormState> formkey =  GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> formkeylistacartilla =  GlobalKey<DropdownSearchState>();
  final String _baseUrl = "app.verfrut.cl";
  static Database? _database;
  Future<Database> get database async=>_database ??= await initDB();

  
  String IdEmpresa='';
  String Rut='';
  String Digito='';
  String Nombre='';
  String Qr='';
  String _IdCartilla='';
  int cantidad=0;
  String _swunoauno='';
  int _cantidadentregas=0;
  String get IdCartilla=>_IdCartilla;
  String get Swunoauno=>_swunoauno;
  int get CantidadEntregas=>_cantidadentregas;

  set setidcartilla(String idcartilla){
    _IdCartilla=idcartilla;
    notifyListeners();
  }
  set setswunoauno(String swunoauno){
    _swunoauno=swunoauno;
    notifyListeners();
  } 
  
  set setCantidadEntregas(int entrega){
    _cantidadentregas=entrega;
    notifyListeners();
  }

  bool isValidateForm() {
    return formkey.currentState?.validate() ?? false;
  }




bool _isLoading = false;
bool get isLoading => _isLoading;

 set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
}



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

  Future<List<Trabajador>>getlistado(String IdCartilla)async{
    const String _endpoint ='/api-pruebas/public/index.php/api/trabajadorxcontratista/gettrabajadoresbycontratista';
    final Map<String,dynamic>data={'IdCartilla':IdCartilla};
    String parametros=json.encode(data);
    final url = Uri.https(_baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    final response = await http.post(url, body: {"json":parametros});
    final respuesta=trabajadorcontratistaFromJson(response.body);
    return respuesta.trabajador;
  }
  Future<SyncEntregasResponse>sync(EntregaResponse entrega)async{
    const String _endpoint ='/api-pruebas/public/index.php/api/androidcartilladetalle/save';
    final Map<String,dynamic>data={'IdCartilla':entrega.idcartilla,'Qr':entrega.qr,"Fecha":entrega.fecha,"Cantidad":entrega.cantidad,"Nombre_trabajador":entrega.nombre_trabajador,"IdEntrega":entrega.identrega,"Rut":entrega.rut,"IdTrabajadorXContratista":entrega.idtrabajadorxcontratista,"Digito":entrega.digito};
    String parametros=json.encode(data);
    final url = Uri.https(_baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    final response = await http.post(url, body: {"json":parametros});
    final respuesta=SyncEntregasResponse.fromJson(response.body);
    return respuesta;
  }
  

  Future<List<QrCartillaResponse>>getcartillasdisponibles()async{
    
    final now=DateTime.now();
    DateTime fecha = new DateTime(now.year, now.month, now.day);
  
    
    
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE FechaInicio='$fecha' and HoraTermino is null
      ''');
  notifyListeners();
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
  Future<http.Response>synccartillashoras(QrCartillaResponse cartilla)async{
    const String _endpoint ='/api-pruebas/public/index.php/api/androidcartilla/update';
    final Map<String,dynamic>data={'IdCartilla':cartilla.idcartilla,'HoraInicio':cartilla.horainicio,'HoraTermino':cartilla.horatermino};
    String parametros=json.encode(data);
    final url = Uri.https(_baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    final response = await http.post(url, body: {"json":parametros});
    return response;
   /* if(response.statusCode==200){
      return response.body;
    }else{
      return 'Error en consulta';
    }*/



  }
  Future<int>updatecartillafinaltime(String idcartilla) async {
    final db=await database;

    final res=await db.rawUpdate(''' 
      UPDATE CARITLLAS SET SwSincronizado='1' WHERE IdCartilla='$idcartilla'
    ''');
    return res;

  }


  Future<List<QrCartillaResponse>>getcartillastosync(String fecha)async{
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE SwSincronizado='0'
      ''');
    return List.generate(res.length, (index) => QrCartillaResponse(
        idcartilla: res[index]['IdCartilla'],
        cuartel: res[index]['Cuartel'],
        labor:res[index]['Labor'],
        fechainicio: res[index]['FechaInicio'],
        fechatermino: res[index]['FechaTermino'],
        horainicio: res[index]['HoraInicio'],
        horatermino: res[index]['HoraTermino'],
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

Future<List<QrCartillaResponse>>gethoraterminobyidcartilla(String idcartilla)async{
  final db=await database;
  final List<Map<String,dynamic>>res=await db.rawQuery('''
      SELECT * FROM CARTILLAS WHERE IdCartilla='$idcartilla' and HoraTermino is null
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


  Future<int>insertatrabajadorescontratista(Trabajador trabajador)async{
    final db=await database;
    final res=await db.delete('TRABAJADORESXCONTRATISTA',where: 'Qr=?',whereArgs: [trabajador.qr],).then((value)=>db.insert('TRABAJADORESXCONTRATISTA',trabajador.toJson()));
    return res;
  }
 Future<List<Trabajador>?> gettrabajadorbyqr(String qr)async{
    final db=await database;
    final res=await db.query('TRABAJADORESXCONTRATISTA',distinct: true,where: 'Qr=?',whereArgs: [qr] );
    return res.isNotEmpty ? 
          res.map((e) => Trabajador.fromJson(e)).toList()
          :null;
  }

  Future<List<Entrega>?>entrega(Entrega entrega)async{
    final db=await database;
    final res=await db.query('ENTREGAS',distinct: true,where:'Qr=? AND IdCartilla=? AND Fecha=? ',whereArgs: [entrega.qr,entrega.idcartilla,entrega.fecha]);
    notifyListeners();
    return res.isNotEmpty ? 
      res.map((e) => Entrega.fromJson(e)).toList()
      :null ;

  }
  Future<int>insertentry(Entrega entry)async{
    final db=await database;
    final res=await db.insert('ENTREGAS',entry.toJson());
    return res;
  }
  Future<int>updateentry(Entrega entry) async {
    final db=await database;
    int cantidad=entry.cantidad!;
    int? identrega=entry.identrega;
    String? hora=entry.hora;
    final res=await db.rawUpdate(''' 
      UPDATE ENTREGAS SET CANTIDAD= '$cantidad' , SwSincronizado='0',Hora='$hora' WHERE IdEntrega='$identrega'
    ''');
    return res;

  }
  Future<int> updatehorainicio(String idCartilla)async{
    final hora=DateTime.now(); 
    final db=await database;
    final res=await db.rawUpdate(''' 
      UPDATE CARTILLAS SET HoraInicio= '$hora' , SwSincronizado='0' WHERE IdCartilla='$idCartilla'
    ''');
    return res;
  }

   Future<int> updatehoratermino(String idCartilla)async{
    final hora=DateTime.now(); 
    final db=await database;
    final res=await db.rawUpdate(''' 
      UPDATE CARTILLAS SET HoraTermino= '$hora' , SwSincronizado='0' WHERE IdCartilla='$idCartilla'
    ''');
    notifyListeners();
    return res;
  }
Future<int>updateSync(String identrega) async {
    final db=await database;
   
    final res=await db.rawUpdate(''' 
      UPDATE ENTREGAS SET  SwSincronizado='1' WHERE IdEntrega='$identrega'
    ''');
    return res;

  }
  Future<List<EntregaResponse>?> listentregas(String idcartilla)async{
    final db=await database;
    final res=await db.rawQuery(''' 
      
      SELECT SUM(Cantidad) as 'Cantidad'
      FROM ENTREGAS
      WHERE IdCartilla='$idcartilla' 
    ''');
    
      return res.isNotEmpty ? 
        res.map((e) => EntregaResponse.fromJson(e)).toList() 
        :null ;

  }

  Future<List<ListadoEntregaResponse>?> listadoentregas(String idcartilla) async{
    final db=await database;
    final res=await db.rawQuery(''' 
      
      SELECT C.Cuartel,C.Labor,T.Nombre,SUM(E.CANTIDAD) AS 'Cantidad',e.IdCartilla,e.IdEntrega,E.Qr,T.IdTrabXContratista,T.Digito,T.Rut
      FROM ENTREGAS E
      INNER JOIN CARTILLAS C ON E.IdCartilla=C.IdCartilla
      INNER JOIN TRABAJADORESXCONTRATISTA T ON T.Qr=E.Qr
      where e.IdCartilla='$idcartilla' and e.Cantidad>0
      GROUP by C.Cuartel,C.Labor,T.Nombre,e.IdCartilla,E.IdEntrega
    ''');
     return res.isNotEmpty ? 
        res.map((e) => ListadoEntregaResponse.fromJson(e)).toList() 
        :null ;
  }

  Future<List<EntregaResponse>> getentryforsync(String fecha) async{
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery( ''' 
      SELECT E.*,T.Nombre,T.IdTrabXContratista,T.Digito,T.Rut 
      FROM ENTREGAS E
      INNER JOIN TRABAJADORESXCONTRATISTA T ON T.Qr=E.Qr
      WHERE E.Fecha='$fecha' and E.SwSincronizado='0'
    ''');
    return List.generate(res.length, (index) => EntregaResponse(
        identrega:res[index]['IdEntrega'],
        idcartilla:res[index]['IdCartilla'],
        qr: res[index]['Qr'],
        cantidad: res[index]['Cantidad'],
        fecha:res[index]['Fecha'],
        swsincronizado: res[index]['SwSincronizado'],
        nombre_trabajador: res[index]['Nombre'],
        idtrabajadorxcontratista: res[index]['IdTrabXContratista'],
        digito: res[index]['Digito'],
        rut:res[index]['Rut']
    ));

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
}