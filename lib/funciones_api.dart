import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<dynamic>? userList;

Future<void> editarContadores(
    String link, int postId, Map<String, dynamic> contador) async {
  var url = Uri.http(link, "/posts/$postId");
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

Future<List<dynamic>> fetchPosts(String link) async {
  try {
    var url = Uri.http(link, "/posts");
    final response =
        await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});
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

Future<void> addCommentToPost(
    String link, int postId, Map<String, dynamic> commentData) async {
  var url = Uri.http(link, "/posts/$postId");
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
    var url = Uri.http(link, "/posts/$postId");
    final response =
        await http.get(url, headers: {'ngrok-skip-browser-warning': 'true'});

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

Future<List<dynamic>> fetchUsers(String link) async {
  try {
    var url = Uri.http(link, "/userlist");
    final response = await http.get(url, headers: {});
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

Future<String> addUser(String link, Map<String, dynamic> userMap) async {
  try {
    var url = Uri.http(link, "/userlist");
    var response = await http.post(url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(userMap));
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
