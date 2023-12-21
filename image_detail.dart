import 'dart:io';
import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import "posts_screen.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: imagenWidget(fotoParaPost_Details!)
      )
    );
  }
}

Widget imagenWidget(Uint8List imageBytes) {
  if (imageBytes.isNotEmpty) {
    print(imageBytes);
    return Center(
      child:
        Image.memory(
          imageBytes,
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        )
      ); 
  } else {
    return Text('Error al cargar imagen');
  }
}