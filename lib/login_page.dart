import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import "posts_screen.dart";
import "create_account.dart";
import "conexion_error.dart";
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
    TextEditingController usernameController= TextEditingController();
    TextEditingController passwordController= TextEditingController();

  LoginPage({super.key});
 @override
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        automaticallyImplyLeading: false,

        title:  Center(child:
         Container(margin: const EdgeInsets.only(top: 30),
          child: const Text('Wakala 1.0', style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold)))
          ),
      ),
      body: FutureBuilder<List<dynamic>>(
      future: fetchUsers(sharedPrefs.getLink()),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
              
            ),
            
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              )
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                bool rightPassword = false;
                 if (snapshot.hasData) {
                  for(int i = 0; i < snapshot.data!.length; i++){
                    if(snapshot.data![i]['username'] == usernameController.text && snapshot.data![i]['password'] == passwordController.text){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PostsScreen()),
                      );
                      usuarioActual = usernameController.text;
                      rightPassword = true;
                      break;
                    }
                    }
                    if(!rightPassword){
                        Fluttertoast.showToast(
                          msg: "Nombre de usuario o contraseña incorrecta",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                    }
                  }
                 },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50), 
                ),
              ),
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 40),
            const Text("¿No tienes una cuenta?"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                );
                //Navigator.pop(context);           
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50), 
                ),
              ),
              child: const Text('Crear cuenta Wakala'),
            ),
            const SizedBox(height: 10),
            const Text("¿Problemas de conexión? ¿Mensajes de error?"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConexionErrorScreen()),
                );         
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50), 
                ),
              ),
              child: const Text('Solucionar problemas de conexión'),
            ),
            const SizedBox(height: 60),
            const Center(child: Text("Desarrollado por:\nBastián Alexander Becerra Parada\nRenate Antonia Iturra López")),

                
          ]
        )
      );})
    );
  }

}