import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto')), 
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.file(File(imagePath)),
              ),
            ), 
          ),
          //  Contenedor con margen inferior para subir los botones
          Container(
            color: Colors.black,
            margin: const EdgeInsets.only(bottom: 40), //  Ajusta este valor
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, imagePath);
                  },
                  child: const Text('Aceptar'),
                ),
                const SizedBox(width: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tomar otra'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}