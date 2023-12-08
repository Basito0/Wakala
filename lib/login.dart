import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: TextFormField(
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 300),
                labelText: "usuario",
                hintText: "Ingresa tu correo"),
          ),
        ),
        Center(
          child: TextFormField(
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 300),
                labelText: "contraseña",
                hintText: "Ingresa tu contraseña"),
          ),
        ),
        FloatingActionButton.extended(
            onPressed: onPressed, label: Text("Ingresar"))
      ],
    ));
  }
}

onPressed() {
  return 1;
}
