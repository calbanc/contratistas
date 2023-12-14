import 'package:contratistas/page/page.dart';
import 'package:contratistas/providers/provider.dart';
import 'package:contratistas/response/qrcartilla_response.dart';
import 'package:contratistas/response/response.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contratistas/providers/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Dashboard extends StatelessWidget {

  Dashboard({super.key,required this.lista});
  List<QrCartillaResponse> lista;
  @override
  Widget build(BuildContext context) {
    final trabajadorcontratisprovider=Provider.of<TrabajadorxContratistaProvider>(context);
    final conexionprovider=Provider.of<Connectivity_provider>(context);
    final size=MediaQuery.of(context).size;
    TextEditingController controlladorcantidad=TextEditingController();
    searchentry(List<Trabajador>?listatrabajador)async {


      final date=DateFormat('dd/MM/yyyy').format(DateTime.now());
      final hora=DateTime.now();
      
      if(trabajadorcontratisprovider.Swunoauno=="1"){
              Entrega entrega=Entrega(
                  idcartilla: trabajadorcontratisprovider.IdCartilla,
                  qr: listatrabajador![0].qr,
                  cantidad: 1,
                  fecha: date,
                  hora:hora.toString() ,
                  swsincronizado: '0'
              );

              List<Entrega>? listaentregado=await trabajadorcontratisprovider.entrega(entrega);

              if(listaentregado==null){
                final insert=await trabajadorcontratisprovider.insertentry(entrega);
                List<QrCartillaResponse>?fechainiciocartilla=await trabajadorcontratisprovider.getfechainiciobyidcartilla(trabajadorcontratisprovider.IdCartilla);
                fechainiciocartilla==null || fechainiciocartilla.length==0 ? null
                    : trabajadorcontratisprovider.updatehorainicio(trabajadorcontratisprovider.IdCartilla) ;
                if(insert==1){
                  Fluttertoast.showToast(
                                        msg: "Insertado correctamente",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[300],
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                  );
                }
                
              }else{     
                DateTime horaentrega=DateTime.parse(listaentregado[0].hora!);
                Duration diff1 = hora.difference(horaentrega);
                
                if(diff1.inMinutes>1){
                  Entrega nuevaentrega=Entrega(identrega: listaentregado[0].identrega,idcartilla: listaentregado[0].idcartilla,
                  qr: listaentregado[0].qr,cantidad: listaentregado[0].cantidad!+1,fecha: date,hora:hora.toString(),swsincronizado: '0');
                  final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                  List<QrCartillaResponse>?fechainiciocartilla=await trabajadorcontratisprovider.getfechainiciobyidcartilla(trabajadorcontratisprovider.IdCartilla);
                  fechainiciocartilla==null || fechainiciocartilla.length==0 ? null
                  : trabajadorcontratisprovider.updatehorainicio(trabajadorcontratisprovider.IdCartilla) ;

                  Fluttertoast.showToast(
                      msg: "Insertado correctamente",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey[300],
                      timeInSecForIosWeb: 1,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );
                }else{
                    Fluttertoast.showToast(
                        msg: "Entrega consecutiva,debe esperar un minuto",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[300],
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                }
               
              
              }

                     
      }else{

         
        Entrega entrega=Entrega(
            idcartilla: trabajadorcontratisprovider.IdCartilla,
            qr: listatrabajador![0].qr,
            cantidad: 1,
            fecha: date,
            hora:hora.toString(),
            swsincronizado: '0');

      List<Entrega>? listaentregado=await trabajadorcontratisprovider.entrega(entrega);
       showDialog(
          context: context,
           builder: (context)=>AlertDialog(
            title: Text('Cantidad de entregas'),
            
            content: TextField(
              controller: controlladorcantidad,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Ingrese cantidad de entregas'),
            ),

            actions: [
              ElevatedButton(onPressed: ()async {

                if(listaentregado==null){
                  entrega.cantidad=int.parse( controlladorcantidad.text);
                  final insert=await trabajadorcontratisprovider.insertentry(entrega);
                  List<QrCartillaResponse>?fechainiciocartilla=await trabajadorcontratisprovider.getfechainiciobyidcartilla(trabajadorcontratisprovider.IdCartilla);
                  fechainiciocartilla==null || fechainiciocartilla.length==0 ? null
                      : trabajadorcontratisprovider.updatehorainicio(trabajadorcontratisprovider.IdCartilla) ;

                  if(insert==1){
                        Fluttertoast.showToast(
                                              msg: "Insertado correctamente",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.grey[300],
                                              timeInSecForIosWeb: 1,
                                              textColor: Colors.black,
                                              fontSize: 16.0
                                          );
                      }
                }else{
                  DateTime horaentrega=DateTime.parse(listaentregado![0].hora!); 
                  Duration diff1 = hora.difference(horaentrega);

                  if(diff1.inMinutes>1){
                  Entrega nuevaentrega=Entrega(identrega: listaentregado[0].identrega,idcartilla: listaentregado[0].idcartilla,
                  qr: listaentregado[0].qr,cantidad: listaentregado[0].cantidad!+int.parse(controlladorcantidad.text),fecha: date,hora:hora.toString(),swsincronizado: '0');
                  final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                   Fluttertoast.showToast(
                                              msg: "Insertado correctamente",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.grey[300],
                                              timeInSecForIosWeb: 1,
                                              textColor: Colors.black,
                                              fontSize: 16.0
                                          );
                  }else{
                     Fluttertoast.showToast(
                                        msg: "Entrega consecutiva,debe esperar un minuto",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[300],
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                  }

                
      
                }
                Navigator.pop(context);

              }, child: Text('Registrar'))
            ],
           ));
              Fluttertoast.showToast(
                  msg: "Insertado correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[300],
                  timeInSecForIosWeb: 1,
                  textColor: Colors.black,
                  fontSize: 16.0
              );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:const Text('VERFTWORK',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          MaterialButton(onPressed: (){},child: Icon(Icons.settings),)
        ],
      ),
      body:
          Column(
            children: [
              Container(
                    padding:EdgeInsets.only(top: 10,left: 20,right: 20) ,
                     width: size.width,
                     height: 75,
                       child: CupertinoButton(
                         borderRadius: BorderRadius.circular(20),
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync),
                           Text('Sincronizar',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                         ],),
                        color: Colors.green[700],
                         onPressed: () async {

                           bool conexion=await conexionprovider.isOnlineNet();
                           if(conexion){

                             showDialog(context: context, builder: ((context) {
                               return Center(child: CupertinoAlertDialog(
                                 content: Row(children: const [
                                   CupertinoActivityIndicator(),
                                   Text('Sincronizando trabajadores'),
                                 ],),
                               ),);
                             }));
                             List<Trabajador> respuesta=await trabajadorcontratisprovider.getlistado(this.lista![0].idcartilla);

                             respuesta.forEach((element) async=> {
                               await trabajadorcontratisprovider.insertatrabajadorescontratista(element)
                             });
                             Navigator.of(context, rootNavigator: true).pop();

                             final today= DateFormat('dd/MM/yyyy').format(DateTime.now());

                             List<QrCartillaResponse>?listacartillasdisponible=await trabajadorcontratisprovider.getcartillastosync(today);
                             if(listacartillasdisponible.length>0){
                               http.Response respuestasynchora;
                               CartillaUpdateResponse respuestacuerpo;
                               listacartillasdisponible.forEach((element) async =>{

                                 //print( await trabajadorcontratisprovider.synccartillashoras(element)),
                                 respuestasynchora=await trabajadorcontratisprovider.synccartillashoras(element),

                                 if(respuestasynchora.statusCode==200){
                                   respuestacuerpo=CartillaUpdateResponse.fromJson(json.decode(respuestasynchora.body)),


                                   await trabajadorcontratisprovider.updatecartillafinaltime(respuestacuerpo.cartilla)

                                 }

                               });
                             }



                             List<EntregaResponse>? listforsync=await trabajadorcontratisprovider.getentryforsync(today);
                              if(listforsync.length<1){
                                showDialog(context: context, builder: ((context) {
                               return Center(child: CupertinoAlertDialog(
                                 content: Row(children: const [
                                   Text('Sin Entregas por sincronizar'),
                                 ],),
                               ),);
                             }));
                            }else{
                              SyncEntregasResponse respuestasync;
                              listforsync.forEach((element)async=>{
                                respuestasync=await trabajadorcontratisprovider.sync(element),
                                if(respuestasync.status=="ok"){
                                  await trabajadorcontratisprovider.updateSync(respuestasync.cartilladetalle.idEntrega.toString())
                                }
                              });
                            }




                           }else{                            
                             Fluttertoast.showToast(
                                 msg: "Estimado usuario no tiene conexion para sincronizar datos",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 backgroundColor: Colors.grey[300],
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 fontSize: 16.0
                             );
                           }
                         },),

                   ),
              const Padding(padding: EdgeInsets.only(top: 10),child: Text('Cartillas',textAlign: TextAlign.start,),),
              Row(children: [

                Container(
                    width:size.width*0.7,
                    child: FutureBuilder(
                      future: trabajadorcontratisprovider.getcartillasdisponibles() ,
                      builder: (BuildContext context,AsyncSnapshot<List<QrCartillaResponse>?>snapshot) {
                        if(snapshot.data==null){
                          return CupertinoActivityIndicator();
                        }else{
                          List<QrCartillaResponse> lista=snapshot.data!;
                          return DropdownSearch<QrCartillaResponse>(
                            key: trabajadorcontratisprovider.formkeylistacartilla,
                            items:lista,
                            onChanged: (QrCartillaResponse? value) =>{
                              trabajadorcontratisprovider.setidcartilla=value!.idcartilla,
                              trabajadorcontratisprovider.setswunoauno=value!.swunoauno,
                            } ,
                            itemAsString: (QrCartillaResponse qr)=>qr.cuartel,
                          );
                        }
                      }


                    ),
                ),
           /*     Container(
                  width: size.width*0.7,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownSearch<QrCartillaResponse>(
                  items:lista!,
                  onChanged: (QrCartillaResponse? value) =>{
                    trabajadorcontratisprovider.setidcartilla=value!.idcartilla,
                    trabajadorcontratisprovider.setswunoauno=value!.swunoauno,
                  } ,
                  itemAsString: (QrCartillaResponse qr)=>qr.cuartel,
                )
                ),*/
                Container(
                  width: size.width*0.3,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                      textStyle:const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800)), 
                     child:  const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(Icons.add),
                        SizedBox(width: 4,),
                        Text('Add')
                      ]),
                      onPressed: () async {
                        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
                        try{
                          final split=barcodeScanRes.split("|");
                          String idcartilla=split[0];
                          String cuartel=split[1];
                          String labor=split[2];
                          String fechainicio=split[3];
                          String fechatermino=split[4];
                          String swunoauno=split[5];
                          var datefechainicio=DateTime.parse(fechainicio);
                          final now=DateTime.now();
                          DateTime today = new DateTime(now.year, now.month, now.day);                
                          if( today.compareTo(datefechainicio)==0){
                            final qr=QrCartillaResponse(
                              idcartilla: idcartilla,
                              cuartel: cuartel,
                              labor: labor,
                              fechainicio: fechatermino,
                              fechatermino: fechatermino,
                              swunoauno: swunoauno,
                              swSincronizado: '0'
                            ) ;
                            final respuesta= await trabajadorcontratisprovider.consultaqr(qr);
                            if(respuesta.length<1) {
                              await trabajadorcontratisprovider.insertarqr(qr);
                              this.lista.add(qr);
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: new Text("Qr Cartilla"),
                                    content: new Text("Estimado usuario QR escaneado ya fue registrado anteriormente"),

                                  )
                              );
                            }

                          }else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: new Text("Qr Invalido"),
                                content: new Text("Estimado usuario QR escaneado no es valido, fecha de termino ya concluida "),
                              
                              )
                            );
                          }
                        }catch(e){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: new Text("Qr Invalido"),
                                content: new Text("Estimado usuario QR escaneado no es valido, fecha de termino ya concluida "),
                              
                              )
                            );
                        }
                      },
                    )
                )
              ],),
              
              const SizedBox(height: 20,),  
                  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(future: trabajadorcontratisprovider.listentregas(trabajadorcontratisprovider.IdCartilla),
                   builder: (BuildContext context,AsyncSnapshot<List<EntregaResponse>?>snapshot){
                      if(snapshot.data==null){
                        return Text('0');
                      }else{
                        String cantidadentregas=snapshot.data![0].cantidad.toString();
                        return Text(cantidadentregas == "null" ?'0':cantidadentregas,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),);
                      }
                  }),

                ],
              ),   
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Entregas',style: TextStyle(fontSize: 20),),
                ],
              ),
              const SizedBox(height: 20,),
                CupertinoButton(
                  color: Colors.blueGrey,
                  child: const Text('Cerrar Cartilla',),
                  onPressed: ()async{

                    List<QrCartillaResponse>?fechahoratermino=await trabajadorcontratisprovider.gethoraterminobyidcartilla(trabajadorcontratisprovider.IdCartilla);
                    fechahoratermino==null || fechahoratermino.length==0 ? null
                        : trabajadorcontratisprovider.updatehoratermino(trabajadorcontratisprovider.IdCartilla) ;
                    trabajadorcontratisprovider.formkeylistacartilla.currentState!.clear();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text("Cierre de planilla"),
                          content: new Text("Planilla Cerrada correctamente"),

                        )


                    );

                  },
                ),
                const SizedBox(height: 20,),
                 FutureBuilder(future: trabajadorcontratisprovider.listadoentregas(trabajadorcontratisprovider.IdCartilla), 
                builder: (BuildContext context,AsyncSnapshot<List<ListadoEntregaResponse>?>snapshot){
                    if(snapshot.data==null){
                        return CupertinoActivityIndicator();
                    }else{
                      List<ListadoEntregaResponse>listado= snapshot.data!;           
                      return _widgetlistado(listado:listado);

                    }
                  }
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        
                        height: 72,
                        width: size.width,
                                  
                          child: ElevatedButton.icon(
                            
                            icon: Icon(Icons.qr_code),
                            label: Text('ESCANEAR TRABAJADOR'),
                            onPressed: ()async{

                              if(trabajadorcontratisprovider.IdCartilla==''){
                                Fluttertoast.showToast(
                                 msg: "Debe seleccionar una Cartilla",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 backgroundColor: Colors.grey[300],
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 fontSize: 16.0
                                );
                                return;
                              }
                                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', true, ScanMode.QR);
                                if(barcodeScanRes!="-1"){
                                List<Trabajador>? lista=await trabajadorcontratisprovider.gettrabajadorbyqr(barcodeScanRes);
                                 lista==null ? Future.microtask(() => {
                                  Navigator.pushReplacement(context, PageRouteBuilder(
                                    pageBuilder: ( _, __ , ___ ) => AddTrabajador(qr:barcodeScanRes,idcartilla:trabajadorcontratisprovider.IdCartilla,swtipoescan:trabajadorcontratisprovider.Swunoauno),
                                    transitionDuration:const Duration( seconds: 1)
                                    )
                                  )
                  
                                }):searchentry(lista);
                                }
                                
                                
                            }),
                        ),
                    ),
                ),
                 

            ],
          )


    );

  }
}

class _widgetlistado extends StatelessWidget {
  final List<ListadoEntregaResponse> listado;
  const _widgetlistado({super.key,required this.listado});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
        height: 400,
        width: size.width*0.9,
        child: ListView.builder(
          itemCount: listado.length,
          itemBuilder: ((context,index){
            String? labor=listado[index].labor;
            String? nombretrabajador=listado[index].nombre;
            int? cantidad=listado[index].cantidad;
            return   GestureDetector(

              onTap: (){
                  Navigator.push(context,  MaterialPageRoute(
                  builder: ((context) =>  DetailEntrega(lista:listado[index]))));
              },

              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(8),right: Radius.circular(8))),
                      color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                  const SizedBox(width: 20,height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:const FadeInImage(
                      width: 60,
                      height: 50,
                      image: AssetImage('assets/verfrutgreen.png'),
                                    placeholder: AssetImage('assets/verfrutgreen.png'),
                    ),
                  ),
                  const SizedBox(width: 40,height: 20,),
                  Column(
                    children: [
                    const SizedBox(height: 5,),
                    Text(nombretrabajador!,style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w800),),
                    const SizedBox(height:5),
                    Text('Entregas: '+cantidad.toString(),style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5),
                    Text('Labor: '+labor.toString(),style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,)
                  ],)
            
                  
                ],),
              ),
            );

          }), 
        ),

      
    );
    

    
  }
}