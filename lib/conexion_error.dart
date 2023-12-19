import "preferencias.dart";
import 'package:flutter/material.dart';


class ConexionErrorScreen extends StatelessWidget {
  TextEditingController urlController= TextEditingController();

  ConexionErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solucionar problemas de conexión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
        const Text("Los problemas de conexión pueden deberse a que la URL que utiliza la API haya cambiado. Si es así, por favor enviar un correo a reiturra2021@udec.cl y responderé a la brevedad con la nueva URL.\n Una vez obtenida, copiar y pegar la nueva URL en el campo de abajo."),
        const SizedBox(height: 20),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Nueva URL',
                border: OutlineInputBorder()
              ),
             ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sharedPrefs.setLink(urlController.text);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50), 
                ),
              ),
              child: const Text('Guardar nueva URL'),
            ),
          ],
        )
      )
    );
  }
}