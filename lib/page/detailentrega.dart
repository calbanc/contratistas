import 'package:contratistas/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../response/response.dart';


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
     final trabajadorcontratisprovider=Provider.of<TrabajadorxContratistaProvider>(context);

    return Scaffold(
       appBar: AppBar(title: Text('Detalle Entrega')),
       body: Column(
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
                  enabled: false,
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
                  enabled: false,
                  decoration:const InputDecoration(filled: true,
                      fillColor: Color.fromARGB(255, 239, 239, 240),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.white24)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                      labelText: "Entregas",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 16, 84, 163),fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                  ),

                ),
              
            ),
            SizedBox(width: 20,height: 20,),
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
                    print(listado.cantidad);
                    int cantidad=listado.cantidad;
                    if(cantidad==1){
                      //Seteamos a 0
                      print('asdasd');
                    }else{
                      cantidad=cantidad-1;
                      final date=DateFormat('dd/MM/yyyy').format(DateTime.now());
                      EntregaResponse nuevaentrega=EntregaResponse(identrega: listado.identrega,idcartilla: listado.idcartilla,
                      qr: listado.qr,cantidad: cantidad,fecha: date,swsincronizado: '0');
                      final update=await trabajadorcontratisprovider.updateentry(nuevaentrega);
                      print('actualizado $update');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.exposure_minus_1_outlined),
                    SizedBox(width: 8,height: 8,),
                    Text('Entrega')
                  ],)
                  
                ),
              ),
              SizedBox(height: 8,width: 8,),
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                height: 60,
                
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900]
                ),

                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_delete),
                      SizedBox(width: 8,height: 8,),
                      Text('Entregas')
                    ],
                  )
                  
                ),
              ),
            ],)
            
          ],
       ),
    );
  }
}