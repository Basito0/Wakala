import "globales.dart";
import "preferencias.dart";
import "funciones_api.dart";
import "login_page.dart";
import "post_details.dart";
import "new_post.dart";
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    fetchPosts(sharedPrefs.getLink()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Wakalas"),
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(sharedPrefs.getLink()),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          
          if (snapshot.hasData) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
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
                                    snapshot.data![index]['sector'] +
                                        "\n@" +
                                        snapshot.data![index]['username'],
                                  ),
                                ),
                                
                                ElevatedButton(
                                  onPressed: () {
                                    current_post_id = index;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => PostDetails()),
                                  );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 70)
                    ],
                  ),
                ),
                    
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      sectorTempText="";
                      descripcionTempText="";
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (context) => NewPostScreen()),

                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
                Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(bottom: 16, left: 16),
                child: ElevatedButton(
                  onPressed: () async{
                    await fetchPosts(sharedPrefs.getLink());
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: const BorderSide(color: Color.fromARGB(255, 71, 69, 69)),
                    ),
                  ),
                  child: const Icon(Icons.refresh),
                ),
              ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error al cargar"),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}