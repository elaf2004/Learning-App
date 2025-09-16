import 'package:app/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courses',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const RootShell(),
        '/home': (_) => const RootShell(),
        // '/details_course': (_) => const DetailsCourse(), // فعّل الراوت تبعك
      },
      // لو بدك راوتس إضافية:
      // onGenerateRoute: ...
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  final _pages = const <Widget>[
    HomeView(),
    _PlaceholderPage(title: 'Business'),
    _PlaceholderPage(title: 'School'),
    _PlaceholderPage(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( 
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),    label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business),label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.countertops),  label: 'School'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Index: $title', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
