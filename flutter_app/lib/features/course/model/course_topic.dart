class CourseTopic {
  final int id;
  final int courseId;
  final String title;
  final String? content;
  final int order;
  final int? durationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseTopic({
    required this.id,
    required this.courseId,
    required this.title,
    this.content,
    required this.order,
    this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  // ---------- fromJson ----------
  factory CourseTopic.fromJson(Map<String, dynamic> json) {
    return CourseTopic(
      id: json['id'] as int,
      courseId: json['course_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      order: json['order'] as int,
      durationMinutes: json['duration_minutes'] != null
          ? json['duration_minutes'] as int
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // ---------- toJson ----------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'content': content,
      'order': order,
      'duration_minutes': durationMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ---------- copyWith (اختياري) ----------
  CourseTopic copyWith({
    int? id,
    int? courseId,
    String? title,
    String? content,
    int? order,
    int? durationMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseTopic(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
