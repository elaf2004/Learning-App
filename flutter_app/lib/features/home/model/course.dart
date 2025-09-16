class Course {
  final int id;
  final String title;
  final String price;
  final String? image;
  final String category;
  final int teacherId;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int topicsCount;
  final String? imageUrl;
  final Teacher teacher;

  Course({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    required this.category,
    required this.teacherId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.topicsCount,
    this.imageUrl,
    required this.teacher,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      category: json['category'],
      teacherId: json['teacher_id'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      topicsCount: json['topics_count'],
      imageUrl: json['image_url'],
      teacher: Teacher.fromJson(json['teacher']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'teacher_id': teacherId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'topics_count': topicsCount,
      'image_url': imageUrl,
      'teacher': teacher.toJson(),
    };
  }
}

class Teacher {
  final int id;
  final String name;
  final String? avatar;

  Teacher({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}
