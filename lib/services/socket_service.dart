import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketService {
  WebSocketChannel? _channel;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
  }

  void sendMessage(int toUser, String message) {
    _channel?.sink.add(jsonEncode({'to_user': toUser, 'message': message}));
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    _channel?.stream.listen((data) {
      final Map<String, dynamic> messageData = jsonDecode(data);
      callback(messageData);
    });
  }
}
