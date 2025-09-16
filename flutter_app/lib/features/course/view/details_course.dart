import 'package:flutter/material.dart';

import 'package:app/features/home/model/course.dart';
import 'package:app/features/course/model/course_topic.dart'; // الكلاس الذي عملناه سابقاً
import 'package:app/features/course/widget/card_topic.dart';

class DetailsCourse extends StatefulWidget {
  const DetailsCourse({super.key, required this.course, required this.topics});

  final Course course;
  final List<CourseTopic> topics;

  @override
  State<DetailsCourse> createState() => _DetailsCourseState();
}

class _DetailsCourseState extends State<DetailsCourse> {
  static const double kMenuRadius = 110;
  static const double kMenuBottomGap = 24;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final scrollBottomPadding = kMenuRadius * 2 + kMenuBottomGap + bottomSafe;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(widget.course.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 12, 16, scrollBottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الكورس (اختياري)
              if ((widget.course.image ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo2.png',
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 12),
              Text(
                widget.course.category,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                widget.course.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.course.description,
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  _Pill(
                    text: '${widget.topics.length} Topics',
                    bg: const Color(0xFF0F6376),
                    fg: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  _Pill(
                    text: '${widget.course.price} \$',
                    bg: const Color(0xFFFFB84D),
                    fg: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ListView.separated(
                itemCount: widget.topics.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final t = widget.topics[i];

                  // اضبط بارامترات CardTopic حسب تعريفك
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/topic_details',
                        arguments: t, // أرسل CourseTopic كامل
                      );
                    },
                    child: CardTopic(
                      title: t.title,
                      // هذه افتراضات — بدّلها بما يناسب ويدجتك:
                      lessons: (t.durationMinutes ?? 0), // مثال
                      chapters: t.order,
                      duration: '${t.durationMinutes ?? 0} min',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
