// lib/features/course/model/my_courses_model.dart
class MyCoursesModel {
  final int courseId;
  final String title;
  final String author;
  final String image;

  /// progress
  final int percent;          // 0..100
  final String percentLabel;  // "75% to complete"
  final double progress;      // 0.0..1.0

  /// time left
  final int timeLeftMinutes;
  final String timeLeftLabel; // "36min" أو "1h 12m"

  /// meta
  final int lessons;          // "48 Lessons"
  final int durationMinutes;
  final String durationLabel; // "2h 45min"

  const MyCoursesModel({
    required this.courseId,
    required this.title,
    required this.author,
    required this.image,
    required this.percent,
    required this.percentLabel,
    required this.progress,
    required this.timeLeftMinutes,
    required this.timeLeftLabel,
    required this.lessons,
    required this.durationMinutes,
    required this.durationLabel,
  });

  factory MyCoursesModel.fromJson(Map<String, dynamic> j) {
    return MyCoursesModel(
      courseId: (j['courseId'] ?? 0) as int,
      title: (j['title'] ?? '') as String,
      author: (j['author'] ?? '') as String,
      image: (j['image'] ?? '') as String,
      percent: (j['percent'] ?? 0) as int,
      percentLabel: (j['percentLabel'] ?? '') as String,
      progress: (j['progress'] ?? 0.0).toDouble(),
      timeLeftMinutes: (j['timeLeftMinutes'] ?? 0) as int,
      timeLeftLabel: (j['timeLeftLabel'] ?? '') as String,
      lessons: (j['lessons'] ?? 0) as int,
      durationMinutes: (j['durationMinutes'] ?? 0) as int,
      durationLabel: (j['durationLabel'] ?? '') as String,
    );
  }

  static List<MyCoursesModel> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => MyCoursesModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => MyCoursesModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
