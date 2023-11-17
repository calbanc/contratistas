import 'package:contratistas/response/qrcartilla_response.dart';
import 'package:flutter/material.dart';
import 'package:contratistas/providers/db_provider.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});




  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:Text('VERFTASK'),
        centerTitle: true,
        backgroundColor: Colors.green[600],
      ),
      body: Column(


        children: [
          Row(
            children: [
               Padding(
                 padding: EdgeInsets.all(4),
                 child: Container(
                   width: size.width*0.91,
                   height: size.height*0.1,
                   color: Colors.green,

                 ),)
            ],
          )
        ],
      ),
    );

  }
}


