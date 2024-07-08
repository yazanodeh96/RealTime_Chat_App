import 'package:chatapp/model/message.dart';
import 'package:chatapp/model/user.dart';
import 'package:chatapp/services/socket_service.dart';
import 'package:chatapp/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  List<User> _users = [];
  final SocketService _socketService;
  final ApiService _apiService;

  ChatProvider(this._socketService, this._apiService) {
    _socketService.onMessage((data) {
      _messages.add(Message.fromJson(data));
      notifyListeners();
    });
    fetchUsers();
  }

  List<Message> get messages => _messages;
  List<User> get users => _users;

  void sendMessage(int toUser, String message) {
    _socketService.sendMessage(toUser, message);
    _messages
        .add(Message(fromUser: 1, toUser: toUser, message: message)); // new
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    try {
      await _apiService.loadToken();
      final List<User> userData = await _apiService.fetchUsers();
      _users = userData;
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
  // Future<void> fetchUsers() async {
  //   try {
  //     final List<User> userData = await _apiService.fetchUsers();
  //     _users = userData;
  //     notifyListeners();
  //   } catch (error) {
  //     print('Error fetching users: $error');
  //   }

  // try {
  //   _users = await _apiService.fetchUsers();
  //   notifyListeners();
  // } catch (e) {
  //   print('Error fetching users: $e');
  // }
}



// import 'package:chatapp/model/message.dart';
// import 'package:chatapp/services/socket_service.dart';
// import 'package:flutter/material.dart';

// class ChatProvider with ChangeNotifier {
//   List<Message> _messages = [];
//   final SocketService _socketService;

//   ChatProvider(this._socketService) {
//     _socketService.onMessage((data) {
//       _messages.add(Message.fromJson(data));
//       notifyListeners();
//     });
//   }

//   List<Message> get messages => _messages;

//   void sendMessage(int toUser, String message) {
//     _socketService.sendMessage(toUser, message);
//   }
// }
