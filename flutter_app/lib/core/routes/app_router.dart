import 'package:flutter/material.dart';

import 'package:app/features/auth/views/login_view.dart';
import 'package:app/features/auth/views/signup_views.dart';
import 'package:app/features/course/view/details_course.dart';
import 'package:app/features/course/view/topic_details.dart';
import 'package:app/features/home/views/home_view.dart';
import 'package:app/features/ob/views/ob1.dart';
import 'package:app/features/ob/views/ob2.dart';
import 'package:app/features/ob/views/ob3.dart';
import 'package:app/splach_screen.dart' show SplachScreen;
import 'package:app/features/ob/views/welcome.dart' show Welcome;

// Models
import 'package:app/features/home/model/course.dart';
import 'package:app/features/course/model/course_topic.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings s) {
    debugPrint('➡️ navigating to: ${s.name}');

    switch (s.name) {
      case '/':
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const Welcome());

      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplachScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupViews());

      case '/details_course': {
        // Expected: { 'course': Course, 'topics': List<CourseTopic> }
        final args = s.arguments;
        if (args is! Map<String, dynamic>) {
          return _error('Route /details_course needs a Map arguments.');
        }
        final course = args['course'];
        final topics = args['topics'];

        if (course is! Course) {
          return _error('Route /details_course: "course" must be a Course.');
        }
        if (topics is! List<CourseTopic>) {
          return _error('Route /details_course: "topics" must be List<CourseTopic>.');
        }

        return MaterialPageRoute(
          builder: (_) => DetailsCourse(course: course, topics: topics),
        );
      }

      case '/topic_details': {
        // Expected: CourseTopic
        final arg = s.arguments;
        if (arg is! CourseTopic) {
          return _error('Route /topic_details needs a CourseTopic argument.');
        }
        return MaterialPageRoute(
          builder: (_) => TopicDetails(),
        );
      }

      case '/ob1':
        return MaterialPageRoute(builder: (_) => const Ob1());
      case '/ob2':
        return MaterialPageRoute(builder: (_) => const Ob2());
      case '/ob3':
        return MaterialPageRoute(builder: (_) => const Ob3());

      default:
        return MaterialPageRoute(builder: (_) => const Welcome());
    }
  }

  static Route _error(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
