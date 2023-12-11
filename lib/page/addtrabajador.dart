import 'dart:ffi';

import 'package:contratistas/page/page.dart';
import 'package:contratistas/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../response/response.dart';



class AddTrabajador extends StatelessWidget {
 /*  final qr;  
  final idcartilla;
  final swtipoescan;
  const AddTrabajador({super.key,required this.qr,required this.idcartilla,required this.swtipoescan});
  */ 
  const AddTrabajador({super.key});
  @override
  Widget build(BuildContext context) {
      
       return Scaffold(
        appBar: AppBar(title: Text('Agregar Trabajador')),
       
         body: MultiProvider(
          providers: [
             ChangeNotifierProvider(create: (context)=> TrabajadorxContratistaProvider()),
              ChangeNotifierProvider(create: (context)=> Connectivity_provider())
          ],
          child: _addTrabajador(qr: '71462409',idcartilla:'5',swtipoescan:'1'),
        ), 
      ); 

 
  }
}

// ignore: camel_case_types
class _addTrabajador extends StatelessWidget {
  final qr;
  final idcartilla;
  final swtipoescan;
  
const _addTrabajador({required this.qr,required this.idcartilla,required this.swtipoescan});

  @override
  Widget build(BuildContext context) {
    TextEditingController controlladorqr= TextEditingController(text: qr);
    TextEditingController controlladorrut=TextEditingController();
    TextEditingController controlladornombre=TextEditingController();
    TextEditingController controlladorcantidad=TextEditingController(text:"1");
    
    
    final _textname=GlobalKey<FormFieldState>();
    
    
    final trabajadorcontratista=Provider.of<TrabajadorxContratistaProvider>(context);
      bool _validarut(String? rut) {
       if (rut == null) return false;
        final regExp = RegExp(
          r'(^(\d{1,2}(?:[\.]?\d{3}){2}-[\dkK])$)'
        );
        return regExp.hasMatch(rut);
    } 
 
 
    
    return Container(
      
      child: 
       Form(
        key: trabajadorcontratista.formkey,
        
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
        children: [

        
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: TextFormField(    
              controller: controlladorqr,                enabled: false,
              onChanged: ((value) => trabajadorcontratista.Qr),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                labelText: 'Qr Trabajador',
                prefix: Icon(Icons.assignment_ind_outlined)              
              ),
            ),
          ),
          
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child:
              TextFormField(
                  autocorrect: false,           
                  onChanged: (value)=>{ 
                    trabajadorcontratista.Rut=value               
                  },
            
                  validator: (value){
                    return trabajadorcontratista.validarut 
                          ? (value==null || value.isEmpty ) ? 'Debe ingresar un rut' : _validarut(value) ? null :'Debe ingresar un rut valido'
                          :null;
                  }, 
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    labelText: 'Rut Trabajador',
                    prefix:const Icon(Icons.add_card)                
                  ),
              ),
           ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: TextFormField(      
              autocorrect: false,              
               onChanged: (value) =>{trabajadorcontratista.Nombre=value}, 
               validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Debe ingresar un nombre valido'
                    : null;
              },               
               decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                labelText: 'Nombre Trabajador',
                prefix: Icon(Icons.person)
                
              ), 
            ),
          ),
           
            
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            child: swtipoescan=="0" ? TextFormField(
              maxLines: 1,
              controller: controlladorcantidad,
              keyboardType: TextInputType.number,              
              onChanged: (value)=>{
                trabajadorcontratista.cantidad=int.parse(value),             
              },
        
               validator: (value) {
                return (value == null || value.isEmpty  )
                    ? 'Debe ingresar una cantidad valido'
                    : null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                labelText: 'Ingrese cantidad de entregas',
                prefix:const Icon(Icons.add_card)
                
              ),
            )
            :Container()
          
          ),  
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: SwitchListTile(
              title:const Text('Valida Rut Chile'),
              value: trabajadorcontratista.validarut,
              onChanged: (bool value)=>{
                    trabajadorcontratista.validarut=value
              } ,
            ),
          ),
        
         
           Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: 56,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.red,
        
              color: Colors.blue,
              child: Text('Agregar Trabajador',style: TextStyle(color: Colors.white),),
                onPressed:trabajadorcontratista.isLoading ? null :()async{
                  FocusScope.of(context).unfocus(); 
                  if(!trabajadorcontratista.isValidateForm())return;
                  trabajadorcontratista.Qr=controlladorqr.value.text;
                    
                  
                  Trabajador trabajador=Trabajador(
                    qr: trabajadorcontratista.Qr, 
                    nombre: trabajadorcontratista.Nombre,
                    rut: trabajadorcontratista.Rut,
                    
                   ); 
                  int insert=await trabajadorcontratista.insertnewtrabajadorcontratista(trabajador);
                  
                  if(insert>0){
                    
                    final today=DateTime.now();
                    final date=DateFormat('dd/MM/yyyy').format(today);
                    EntregaResponse entrega=EntregaResponse(
                      idcartilla: this.idcartilla,
                      qr: this.qr, 
                      cantidad: trabajadorcontratista.Swunoauno==1 ? 1 : trabajadorcontratista.cantidad, 
                      fecha: date, 
                      swsincronizado: '0');
                    int inserto=await trabajadorcontratista.insertentry(entrega) ;
                    List<QrCartillaResponse> lista=await trabajadorcontratista.getcartillasdisponibles(); 
                      Future.microtask(() => {
                        Navigator.pushReplacement(context, PageRouteBuilder(
                          pageBuilder: ( _, __ , ___ ) => MainDashboard(lista: lista,),
                          transitionDuration:const Duration( seconds: 3)
                          )
                        )
        
                      });
        
                  }           
                },
                
                ),
            ), 
            
             
          
        ]
        )
      )
      
    );
  }
}