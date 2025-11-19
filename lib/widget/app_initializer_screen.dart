import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/screens/login_screen.dart';
import 'package:flutter_hamburgesas/services/push_notification.dart';

class AppInitializerScreen extends StatefulWidget {
  const AppInitializerScreen({super.key});

  @override
  State<AppInitializerScreen> createState() => _AppInitializerScreenState();
}

class _AppInitializerScreenState extends State<AppInitializerScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Inicializa y programa las notificaciones.
    final PushNotificationService notificationService = PushNotificationService();
    await notificationService.initialize();
    // Para pruebas, las notificaciones se envían cada minuto.
    await notificationService.schedulePeriodicNotifications();

    // Navega a la página de login cuando todo esté listo.
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Muestra un indicador de carga mientras se inicializan los servicios.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF980101),
        ),
      ),
    );
  }
}