
import 'package:contratistas/providers/provider.dart';
import 'package:contratistas/response/qrcartilla_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page.dart';


class MainDashboard extends StatelessWidget {
  
  MainDashboard({super.key,required this.lista});
  List<QrCartillaResponse> lista;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> new TrabajadorxContratistaProvider()),
        ChangeNotifierProvider(create: (context)=> new Connectivity_provider())
      ],

      child: Dashboard(lista: lista)
    );



  }
}