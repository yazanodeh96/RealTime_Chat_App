import 'package:chatapp/model/user.dart';
import 'package:chatapp/services/api_service.dart';

class UserController {
  final ApiService _apiService;

  UserController(this._apiService);

  Future<List<User>> getUsers() async {
    return await _apiService.getUsers();
  }
}
