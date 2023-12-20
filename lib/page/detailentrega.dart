import 'package:contratistas/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../response/response.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailEntrega extends StatelessWidget {
  
  final lista;
  const DetailEntrega({super.key,required this.lista});
  
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_)=> TrabajadorxContratistaProvider(),
      child: _detailentrega(listado: lista,),
    );

    
  }
}

class _detailentrega extends StatelessWidget {
  final listado;
  const _detailentrega({super.key,required this.listado});

  @override
  Widget build(BuildContext context) {
     TextEditingController controlladoridentrega=TextEditingController(text:listado.identrega.toString());
     TextEditingController controlladorcartilla=TextEditingController(text:listado.idcartilla);
     TextEditingController controlladornombre=TextEditingController(text:listado.nombre);
     TextEditingController controlladorcantidad=TextEditingController(text:listado.cantidad.toString());
     TextEditingController controlladorlabor=TextEditingController(text:listado.labor);
     TextEditingController controlladorqr=TextEditingController(text:listado.qr);
     TextEditingController controlladorrut=TextEditingController(text:listado.rut);
     TextEditingController controlladordigito=TextEditingController(text:listado.digito);
     FocusNode f1 = FocusNode();





     final trabajadorcontratisprovider=Provider.of<TrabajadorxContratistaProvider>(context);

    return Scaffold(
       appBar: AppBar(title:const Text('Detalle Entrega')),
       body: SingleChildScrollView(
         child: Column(
            children: [

               Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controlladoridentrega,
                    enabled: false,
                    decoration:const InputDecoration(filled: true,
                        fillColor: Color.fromARGB(255, 239, 239, 240),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                        labelText: "Id de Entrega",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                    ),

                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controlladorqr,
                  enabled: false,
                  decoration:const InputDecoration(filled: true,
                      fillColor: Color.fromARGB(255, 239, 239, 240),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                      labelText: "Qr",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus)async{
                      if(focus==false){
                        //consultamos el trabajador en la base de datos
                        List<Trabajador>?listatra=await trabajadorcontratisprovider.gettrabajadorbyrut(controlladorrut.text);
                        if(listatra!.length>0){
                          controlladornombre.text=listatra![0].nombre!;

                        }
                        print(listatra![0].nombre);
                      }
                    },
                    child: TextFormField(
                      controller: controlladorrut,
                      onChanged: (String value){controlladorrut.text=value;},
                      decoration:const InputDecoration(filled: true,
                          fillColor: Color.fromARGB(255, 239, 239, 240),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                          labelText: "Rut Trabajador",
                          labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                      ),

                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controlladordigito,

                  decoration:const InputDecoration(filled: true,
                      fillColor: Color.fromARGB(255, 239, 239, 240),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                      labelText: "Digito",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                  ),

                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controlladorcartilla,
                    enabled: false,
                    decoration:const InputDecoration(filled: true,
                        fillColor: Color.fromARGB(255, 239, 239, 240),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                        labelText: "Id de Cartilla",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                    ),

                  ),
                
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controlladorlabor,
                    enabled: false,
                    decoration:const InputDecoration(filled: true,
                        fillColor: Color.fromARGB(255, 239, 239, 240),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                        labelText: "Labor",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                    ),

                  ),
                
              ),
              
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controlladornombre,
                    enabled: true,
                    decoration:const InputDecoration(filled: true,
                        fillColor: Color.fromARGB(255, 239, 239, 240),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                        labelText: "Trabajador",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                    ),

                  ),
                
              ),
              
             Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controlladorcantidad,
                    enabled: true,
                    keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                    onChanged: (String value){
                      controlladorcantidad.text=value;
                    },
                    decoration:const InputDecoration(filled: true,
                        fillColor: Color.fromARGB(255, 239, 239, 240),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                        labelText: "Entregas",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                    ),

                  ),
                
              ),
              const SizedBox(width: 20,height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800]

                      ),
                    onPressed: ()async{
                      
                      int cantidad=listado.cantidad;
                      final fecha=DateFormat('dd/MM/yyyy').format(DateTime.now());
                      final hora=DateTime.now();
                      if(cantidad==1){
                        //Seteamos a 0
                        cantidad=0;


                        Entrega nuevaentrega=Entrega(identrega: listado.identrega,idcartilla: listado.idcartilla,
                        qr: listado.qr,cantidad: cantidad,fecha: fecha,hora: hora.toString(),swsincronizado: '0');
                        final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                      }else{
                        cantidad=cantidad-1;

                        Entrega nuevaentrega=Entrega(identrega: listado.identrega,idcartilla: listado.idcartilla,
                        qr: listado.qr,cantidad: cantidad,fecha: fecha,hora:hora.toString(),swsincronizado: '0');
                        final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                        
                      }
                       Fluttertoast.showToast(
                                   msg: "Entregas disminuidas",
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.BOTTOM,
                                   backgroundColor: Colors.grey[300],
                                   timeInSecForIosWeb: 1,
                                   textColor: Colors.black,
                                   fontSize: 16.0
                               );
                    },
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.sync_rounded),
                      SizedBox(width: 8,height: 8,),
                      Text('Actualizar')
                    ],)
                    
                  ),
                ),
                const SizedBox(height: 8,width: 8,),
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 60,
                  
                  child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900]
                  ),

                    onPressed: ()async {
                        int cantidad=listado.cantidad;
                    
                        cantidad=0;
                        final date=DateFormat('dd/MM/yyyy').format(DateTime.now());
                        Entrega nuevaentrega=Entrega(identrega: listado.identrega,idcartilla: listado.idcartilla,
                        qr: listado.qr,cantidad: cantidad,fecha: date,swsincronizado: '0');
                        final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                        Fluttertoast.showToast(
                                   msg: "Entregas eliminadas",
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.BOTTOM,
                                   backgroundColor: Colors.grey[300],
                                   timeInSecForIosWeb: 1,
                                   textColor: Colors.black,
                                   fontSize: 16.0
                               );
                    },
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_delete),
                        SizedBox(width: 8,height: 8,),
                        Text('Eliminar')
                      ],
                    )
                    
                  ),
                ),
              ],)
              
            ],
         ),
       ),
    );
  }
}