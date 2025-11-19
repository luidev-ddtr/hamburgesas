import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/widget/app_initializer_screen.dart'; // Importación original
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Importa el archivo generado por FlutterFire (Asegúrate de que exista)
import 'firebase_options.dart';

// --- MANEJADOR DE MENSAJES EN BACKGROUND ---
// Debe ser una función de alto nivel (fuera de cualquier clase)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inicialización de Firebase necesaria si la app está totalmente cerrada
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
  print("Data: ${message.data}");
  // Aquí no se puede mostrar UI, solo lógica de datos o logging
}

// ------------------------------------------

/// Punto de entrada principal de la aplicación Flutter.
void main() async {
  // Asegura que los bindings de Flutter estén inicializados.
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase (Crucial para usar FirebaseMessaging)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Asignar el manejador de mensajes en background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Ejecuta la aplicación.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Hamburguesas y Notificaciones',
      // TEMA ORIGINAL APLICADO
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
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
      // Se utiliza la pantalla de inicialización original
      home: const AppInitializerScreen(),
    );
  }
}

