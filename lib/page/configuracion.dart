import 'package:contratistas/page/page.dart';
import 'package:contratistas/providers/provider.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../response/response.dart';


class Configuracion extends StatelessWidget {
  const Configuracion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
        centerTitle: true,
        ),
      body: _ListOptions(),


    );
  }
}


class _ListOptions extends StatelessWidget {
  const _ListOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: EdgeInsets.all(32),
           scrollDirection: Axis.vertical,
           children: [
              ListTile(
                title: Text('Cartillas',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                    ),),
                subtitle: Text('Ver todas las cartillas ingresadas',style: TextStyle(fontStyle: FontStyle.italic),),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                   Navigator.push(context,  MaterialPageRoute(
                  builder: ((context) =>  _ListCartillas())));
                },
                
              ),
         /*     ListTile(
                title: Text('Tiempo de Capturas',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                    ),),
                subtitle: Text('Configura el tiempo entre scan y scan',style: TextStyle(fontStyle: FontStyle.italic),),
                trailing: Icon(Icons.arrow_forward_ios),
              )*/


           ],
         
      
    );
  }
}

class _ListCartillas extends StatelessWidget {
  const _ListCartillas({super.key});


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context)=>new CartillasProvider(),
      child: ListCartilla()
      );
    /*  */
  }
} 

