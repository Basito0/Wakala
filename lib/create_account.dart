import "preferencias.dart";
import "funciones_api.dart";
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccountScreen extends StatelessWidget {

  TextEditingController usernameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController emailController= TextEditingController();

  CreateAccountScreen({super.key});

  bool esCorreo(String correo){
    var correoRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return correoRegex.hasMatch(correo);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all( 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              TextField(
                controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
             ),
             const SizedBox(height: 20.0),
              TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText:  'Nombre de Usuario',
                border: OutlineInputBorder(),
              ),
             ),
             const SizedBox(height: 20.0),
             TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
             ),
             const SizedBox(height: 20.0),
              ElevatedButton(
              
              onPressed: () {

                if(!esCorreo(emailController.text)){
                  Fluttertoast.showToast(
                  msg: "Dirección de correo inválida",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                }else if(passwordController.text.isEmpty){
                  Fluttertoast.showToast(
                  msg: "Debes ingresar una contraseña",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  );
                }else if(usernameController.text.isEmpty){
                  Fluttertoast.showToast(
                  msg: "Debes ingresar un nombre de usuario",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  );     
                }else{
                  bool usernameEnUso = false;
                  for(int i = 0; i < userList!.length; i++){
                    if((userList![i]['username'] == usernameController.text)){
                      print(userList![i]['username']);
                      Fluttertoast.showToast(
                        msg: "Ese nombre de usuario ya está en uso. Prueba uno distinto",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      usernameEnUso = true;
                      break;
                    }
                  }
                  if(usernameEnUso == false){
                    Map<String, dynamic> userData = {
                      "username": usernameController.text,
                      "email": emailController.text,
                      "password": passwordController.text
                    };
                    addUser(sharedPrefs.getLink(), userData);
                      Fluttertoast.showToast(
                        msg: "Tu cuenta fue creada exitosamente!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );

                  }             
                }
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50), 
                ),
              ),
              child: const Text('Registrarse'),
            ), 
          ]
        )
      )
    );
  }
}