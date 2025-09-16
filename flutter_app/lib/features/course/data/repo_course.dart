// lib/features/course/data/repo_course.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/features/course/model/course_topic.dart';
import 'package:app/features/course/model/my_courses_model.dart';

class RepoCourse {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1';

  /// Topics (عامّة كما كتبت)
  Future<List<CourseTopic>> getTopics(int courseId) async {
    final uri = Uri.parse('$baseUrl/courses/$courseId/topics');
    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }
    dynamic decoded;
    try {
      decoded = jsonDecode(res.body);
    } catch (_) {
      throw Exception('Invalid JSON from server');
    }
    final dynamic listLike =
        (decoded is List)
            ? decoded
            : (decoded is Map
                ? (decoded['data'] ?? decoded['topics'] ?? decoded['items'])
                : null);
    if (listLike == null) return <CourseTopic>[];
    if (listLike is! List) {
      throw Exception('Unexpected payload shape (not a List)');
    }
    return listLike
        .where((e) => e != null)
        .map<CourseTopic>((e) => CourseTopic.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// My Courses (محمية بالتوكن: Sanctum)
  Future<List<MyCoursesModel>> getMyCourse({
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/my-courses');

    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 401) {
      throw Exception('Unauthenticated (401): تأكد من التوكن');
    }
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(res.body);
    } catch (_) {
      throw Exception('Invalid JSON from server');
    }

    // الـ API يُرجع List مباشرة (حسب الكود الأخير)
    // لكن ندعم أيضاً شكل {data: [...]} احتياطاً
    if (decoded is List) {
      return decoded
          .map<MyCoursesModel>((e) => MyCoursesModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    }

    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .map<MyCoursesModel>((e) => MyCoursesModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    }

    // لا بيانات
    return <MyCoursesModel>[];
  }
}
