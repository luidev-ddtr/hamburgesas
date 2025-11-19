import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Servicio para gestionar notificaciones push locales.
class PushNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static String diaActual = '';
  static late tz.Location location;
 
  // Lista de mensajes dinámicos para las notificaciones
  static final List<NotificationTemplate> _notificationTemplates = [
    // --- Reportes, Cierre y Ganancias Diarias ---
    NotificationTemplate(
      template: "💵 **Reporte Preliminar:** Ya tienes {orders} órdenes y {sales} en ventas para el turno de {shift}.",
      variables: ['orders', 'sales', 'shift']
    ),
    NotificationTemplate(
      template: "📊 **¡Corte de Caja Listo!** Ingresa para validar las ganancias del {dayOfWeek} {day} de {month}.",
      variables: ['dayOfWeek', 'day', 'month']
    ),
    NotificationTemplate(
      template: "⭐ **¡Felicidades, Equipo!** Hoy logramos un promedio de servicio de {avgTime} minutos. ¡Sigamos así!",
      variables: ['avgTime']
    ),
    NotificationTemplate(
      template: "💰 **Meta Alcanzada:** ¡Hemos superado el objetivo de ventas de {todayDate} por {percentage}%! Revisa el detalle.",
      variables: ['todayDate', 'percentage']
    ),

    // --- Recordatorios y Tareas ---
    NotificationTemplate(
      template: "🧹 **Recordatorio:** {taskName} programada para las {scheduledTime}.",
      variables: ['taskName', 'scheduledTime']
    ),
    NotificationTemplate(
      template: "📋 **Turno:** {employeeName}, tu turno {shiftType} comienza en {minutes} minutos. ¡Prepárate!",
      variables: ['employeeName', 'shiftType', 'minutes']
    ),
    
    // --- Nuevos mensajes más específicos ---
    NotificationTemplate(
      template: "🎯 **Actualización en Tiempo Real:** {completedOrders} órdenes completadas, {pending} en proceso. Eficiencia: {efficiency}%",
      variables: ['completedOrders', 'pending', 'efficiency']
    ),
    NotificationTemplate(
      template: "👥 **Cliente Frecuente:** {customerName} acaba de realizar su {visitCount}ª visita. ¡Dale la bienvenida especial!",
      variables: ['customerName', 'visitCount']
    ),
  ];

  /// Inicializa el servicio de notificaciones.
  ///
  /// Configura los ajustes para Android e iOS y solicita los permisos necesarios.
  Future<void> initialize() async {
    // Inicializar la configuración de zona horaria
    tz.initializeTimeZones();
    
    // Asegurarse de que la ubicación esté inicializada correctamente
    // Si la ubicación no se encuentra, se usará la ubicación por defecto (UTC)
    try {
      location = tz.getLocation('America/Mexico_City');
    } catch (e) {
      print('Error al obtener la zona horaria America/Mexico_City: $e');
      // Fallback a UTC si la zona horaria no se encuentra
      location = tz.UTC;
    }

    // Configuración para Android
    // Asegúrate de tener un ícono en 'android/app/src/main/res/mipmap/ic_launcher.png'
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

     await _requestPermissions();
  }

Future<void> _requestPermissions() async {
final androidImplementation = 
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  
  if (androidImplementation != null) {
    await androidImplementation.requestNotificationsPermission();
  }
}
  // Datos simulados para personalización
  static final List<String> _empleados = ['María González', 'Carlos Rodríguez', 'Ana Martínez', 'Luis Sánchez'];
  static final List<String> _tareasLimpieza = [
    'Limpieza profunda de cocina',
    'Desinfección de mesas y sillas',
    'Limpieza de área de bebidas',
    'Organización de almacén'
  ];
  static final List<String> _turnos = ['matutino', 'vespertino', 'nocturno'];

  /// Programa notificaciones para que se muestren periódicamente.
  Future<void> schedulePeriodicNotifications() async {
    // Cancelamos notificaciones anteriores para evitar duplicados si se llama varias veces.
    await _flutterLocalNotificationsPlugin.cancelAll();

    final random = Random();
    final template = _notificationTemplates[random.nextInt(_notificationTemplates.length)];
    
    // Generar datos realistas basados en la plantilla
    final data = _generateRealisticData(template.variables);
    
    // Reemplazar variables en el template
    String message = template.template;
    data.forEach((key, value) {
      message = message.replaceAll('{$key}', value);
    });

    // Añadir timestamp real (opcional, como en el showPersonalizedNotification original)
    final now = tz.TZDateTime.now(location);
    final timeInfo = _getFormattedTimeInfo(now);
    
    // Opcional: añadir contexto temporal
    if (random.nextBool()) {
      message += " \\n🕒 ${timeInfo['greeting']} - ${timeInfo['time']}";
    }

    // Detalles de la notificación para Android
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'hamburgesas_channel_id', // ID del canal
      'Notificaciones de Hamburguesas', // Nombre del canal
      channelDescription: 'Canal para notificaciones importantes de la app.',
      importance: Importance.high, // Cambiado a high para consistencia
      priority: Priority.high, // Cambiado a high para consistencia
      styleInformation: BigTextStyleInformation( // Usar BigTextStyleInformation para mensajes largos
        _formatMessageForDisplay(message), // Mensaje completo para vista expandida
        htmlFormatBigText: true,
        contentTitle: 'Real Campestre', // Título en la vista expandida
        htmlFormatContentTitle: true,
      ),
    );

    // Detalles de la notificación para iOS
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

// ✅ Ahora (v18.x)
await _flutterLocalNotificationsPlugin.periodicallyShowWithDuration(
  0, // ID de la notificación
  'Real Campestre', // Título de la notificación
  _formatMessageForDisplay(message), // Mensaje de la notificación
  const Duration(minutes: 1), // ← Usa Duration
  platformChannelSpecifics,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ← Nuevo parámetro
);

  }

  /// Genera datos realistas para las variables del template
  Map<String, String> _generateRealisticData(List<String> variables) {
    final random = Random();
    final data = <String, String>{};
    final now = tz.TZDateTime.now(location);

    for (final variable in variables) {
      switch (variable) {
        case 'orders':
          data['orders'] = '${random.nextInt(15) + 5}'; // 5-20 órdenes
          break;
        case 'sales':
          final sales = (random.nextDouble() * 8000 + 2000).toStringAsFixed(0);
          data['sales'] = '\$${sales} MXN';
          break;
        case 'shift':
          data['shift'] = _turnos[random.nextInt(_turnos.length)];
          break;
        case 'dayOfWeek':
          data['dayOfWeek'] = _getSpanishDayOfWeek(now.weekday);
          break;
        case 'day':
          data['day'] = '${now.day}';
          break;
        case 'month':
          data['month'] = _getSpanishMonth(now.month);
          break;
        case 'avgTime':
          data['avgTime'] = '${random.nextInt(10) + 8}'; // 8-18 minutos
          break;
        case 'todayDate':
          data['todayDate'] = '${now.day} de ${_getSpanishMonth(now.month)}';
          break;
        case 'percentage':
          data['percentage'] = '${random.nextInt(30) + 5}'; // 5-35%
          break;
        case 'taskName':
          data['taskName'] = _tareasLimpieza[random.nextInt(_tareasLimpieza.length)];
          break;
        case 'scheduledTime':
          final hour = random.nextInt(6) + 17; // 17-22 hrs
          data['scheduledTime'] = '$hour:${random.nextInt(2) == 0 ? '00' : '30'}';
          break;
        case 'employeeName':
          data['employeeName'] = _empleados[random.nextInt(_empleados.length)];
          break;
        case 'shiftType':
          data['shiftType'] = _turnos[random.nextInt(_turnos.length)];
          break;
        case 'minutes':
          data['minutes'] = '${random.nextInt(20) + 10}'; // 10-30 minutos
          break;
        case 'completedOrders':
          data['completedOrders'] = '${random.nextInt(50) + 10}';
          break;
        case 'pending':
          data['pending'] = '${random.nextInt(8) + 2}';
          break;
        case 'efficiency':
          data['efficiency'] = '${random.nextInt(20) + 80}'; // 80-100%
          break;
        case 'customerName':
          data['customerName'] = _generateCustomerName();
          break;
        case 'visitCount':
          data['visitCount'] = '${random.nextInt(10) + 3}'; // 3-12 visitas
          break;
        default:
          data[variable] = 'N/A';
      }
    }
    
    return data;
  }

  /// Genera un título personalizado según el contexto
  String _generatePersonalizedTitle() {
    final random = Random();
    final titles = [
      '📈 Actualización de Ventas',
      '👥 Gestión de Turnos',
      '🧹 Mantenimiento Programado',
      '💰 Logro de Metas',
      '⭐ Buenas Noticias',
      '🎯 Reporte en Tiempo Real'
    ];
    return titles[random.nextInt(titles.length)];
  }

  /// Formatea el mensaje para mostrar negritas usando etiquetas HTML.
  String _formatMessageForDisplay(String message) {
    // Reemplaza **texto** con <b>texto</b> para que Android lo interprete como negrita.
    return message.replaceAllMapped(
  RegExp(r'\*\*(.*?)\*\*'),
  (match) => '<b>${match.group(1)}</b>',
);
  }

  /// Obtiene información formateada del tiempo
  Map<String, String> _getFormattedTimeInfo(tz.TZDateTime now) {
    final hour = now.hour;
    String greeting;
    
    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }
    
    return {
      'greeting': greeting,
      'time': '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
    };
  }

  /// Helper methods para fechas en español
  String _getSpanishDayOfWeek(int day) {
    const days = ['', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    return days[day];
  }

  String _getSpanishMonth(int month) {
    const months = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
                   'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return months[month];
  }

  String _generateCustomerName() {
    final names = ['Alejandro', 'Fernanda', 'Ricardo', 'Gabriela', 'Diego', 'Patricia'];
    final lastNames = ['Hernández', 'García', 'Martínez', 'López', 'González'];
    final random = Random();
    return '${names[random.nextInt(names.length)]} ${lastNames[random.nextInt(lastNames.length)]}';
  }
}

/// Clase para definir plantillas de notificación con variables
class NotificationTemplate {
  final String template;
  final List<String> variables;

  NotificationTemplate({required this.template, required this.variables});
}