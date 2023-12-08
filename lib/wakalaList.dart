import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

List<Widget> listviewArr() {
  return [
    Row(
      children: [
        Container(
          child: Column(
            children: [
              Text("Dentro de la multicancha"),
              Text("Por: "),
              Text("@usuario")
            ],
          ),
        ),
        Icon(Icons.arrow_back)
      ],
    )
  ];
}

class WakalaList extends StatelessWidget {
  const WakalaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Listado de Wakalas"),
          ListView(
            padding: const EdgeInsets.all(8),
            children: listviewArr(),
          )
        ],
      ),
    );
  }
}
