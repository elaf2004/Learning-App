import 'package:shared_preferences/shared_preferences.dart';
void saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}
void removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
void saveUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user_id', userId);
}
Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}
void removeUserId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
}
void savename(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
}
Future<String?> getname() async {
  final prefs = await SharedPreferences.getInstance();
  print(prefs.getString('name'));
  return prefs.getString('name');
}
void removenames() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('name');
}
void clearAuthData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  await prefs.remove('name');
  await prefs.remove('user_id');
}
