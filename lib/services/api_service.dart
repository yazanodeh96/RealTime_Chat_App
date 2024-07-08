import 'dart:convert';
import 'package:chatapp/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://flutter.codexal.co/api/';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    print('Loaded token: $_token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/user/log-in'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final token = responseBody['data']['access_token'];
      _token = token;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      return {'token': token};
    } else {
      print('Login failed with status : ${response.statusCode} ');
      return {};
    }
  }

  Future<Map<String, dynamic>> signup(String firstName, String lastName,
      String email, String password, String phone) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/user/sign-up'),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    return json.decode(response.body);
  }

  Future<void> logout() async {
    final response = await http.get(Uri.parse('${baseUrl}auth/user/log-out'));
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = null;
  }

  Future<List<User>> getUsers() async {
    await loadToken();
    final response = await http.get(
      Uri.parse('${baseUrl}users'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> sendMessage(int userId, String message) async {
    await loadToken();
    final response = await http.post(
      Uri.parse('${baseUrl}user/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
      body: {'message': message},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  Future<List<User>> fetchUsers() async {
    // var reqHeader = {
    //   "access-token": "" // TODO: pass the <access-token> as a header here
    // };

    final reqURI = '${baseUrl}users';
    print(reqURI);
    await loadToken();

    if (_token == null) {
      throw Exception('Token is null');
    }
    final response = await http.get(Uri.parse('${baseUrl}users'),
        headers: {'Authorization': 'Bearer $_token'});

    // final response = await http.get(Uri.parse('${baseUrl}users'));
    // final response = await http.get(reqURI, headers: reqHeader);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print('Decoded response body: $responseBody');

      if (responseBody['data'] != null &&
          responseBody['data']['users'] != null) {
            
        final List<dynamic> userJson = responseBody['data']['users'];
        return userJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load users');
    }
    // final List<dynamic> userJson = json.decode(response.body);
    //   return userJson.map((json) => User.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load users');
    // }
  }
}
