
import 'package:flutter/material.dart';
import "preferencias.dart";
import "login_page.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Wakala',
      home: LoginPage(),
    );
  }

}





  










