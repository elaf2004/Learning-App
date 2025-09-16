import 'package:flutter/material.dart';

class CardTopic extends StatelessWidget {
  final String title;
  final int lessons;
  final int chapters;
  final String duration;
  const CardTopic({
    super.key,
    required this.title,
    required this.lessons,
    required this.chapters,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('$lessons Lessons'),
                      const SizedBox(width: 12),
                      Text('$chapters Chapters'),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 14,
              child: const Icon(Icons.arrow_outward, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
