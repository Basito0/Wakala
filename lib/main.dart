import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakala',
      home: PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Future<List<dynamic>> fetchPosts() async {
    try {
      var url = Uri.https("ada3-138-84-33-71.ngrok-free.app", "/posts");
      final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
      print(response.body);
      if (response.statusCode == 200) {
        
        return json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Wakalas"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Column(children: [ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(snapshot.data![index]['sector'] + "\n@" + snapshot.data![index]['username'])),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black),
                          )
                        ),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                   ),          
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)
                  ),
                );
              },
            ),
            // BOTON PARA CREAR POST NUEVO
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostScreen())); // Replace NewScreen() with the screen you want to navigate to);
              },
              style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(color: Colors.black),
              )
              ),
              child: Icon(Icons.add),
            ),
            ]);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching data"),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


class NewPostScreen extends StatelessWidget {
  // funcion para hacer posts. por ahora, todos los posts quedan con usuario @anonymous
  Future<String> addPost(Map<String, dynamic> postMap) async {
    try {
      var url = Uri.https("396b-138-84-33-71.ngrok-free.app", "/posts");
      
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postMap),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Wakala reportado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return "Post added successfully";
      } else {
        Fluttertoast.showToast(
          msg: "Error al postear. Status code: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
        return "Failed to add post: ${response.statusCode}";
      }
    } catch (e) {
        Fluttertoast.showToast(
          msg: "Error : $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
      return "Error adding post: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // si añadimos esa linea la flechita de arriba para volver atras de arriba desaparece
        // mientras no se añada el boton de "me arrepentí", no conviene
        //automaticallyImplyLeading: false,
        title: Text('Nuevo Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
  
            TextField(
              decoration: InputDecoration(
                labelText: 'Sector',
                border: OutlineInputBorder(),
              ),
              
              // Handle text changes or retrieve input value using onChanged or controller properties
            ),
            SizedBox(height: 20),
             TextField(
              decoration: InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder()
              ),
             ),
            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                 Map<String, dynamic> postData = {
                  "sector": "Some sector",
                  "descripcion": "Some description"
                  };
                  String result = await addPost(postData);
                // Handle button press logic here
              },
              style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 50), // Set the width and height of the button
              ),
            ),
              child: Text('DENUNCIAR WAKALA'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                 Navigator.of(context).pop();
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 50), // Set the width and height of the button
                ),
              ),
              child: Text('Me arrepentí'),
            ),
          ],
        ),
      ),
    );
  }
}
