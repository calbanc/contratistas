import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../response/response.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ListCartilla extends StatelessWidget {
  const ListCartilla({super.key});

  @override
  Widget build(BuildContext context) {
    final cartillaprovider=Provider.of<CartillasProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cartillas Registradas'),centerTitle: true,),
      body: Container(
        child: Column(children: [
            EasyDateTimeLine(          
              initialDate: DateTime.now(),
              locale: "es_Es",
              onDateChange: ((selectedDate) {
                cartillaprovider.setfechainicio=selectedDate.toString();
              }),
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                selectedDateFormat: SelectedDateFormat.fullDateDMY,

              ),
              ),
              Container(
                height: 210,
                child: Padding(
                  padding:const EdgeInsets.all(8),
                  child: FutureBuilder(
                    future:cartillaprovider.getcartillasbydate(cartillaprovider.fechainicio),
                    builder:(context,AsyncSnapshot<List<QrCartillaResponse>> snapshot){
                      if(!snapshot.hasData||snapshot.data==null){
                        return Container();
                      }else{  
                        List<QrCartillaResponse> listado= snapshot.data!;                                              
                        return _Card(lista: listado,cartillaprovider:cartillaprovider);
                      }
                    }
                  ),
                ),
              )
        ]),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<QrCartillaResponse>lista;
  final CartillasProvider cartillaprovider;
  const _Card({required this.lista,required this.cartillaprovider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: ((context,index){
        String idcartilla=lista[index].idcartilla;
        String cuartel=lista[index].cuartel;
        String fechainicio=DateFormat('dd/MM/yyyy').format(DateTime.parse(lista[index].fechainicio));

        String fechatermino=lista[index].fechatermino;
        DateTime? horainicio=DateTime.parse(lista[index].horainicio!);
        String? horatermino=lista[index].horatermino;
        horainicio==null ? cartillaprovider.ctrlhorainicio.text='' : cartillaprovider.ctrlhorainicio.text=DateFormat('HH:mm').format(horainicio);
        horatermino==null?cartillaprovider.ctrlhoratermino.text='': cartillaprovider.ctrlhoratermino.text=DateFormat('HH:mm').format(DateTime.parse(lista[index].horatermino!)) ;

        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(8),right: Radius.circular(8))),
          color: Colors.amber[100],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40,),
                  const Text('Id Cartilla:',style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 8,),
                  Text(idcartilla),
                  const SizedBox(width: 8,),
                  const Text('Cuartel',style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 8,),
                  Text(cuartel)
              ],),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Fecha: '),
                  Text(fechainicio.toString()),
              ],),
              SizedBox(height: 10,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 8,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: TextFormField(
                        controller: cartillaprovider.ctrlhorainicio,
                        onTap: ()async{
                           TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context, //context of current state
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if(pickedTime!=null){
                          String formattedTime = '${pickedTime?.hour.toString().padLeft(2, '0')}:${pickedTime?.minute.toString().padLeft(2, '0')}';
                          cartillaprovider.ctrlhorainicio.text=formattedTime;


                        }else{
                          cartillaprovider.ctrlhorainicio.text='';
                        }
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                        labelText: 'Hora Inicio',
                        prefix:const Icon(Icons.add_card)
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: TextFormField(
                        readOnly: true,
                        controller: cartillaprovider.ctrlhoratermino,
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context, //context of current state
                          builder: (context, child) {
                             return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if(pickedTime!=null){

                          String formattedTime = '${pickedTime?.hour.toString().padLeft(2, '0')}:${pickedTime?.minute.toString().padLeft(2, '0')}';
                          cartillaprovider.ctrlhoratermino.text=formattedTime;


                        }else{
                          cartillaprovider.ctrlhoratermino.text='';
                        }
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                        labelText: 'Hora Termino',
                        prefix:const Icon(Icons.add_card)
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                ],

              ),
              Container(
                width: MediaQuery.of(context).size.width*0.8,

                child:ElevatedButton(          
                onPressed: ()async{
                  if(cartillaprovider.ctrlhorainicio.text==''){
                    Fluttertoast.showToast(
                        msg: "Debe seleccionar una hora de inicio",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[300],
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  }else{

                    TimeOfDay _startTime = TimeOfDay(hour:int.parse(cartillaprovider.ctrlhorainicio.text.split(":")[0]),minute: int.parse(cartillaprovider.ctrlhorainicio.text.split(":")[1]));
                    DateTime horaini=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_startTime.hour,_startTime.minute);

                    if(cartillaprovider.ctrlhoratermino.text==''){
                      cartillaprovider.abrircartilla(idcartilla);
                    }else{
                      TimeOfDay _endTime = TimeOfDay(hour:int.parse(cartillaprovider.ctrlhoratermino.text.split(":")[0]),minute: int.parse(cartillaprovider.ctrlhoratermino.text.split(":")[1]));
                      DateTime horatermino=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_endTime.hour,_endTime.minute);
                      cartillaprovider.updatehoratermino(idcartilla, horatermino);
                    }
                    cartillaprovider.updatehorainicio(idcartilla,horaini);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text("Cartilla Actualizada"),
                          content: new Text("Estimado usuario cartilla actualizada correctamente"),

                        )
                    );

                  }


                },
                child:const Text('Actualizar')
              ), 
              ),
              
              
            ]
          ),
        );

      })
    );
  }
}