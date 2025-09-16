import 'dart:convert';
import 'package:app/features/home/model/course.dart';
import 'package:http/http.dart';

class Repo {
  Repo();
  Future<List<Course>> getAllCourses() async {
    final response =
        await get(Uri.parse("http://10.0.2.2:8000/api/v1/courses"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'] as List;
      print(data);
      return data.map((item) => Course.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }
}
