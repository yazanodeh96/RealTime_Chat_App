import 'package:chatapp/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final ApiService apiService;
  AuthController(this.apiService);

  Future<bool> login(String email, String password) async {
    final result = await apiService.login(email, password);

    if (result.isNotEmpty && result['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', result['token']);
      apiService.setToken(result['token']);
      return true;
    }
    return false;

    // if (result['token'].toString() != null) {
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', result['token'].toString());
    //   print("result['token']= " + result['token'].toString());
    //   return true;
    // }
    // print("result['token']= " + result['token'].toString());
    // return false;
  }

  Future<bool> signup(String firstName, String lastName, String email,
      String password, String phone) async {
    final result =
        await apiService.signup(firstName, lastName, email, password, phone);

    return result['success'];
  }

  Future<void> logout() async {
    await apiService.logout();
  }
}
