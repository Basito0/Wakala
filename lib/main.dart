import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

String link = "d41d-2800-150-109-da7-f86c-4db-97e1-ff92.ngrok-free.app";
String sector = "";
String descripcion = "";
String usuarioActual = "annonymous";
int current_post_id = 0;
List<dynamic>? userList;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakala',
      home: LoginPage(),
    );
  }
}


class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}



class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    fetchPosts(); 
  }

  Future<List<dynamic>> fetchPosts() async {
    try {
      var url = Uri.https(link, "/posts");
      final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
      print(response.body);
      if (response.statusCode == 200) {
          print('Conectado con éxito');
          Fluttertoast.showToast(
            msg: 'Posts cargados exitosamente',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
        );
        return json.decode(response.body);
      } else {

        print('Error al cargar los posts. Status Code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Error al cargar los posts. Status Code: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 162, 28, 28),
          textColor: Colors.white,
        );
        return [];
      }
    } catch (e) {
      
      print('Error al cargar los posts: $e');
      return [];
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Listado de Wakalas"),
      leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
    ),
    body: FutureBuilder<List<dynamic>>(
      future: fetchPosts(),
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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          padding: EdgeInsets.all(16),
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
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 70)
                  ],
                ),
              ),
                   
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(bottom: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPostScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Icon(Icons.add),
                ),
              ),
              Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 16, left: 16),
              child: ElevatedButton(
                onPressed: () async{
                  await fetchPosts();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: const Color.fromARGB(255, 71, 69, 69)),
                  ),
                ),
                child: Icon(Icons.refresh),
              ),
            ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error al cargar"),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ),
  );
}
}

class PostDetails extends StatelessWidget {

  Future<void> addCommentToPost(int postId, Map<String, dynamic> commentData) async {
  var url = Uri.https(link, "/posts/" + current_post_id.toString());
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(commentData),
  );
  if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Comentario añadido exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    print('Comentario añadido exitosamente');
  } else {
      Fluttertoast.showToast(
        msg: "Error añadiendo comentario. status code: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    print('Error añadiendo comentario: ${response.body}');
    throw Exception('Error añadiendo comentario ${response.body}');
  }
}

  Future<Map<String, dynamic>> fetchPost() async {
    try {
      var url = Uri.https(link, "/posts/" + current_post_id.toString());
      final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error al cargar los posts. Status Code: ${response.statusCode}');

        return {}; 
      }
    } catch (e) {
      print('Error al cargar post: $e');

      return {}; 
    }
  }

  TextEditingController commentController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Wakalas"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsScreen()),
            );
          },
        ),
      ),
body: FutureBuilder<Map<String, dynamic>>(
  future: fetchPost(),
  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      snapshot.data!["sector"],
                      style: TextStyle(color: Colors.green, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    snapshot.data!["descripcion"],
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Añadir comentario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if(!commentController.text.isEmpty){
                          Map<String, dynamic> commentData = {
                            "username": usuarioActual,
                            "comentario": commentController.text
                          };
                          await addCommentToPost(snapshot.data!['id'], commentData);
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
                          color: Color.fromARGB(255, 104, 56, 125),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!['comentarios'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(16),
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
              ],
            ),
          ),
        ],
      );
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    } else {
      return Text("No data");
    }
  },
  ),
  );
  }
}

      


class LoginPage extends StatelessWidget {
    TextEditingController usernameController= TextEditingController();
    TextEditingController passwordController= TextEditingController();

    Future<List<dynamic>> fetchUsers() async {
    try {
      var url = Uri.https(link, "/userlist");
      final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
      if (response.statusCode == 200) {
          print('Userlist cargada');
          userList = json.decode(response.body);
        return json.decode(response.body);
      } else {
      Fluttertoast.showToast(
        msg: "Error al cargar userlist. status code: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
        print('Error al cargar userlist: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "'Error al cargar userlist: $e'",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('Error al cargar userlist: $e');
      return [];
    }
  }

 @override
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        automaticallyImplyLeading: false,

        title:  Center(child:
         Container(margin: EdgeInsets.only(top: 30),
          child: Text('Wakala 1.0', style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold)))
          ),
      ),
      body: FutureBuilder<List<dynamic>>(
      future: fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
              
            ),
            
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              )
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                bool right_password = false;
                 if (snapshot.hasData) {
                  for(int i = 0; i < snapshot.data!.length; i++){
                    if(snapshot.data![i]['username'] == usernameController.text && snapshot.data![i]['password'] == passwordController.text){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostsScreen()),
                      );
                      usuarioActual = usernameController.text;
                      right_password = true;
                      break;
                    }
                    }
                    if(!right_password){
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
                  Size(double.infinity, 50), 
                ),
              ),
              child: Text('Ingresar'),
            ),
            SizedBox(height: 40),
            Text("¿No tienes una cuenta?"),
            SizedBox(height: 10),
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
                  Size(double.infinity, 50), 
                ),
              ),
              child: Text('Crear cuenta Wakala'),
            ),
            SizedBox(height: 60),
            Center(child: Text("Desarrollado por:\nBastián Alexander Becerra Parada\nRenate Antonia Iturra López")),
                
          ]
        )
      );})
    );
  }
}

class CreateAccountScreen extends StatelessWidget {

  TextEditingController usernameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController emailController= TextEditingController();

  bool esCorreo(String correo){
    var correoRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return correoRegex.hasMatch(correo);
  }

    Future<String> addUser(Map<String, dynamic> userMap) async {
    try {
      var url = Uri.https(link, "/userlist");  
      var response = await http.post(url, headers: {'ngrok-skip-browser-warning': 'true', 'Content-Type': 'application/json'}, body: jsonEncode(userMap));
      if (response.statusCode == 200) {
        return "Usuario añadido";
      } else {
        Fluttertoast.showToast(
          msg: "Error al añadir usuario. Status code: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
        return "Error al añadir usuario: ${response.statusCode}";
      }
    } catch (e) {
        Fluttertoast.showToast(
          msg: "Error : $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
      return "Error añadiendo usuario: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear cuenta'),
      ),
      body: Padding(
        padding: EdgeInsets.all( 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              TextField(
                controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
             ),
             SizedBox(height: 20.0),
              TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText:  'Nombre de Usuario',
                border: OutlineInputBorder(),
              ),
             ),
             SizedBox(height: 20.0),
             TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
             ),
             SizedBox(height: 20.0),
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
                  bool username_en_uso = false;
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
                      username_en_uso = true;
                      break;
                    }
                  }
                  if(username_en_uso == false){
                    Map<String, dynamic> userData = {
                      "username": usernameController.text,
                      "email": emailController.text,
                      "password": passwordController.text
                    };
                    addUser(userData);
                      Fluttertoast.showToast(
                        msg: "Tu cuenta fue creada exitosamente!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
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
                  Size(double.infinity, 50), 
                ),
              ),
              child: Text('Registrarse'),
            ), 
          ]
        )
      )
    );
  }
}


class NewPostScreen extends StatelessWidget {

  // funcion para hacer posts
  Future<String> addPost(Map<String, dynamic> postMap) async {
    try {
      var url = Uri.https(link, "/posts");  
      var response = await http.post(url, headers: {'ngrok-skip-browser-warning': 'true', 'Content-Type': 'application/json'}, body: jsonEncode(postMap));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Wakala reportado con éxito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        
        return "Wakala reportado con éxito";
      } else {
        Fluttertoast.showToast(
          msg: "Error al denunciar. Status code: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
        return "Error al denunciar Wakala: ${response.statusCode}";
      }
    } catch (e) {
        Fluttertoast.showToast(
          msg: "Error : $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
       );
      return "Error: $e";
    }
  }

  TextEditingController sectorController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Avisar por nuevo Wakala'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
  
            TextField(
              controller: sectorController,
              decoration: InputDecoration(
                labelText: 'Sector',
                border: OutlineInputBorder(),
              ),
              
            ),
            SizedBox(height: 20),
             TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder()
              ),
             ),
            SizedBox(height: 40),

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
                Size(double.infinity, 50), 
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
                  Size(double.infinity, 50), 
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


class ConexionErrorScreen extends StatelessWidget {
  TextEditingController urlController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solucionar problemas de conexión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Los problemas de conexión pueden deberse a que la URL que utiliza la API haya cambiado. Si es así, por favor enviar un correo a reiturra2021@udec.cl y responderé a la brevedad con la nueva URL. Una vez obtenida, copiar y pegar la nueva URL en el campo de abajo."),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Nueva URL',
                border: OutlineInputBorder()
              ),
             ),
            ElevatedButton(
              onPressed: () {
                link = urlController.text;
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 50), 
                ),
              ),
              child: Text('Guardar nueva URL'),
            ),
          ],
        )
      )
    );
  }
}
