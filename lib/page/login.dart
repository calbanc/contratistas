import 'package:contratistas/page/page.dart';
import 'package:contratistas/providers/db_provider.dart';
import 'package:contratistas/providers/qrprovider.dart';
import 'package:contratistas/response/response.dart';
import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';



class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FutureBuilder(
              future: DBProvider.db.getcartillasdisponibles(), builder:
          (BuildContext context, AsyncSnapshot<List<QrCartillaResponse>?> snapshot) {
            if(snapshot.data==null){
              return Container();
            }else{
            int datos=snapshot.data!.length;
            List<QrCartillaResponse>lista=snapshot.data!;
            if(datos>0){
              Future.microtask(() => {
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: ( _, __ , ___ ) => MainDashboard(lista: lista,),
                    transitionDuration:const Duration( seconds: 3)
                )
                )

              });
            }
            return Container();

            }
          }),

          
          const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Image(image: AssetImage('assets/verfrut.png'),)
          ),
          GestureDetector(
            onTap: ()async{

              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
              
              
              try{
                final split=barcodeScanRes.split("|");
                String idcartilla=split[0];
                String cuartel=split[1];
                String labor=split[2];
                String fechainicio=split[3];
                String swunoauno=split[4];
                var datefechainicio=DateTime.parse(fechainicio);

                final now=DateTime.now();
                DateTime today = new DateTime(now.year, now.month, now.day);
   
                
                if( today.compareTo(datefechainicio)==0){
                //if(datefechatermino.difference(today).inDays>0){//
                  final qr=QrCartillaResponse(
                    idcartilla: idcartilla,
                    cuartel: cuartel,
                    labor: labor,
                    fechainicio: fechainicio,
                    fechatermino: fechainicio,
                    swunoauno:swunoauno,
                    swSincronizado: '0'

                  ) ;
                  
                  final respuesta= await DBProvider.db.consultaqr(qr);

                  if(respuesta.length<1) await DBProvider.db.insertarqr(qr);
                  List<QrCartillaResponse>lista=await DBProvider.db.getcartillasdisponibles();

                  Future.microtask(() => {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                        pageBuilder: ( _, __ , ___ ) => MainDashboard(lista: lista,),
                        transitionDuration:const Duration( seconds: 3)
                    )
                    )

                  });
                }else{
                   showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Qr Invalido"),
                    content: new Text("Estimado usuario QR escaneado no es valido, fecha de termino ya concluida "),
                   
                  )
                );
                }
                 
              
              }catch(e) {
                  // make it explicit that this function can throw exceptions
                  
                 showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Qr Invalido"),
                    content: new Text("Estimado usuario QR escaneado no es valido"+e.toString()),
                   
                  )
                );
              //   rethrow;
              }
            },
            child:Image(image: AssetImage('assets/qrlogin.png'),width: MediaQuery.of(context).size.width*0.7,) ,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('Escanea tu qr para ingresar',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900,fontSize: 18),),),
          )
        ],),
    );

  
    
  }
  

  
}