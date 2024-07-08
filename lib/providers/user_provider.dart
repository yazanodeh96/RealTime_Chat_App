import 'package:chatapp/model/user.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<User> _users = [];
  String _errorMessage = '';
  bool _hasError = false;

  List<User> get users => _users;
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;

  Future<void> fetchUsers() async {
    try {
      _hasError = false;
      _errorMessage = '';
      _users = await apiService.fetchUsers();
      notifyListeners();
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Failed to fetch users: $error';
      notifyListeners();
    }
  }
}
