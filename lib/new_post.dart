import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';

class NewPostScreen extends StatelessWidget {
  TextEditingController sectorController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  NewPostScreen({super.key});

  Future _pickImageFromGalery() async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    return returnedImage;
  }
  

  Image imagenFromBase64(String s) {
    return Image.memory(base64Decode(s));
  }


  String imageToBase64(Uint8List data) {
    return base64Encode(data);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Avisar por nuevo Wakala'),
      ),   
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPost(sharedPrefs.getLink(), current_post_id),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasData && snapshot.data!.isNotEmpty) {   
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                TextField(
                  controller: sectorController,
                  decoration: const InputDecoration(
                    labelText: 'Sector',
                    border: OutlineInputBorder(),
                  ),
                  
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            foto1 = await _pickImageFromGalery();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewPostScreen()),
                            );

                          },                      
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50), 
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), 
                            ),                
                          )                          
                        ),
                          child: const Text('Foto 1'),
                        ),
                        const SizedBox(
                          height: 20
                        ),
                        foto1 == null ? cuadroGrisFoto(150):                     
                          Image.file(
                              File(foto1!.path), 
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                        const SizedBox(
                          height: 20
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            foto1 = null;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewPostScreen()),
                            );
                          },
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50), 
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), 
                            ),                
                          )                          
                        ),
                          child: const Text('Borrar'),
                          
                        ),
                          ]
                        ),             
                      Column(children: [
                        ElevatedButton(
                          onPressed: () async {
                            foto2 = await _pickImageFromGalery();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewPostScreen()),
                            );
                          },
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50), 
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), 
                                ),                
                          )   
                        ),
                          child: const Text('Foto 2'),
                        ),
                        const SizedBox(height: 20),
                        foto2 == null ? cuadroGrisFoto(150):                     
                          Image.file(
                              File(foto2!.path), 
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                        const SizedBox(
                          height: 20
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            foto2 = null;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewPostScreen()),
                            );
                          },
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50), 
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), 
                            ),                
                          )                      
                        ),
                          child: const Text('Borrar'),
                        ),
                      ],
                    ),
                  ],               
                ),      
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if(sectorController.text!="" && descripcionController.text!="" && foto1!=null && foto2!=null){
                      Map<String, dynamic> postData = {
                        "sector": sectorController.text,
                        "descripcion": descripcionController.text,
                        "username": usuarioActual
                      };
                      await addPost(postData);
                      Navigator.of(context).pop();
                    }else{
                      Fluttertoast.showToast(
                        msg: "Debes completar todos los campos",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }

                  },
                  style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 50), 
                  ),       
                ),
                  child: const Text('DENUNCIAR WAKALA'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if(foto1 != null && foto2 != null){
                      Navigator.of(context).pop();
                    }else{
                    Fluttertoast.showToast(
                      msg: 'Debes elegir 2 imagenes relacionadas a tu post.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    }
                    
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50), 
                    ),
                  ),
                  child: const Text('Me arrepentí'),
                ),   
                  ],
                ),
          );
        }
        else if (snapshot.hasError){
            return  Center(
              child: Text("Error al cargar pantalla new_post: " + snapshot.error.toString()),
            );
          }
        return const Center(child: CircularProgressIndicator());
        }
      )  
    );
  }
}


Widget cuadroGrisFoto(double largo) {
  return Container(
    width: largo,
    height: largo,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey, // Border color
        width: 1, // Border width
      ),
    ),
    child: Icon(Icons.photo),
  );
}
