import 'package:flutter/material.dart';
import 'package:app/features/home/model/course.dart';
class BulidVertical extends StatelessWidget {
  final Course course;
  const BulidVertical({super.key, required this.course});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              course.imageUrl?.isNotEmpty == true
                  ? course.imageUrl!
                  : 'https://via.placeholder.com/100',
              width: 100, height: 100, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100, height: 100, color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    course.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${course.price}\$',
                    style: const TextStyle(
                      fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
