import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'preferencias.dart';
List<dynamic>? userList;

Future<void> editarContadores(int postId, Map<String, dynamic> contador) async {
  Uri url = sharedPrefs.getUrl("/posts/$postId");
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(contador),
  );
  if (response.statusCode == 200) {
    print('Contador incrementado en un post');
  } else {

    print('Error incrementando contador: ${response.body}');
    throw Exception('incrementando contador ${response.body}');
  }
}


Future<int> numOfPosts() async {
    Uri url = sharedPrefs.getUrl("/posts");
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    final List<dynamic> posts = json.decode(response.body);
    return posts.length;
  } else {
    throw Exception('Error cargando posts en funcion numOfPosts');
  }
}



Future<void> addImagesToPost(int postId, Map<String, dynamic> images) async {
  Uri url = sharedPrefs.getUrl("/posts/$postId/images");
  images["post_id"] = postId;
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(images),
  );
  if (response.statusCode == 200) {
    print('Se añadieron imagenes a post $postId');
  } else {
    throw Exception('Error añadiendo imagenes a post $postId ${response.body}');
  }
}


Future<List<dynamic>> fetchImage(int postId) async{
    try {
    Uri url = sharedPrefs.getUrl("/post/$postId/images");
    final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
    print(response.body);
    if (response.statusCode == 200) {
      print("imagenes de post $postId cargadas");
      return json.decode(response.body);
    } else {
      print('Error al cargar imagenes. status code: ${response.statusCode}');
      Fluttertoast.showToast(
        msg: 'Error al cargar los imagenes. status code: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 162, 28, 28),
        textColor: Colors.white,
      );
      return [];
    }
  } catch (e) {  
    print('Error al cargar imagenes: $e');
    return [];
  }
}


Future<List<dynamic>> fetchPosts(String link) async {
  try {
    Uri url = sharedPrefs.getUrl("/posts");
    
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
        backgroundColor: const Color.fromARGB(255, 162, 28, 28),
        textColor: Colors.white,
      );
      return [];
    }
  } catch (e) {
    
    print('Error al cargar los posts: $e');
    return [];
  }
}

Future<void> addCommentToPost(String link, int postId, Map<String, dynamic> commentData) async {
  Uri url = sharedPrefs.getUrl("/posts/$postId");
  
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


Future<Map<String, dynamic>> fetchPost(String link, postId) async {
  try {
    Uri url = sharedPrefs.getUrl("/posts/$postId");
    Uri imageUrl = sharedPrefs.getUrl("/posts/$postId/images");
    final response = await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
    final imageResponse = await http.get(imageUrl, headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      Map<String, dynamic> postData = {
        "post": json.decode(response.body),
        "images": json.decode(imageResponse.body),
      };
      return postData;
    } else {
      print('Error al cargar los posts. Status Code: ${response.statusCode}');

      return {}; 
    }
  } catch (e) {
    print('Error al cargar post: $e');

    return {}; 
  }
}


  Future<List<dynamic>> fetchUsers(String link) async {
    try {
      Uri url = sharedPrefs.getUrl("/userlist");
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
        print(url);
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


Future<String> addUser(String link, Map<String, dynamic> userMap) async {
  try {
    Uri url = sharedPrefs.getUrl("/userlist"); 
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


Future<String> addPost(Map<String, dynamic> postMap) async {
  try {
    Uri url = sharedPrefs.getUrl("/posts");
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