import 'package:contratistas/page/page.dart';
import 'package:contratistas/providers/qrprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'response/response.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contratistas',
      initialRoute: 'login',
      routes: {
        'login':(_)=> Login(),
      },
      theme: ThemeData(
        primaryColor: Colors.green[900]
      ),

    );
  }
}

