import 'dart:io';
import 'package:wakala/escribir_comentario.dart';

import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import "posts_screen.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostDetails extends StatelessWidget {
  PostDetails({super.key});
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Wakalas"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostsScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: fetchPost(sharedPrefs.getLink(), current_post_id),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              Uint8List foto1decoded = base64.decode(snapshot.data!["images"]
                      ["base64image1"]
                  .replaceAll(RegExp(r'\s+'), ''));
              Uint8List foto2decoded = base64.decode(snapshot.data!["images"]
                      ["base64image2"]
                  .replaceAll(RegExp(r'\s+'), ''));
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Text(
                                snapshot.data!["post"]["sector"],
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              snapshot.data!["post"]["descripcion"],
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Center(
                              child: Text(
                                  "Subido por @${snapshot.data!["post"]['username']} el ${snapshot.data!["post"]['fecha']}")),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                imagenWidget(foto1decoded),
                                imagenWidget(foto2decoded)
                              ]),
                          Row(children: [
                            FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EscribirComentario()),
                                );
                              },
                              label: Text("Comentar"),
                            )
                          ]),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> contadores = {
                                      "sigue_ahi": 1,
                                      "ya_no_esta": 0,
                                      "username": usuarioActual
                                    };
                                    editarContadores(
                                        snapshot.data!["post"]['id'],
                                        contadores);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostDetails()),
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: const Color.fromARGB(
                                            255, 104, 56, 125),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 30.0),
                                      child: Text(
                                          "Sigue ahí (${snapshot.data!["post"]["sigue_ahi_count"]})"))),
                              GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> contadores = {
                                      "sigue_ahi": 0,
                                      "ya_no_esta": 1,
                                      "username": usuarioActual
                                    };
                                    editarContadores(
                                        snapshot.data!["post"]['id'],
                                        contadores);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostDetails()),
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: const Color.fromARGB(
                                            255, 104, 56, 125),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 30.0),
                                      child: Text(
                                          "Ya no está (${snapshot.data!["post"]["ya_no_esta_count"]})"))),
                            ],
                          ),
                          // comentarios
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                snapshot.data!["post"]['comentarios'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.data!["post"]['comentarios']
                                                [index]['comentario'] +
                                            "\n@" +
                                            snapshot.data!["post"]
                                                    ['comentarios'][index]
                                                ['username'],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ]),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text("Error al cargar post: " + snapshot.error.toString()),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

Widget cuadroGrisFoto(double largo) {
  return Container(
    width: largo,
    height: largo,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
    ),
    child: Icon(Icons.photo),
  );
}

Widget imagenWidget(Uint8List imageBytes) {
  if (imageBytes.isNotEmpty) {
    print(imageBytes);
    return Image.memory(
      imageBytes,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    );
  } else {
    return Text('Error al cargar imagen');
  }
}
