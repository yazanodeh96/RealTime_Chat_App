import 'package:chatapp/services/api_service.dart';

import 'package:chatapp/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'services/socket_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();
  final SocketService socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    socketService.connect('wss://flutter.codexal.co/ws/'); // new
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        Provider<SocketService>(
          create: (_) => SocketService(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            Provider.of<SocketService>(context, listen: false),
            Provider.of<ApiService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splashscreen(),
      ),
    );
  }
}
