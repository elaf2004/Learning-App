import 'dart:convert';
import 'package:app/core/shared_prefrence/auth.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final _client = http.Client();
  final Uri url = Uri.parse("http://10.0.2.2:8000/api/v1/auth/login");

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      url,
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      print(response.body);
      saveToken(jsonDecode(response.body)['data']['token']);
      saveUserId(jsonDecode(response.body)['data']['user']['id']);
      savename(jsonDecode(response.body)['data']['user']['name']);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signup(
  String name,
  String email,
  String password,
  String passwordConfirmation,
) async {
  var url = Uri.parse("http://10.0.2.2:8000/api/v1/auth/register");
  final response = await _client.post(
    url,
    body: {
      'name': name,
      'email': email,
      'password': password,
      "password_confirmation": passwordConfirmation,
      "device_name": "android",
    },
  );

  // حاول قراءة JSON حتى لو كان statusCode != 200
  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    saveUserId(data['user']['id']);
    savename(data['user']['name']);
    saveToken(data['token']);
    return data; // الآن البلوك سيتحقق من data['status'] بدل Exception
  } catch (e) {
    throw Exception('Signup failed: ${response.body}');
  }
}

}
