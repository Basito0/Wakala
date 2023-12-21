import "preferencias.dart";
import "funciones_api.dart";
import 'package:flutter/material.dart';
import "package:wakala/post_details.dart";
import 'package:fluttertoast/fluttertoast.dart';
import "globales.dart";

class EscribirComentario extends StatelessWidget {
  EscribirComentario({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    return Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchPost(sharedPrefs.getLink(), current_post_id),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                            Row(children: [
                              Expanded(
                                child: TextField(
                                  maxLines: null,
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Añadir comentario',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (commentController.text.isNotEmpty) {
                                    Map<String, dynamic> commentData = {
                                      "username": usuarioActual,
                                      "comentario": commentController.text
                                    };
                                    await addCommentToPost(
                                        sharedPrefs.getLink(),
                                        snapshot.data!["post"]['id'],
                                        commentData);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostDetails()),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg:
                                          "No se puede enviar un comentario vacío",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.orange,
                                      textColor: Colors.white,
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 30.0),
                                  child: const Icon(Icons.send),
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostDetails()),
                                    );
                                  },
                                  label: Text("Me arrepentí"),
                                )
                              ],
                            )
                          ]),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Error al cargar post: " + snapshot.error.toString()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
