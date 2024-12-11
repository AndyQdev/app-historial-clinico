import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SocketService() {
    // Inicializar notificaciones locales
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void connect() {
    final apiBase = Endpoints.baseSocket;
    _socket = IO.io('http://192.168.0.4:9092',{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    print(apiBase);
    print(_socket);
    print('ANTES DE CONECTAR');
    _socket.onConnect((_) {
      print('CONECTO!!!!!!');
      print('Conectado al servidor de Socket.IO');
    });

    _socket.onDisconnect((_) {
      print('Desconectado del servidor de Socket.IO');
    });

    _socket.on('notificacion', (data) {
      print('Notificación recibida: $data');
      _showNotification(data['titulo'], data['mensaje']);
    });
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('tu_canal_id', 'Tu Canal',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      title, // Título
      body, // Mensaje
      platformChannelSpecifics,
    );
  }

  void disconnect() {
    _socket.disconnect();
  }
}