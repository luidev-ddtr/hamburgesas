import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/widget/app_initializer_screen.dart';

/// Punto de entrada principal de la aplicación Flutter.
void main() async {
  // Asegura que los bindings de Flutter estén inicializados. Esto es crucial
  // para poder llamar a código nativo antes de que se ejecute runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Ejecuta la aplicación. La inicialización de servicios se delega
  // a AppInitializerScreen para asegurar que el contexto de la app esté disponible.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      // TEMA ACTUALIZADO: Usa la fuente predeterminada del sistema (legible y limpia)
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        // No se especifica 'fontFamily', por lo que usa la fuente del sistema.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 2.0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ), 
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
      home: const AppInitializerScreen(),
    );
  }
}
