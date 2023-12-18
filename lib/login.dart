import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
            onPressed: onPressed, label: Text("Ingresar")),
        Text("Desarrolladores:"),
        Text("Desarollador 1"),
        Text("Desarrollador 2")
      ],
    ));
  }
}

onPressed() {
  return 1;
}
