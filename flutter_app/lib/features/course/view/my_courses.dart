// lib/features/course/view/my_courses.dart
import 'package:app/core/shared_prefrence/auth.dart';
import 'package:app/features/course/data/repo_course.dart';
import 'package:flutter/material.dart';
import '../model/my_courses_model.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final repo = RepoCourse();
  late Future<List<MyCoursesModel>> future;

  @override
  void initState() {
    super.initState();
    future = _loadMyCourses();
  }

  Future<List<MyCoursesModel>> _loadMyCourses() async {
    final t = await getToken(); // from SharedPreferences (auth.dart)
    if (t == null || t.isEmpty) {
      // خليه يرمي خطأ واضح؛ الـ FutureBuilder راح يعرضه
      throw Exception('No auth token. Please login first.');
    }
    return repo.getMyCourse(token: t);
  }

  void _refresh() {
    setState(() {
      future = _loadMyCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('My Courses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: FutureBuilder<List<MyCoursesModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            final msg = snap.error?.toString() ?? 'Unknown error';
            // لو التوكن مفقود، اعرض CTA بسيط لتسجيل الدخول
            final needLogin = msg.contains('No auth token') || msg.contains('Unauthenticated');
            if (needLogin) {
              return _EmptyState(
                title: 'Please login',
                subtitle: 'You need to sign in to see your courses.',
                actionLabel: 'Go to Login',
                onAction: () {
                  // TODO: وجّه لصفحة تسجيل الدخول في تطبيقك
                  // Navigator.pushNamed(context, '/auth/login');
                },
              );
            }
            return Center(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Error: $msg', textAlign: TextAlign.center),
            ));
          }

          final data = snap.data ?? const <MyCoursesModel>[];
          if (data.isEmpty) {
            return _EmptyState(
              title: 'No courses yet',
              subtitle: 'When you enroll in a course, it will appear here.',
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _CourseCard(course: data[i]),
            ),
          );
        },
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});
  final MyCoursesModel course;

  Color get _accent => const Color(0xFF0F8A8A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: Container
      (
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Progress header ---
            Row(
              children: [
                Text(
                  course.percentLabel, // "75% to complete"
                  style: TextStyle(
                    color: _accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  course.timeLeftLabel, // "36min"
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- Progress bar ---
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 8,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey.shade200),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: course.progress.clamp(0.0, 1.0),
                      child: Container(color: _accent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // --- Content row ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // النصوص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${course.author}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      // ميتاداتا: عدد الدروس + المدّة
                      Row(
                        children: [
                          const Icon(Icons.menu_book_outlined, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${course.lessons} Lessons',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _Dot(),
                          const SizedBox(width: 12),
                          const Icon(Icons.av_timer, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            course.durationLabel, // "2h 45m"
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // الصورة
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          course.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: Color(0xFFEFEFEF)),
                        ),
                        // زر صغير أعلى اليمين (اختياري)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.teal.shade700,
                            shape: const CircleBorder(),
                            child: const SizedBox(
                              width: 28,
                              height: 28,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ]
          ],
        ),
      ),
    );
  }
}
