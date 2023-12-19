import "globales.dart";
import "funciones_api.dart";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewPostScreen extends StatelessWidget {

  XFile ? _pickedImage1;
  XFile ? _pickedImage2;

  NewPostScreen({super.key});
  Future _pickImageFromGalery() async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    return returnedImage;
  }

  TextEditingController sectorController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Avisar por nuevo Wakala'),
      ),
      body: Padding(
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
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _pickedImage1 = await _pickImageFromGalery();
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
                    if (_pickedImage1 != null)
                      Image.file(
                        File(_pickedImage1!.path),
                        height: 200, // Adjust the height as needed
                        width: 200,
                        fit: BoxFit.cover,
                     ),             
                    ElevatedButton(
                      onPressed: () async {
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
                Column(children: [
                    ElevatedButton(
                      onPressed: () async {
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
                    ElevatedButton(
                      onPressed: () async {
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
                ],)
              ],
             ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                 Map<String, dynamic> postData = {
                  "sector": sectorController.text,
                  "descripcion": descripcionController.text,
                  "username": usuarioActual
                  };
                  await addPost(postData);
                  Navigator.of(context).pop();
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
                 Navigator.of(context).pop();
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
      ),
    );
  }
}