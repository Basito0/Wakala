import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import "posts_screen.dart";
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostDetails extends StatelessWidget {
  PostDetails({super.key});
  TextEditingController commentController= TextEditingController();
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
  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                      snapshot.data!["sector"],
                      style: const TextStyle(color: Colors.green, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    snapshot.data!["descripcion"],
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Añadir comentario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if(commentController.text.isNotEmpty){
                          Map<String, dynamic> commentData = {
                            "username": usuarioActual,
                            "comentario": commentController.text
                          };
                          await addCommentToPost(sharedPrefs.getLink(), snapshot.data!['id'], commentData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostDetails()),
                          );
                        }else{
                          Fluttertoast.showToast(
                            msg: "No se puede enviar un comentario vacío",
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
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                        child: const Icon(Icons.send),
                      ),
                    ),
                    ]),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> contadores = {"sigue_ahi": 1, "ya_no_esta": 0, "username": usuarioActual};
                            editarContadores(sharedPrefs.getLink(), snapshot.data!['id'], contadores);          
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostDetails()),
                          );            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color.fromARGB(255, 104, 56, 125),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            child: Text("Sigue ahí (${snapshot.data!["sige_ahi_count"]})")
                          )
                        ),
                        GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> contadores = {"sigue_ahi": 0, "ya_no_esta": 1, "username": usuarioActual};
                            editarContadores(sharedPrefs.getLink(), snapshot.data!['id'], contadores);         
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostDetails()),
                          );    
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color.fromARGB(255, 104, 56, 125),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            child: Text("Sigue ahí (${snapshot.data!["ya_no_esta_count"]})")
                          )
                        ),
                      ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!['comentarios'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                    snapshot.data!['comentarios'][index]['comentario'] +
                                        "\n@" +
                                        snapshot.data!['comentarios'][index]['username'],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]
                  ),
                ),

              ],
            );
          }
          else{
            return const Text("error");
          }
        }
      ),
    );
    
  }

}