import 'package:app/features/profile/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:app/core/shared_prefrence/auth.dart';
import 'package:app/features/course/data/repo_course.dart';
import 'package:app/features/course/view/my_courses.dart';
import 'package:app/features/home/data/repo.dart';
import 'package:app/features/home/model/course.dart';
import 'package:app/features/home/widgets/bulid_horizontal.dart';
import 'package:app/features/home/widgets/bulid_vertical.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _tabIndex = 0;
  final List<String> categories = const [
    'All',
    'UI/UX',
    'Animation',
    'Design',
    'Flutter',
    'Python',
  ];
  String _selectedCategory = 'All';
  final TextEditingController _searchCtrl = TextEditingController();
  late final Future<List<Course>> futureCourses;
  late final Future<String?> name;
  @override
  void initState() {
    super.initState();
    futureCourses = Repo().getAllCourses();
    name = getname();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ------------ Helpers ------------
  List<Course> _applyFilters(List<Course> courses) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final sel = _selectedCategory;
    bool matchesCategory(Course c) {
      if (sel == 'All') return true;
      final cat = (c.category).toString();
      return cat.toLowerCase() == sel.toLowerCase();
    }

    bool matchesQuery(Course c) {
      if (query.isEmpty) return true;
      return ('${c.title} ${c.description}').toLowerCase().contains(query);
    }

    return courses.where((c) => matchesCategory(c) && matchesQuery(c)).toList();
  }

  Future<void> _openCourseDetails(BuildContext context, Course course) async {
    try {
      final topics = await RepoCourse().getTopics(course.id); // expects int id
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/details_course',
        arguments: {'course': course, 'topics': topics},
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load topics: $e')));
    }
  }

  // ------------ Tabs ------------
  Widget _buildHomeTab(double scrollBottomPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 20, 20, scrollBottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              FutureBuilder<String?>(
                future: name,
                builder: (context, snap) {
                  final username =
                      (snap.connectionState == ConnectionState.done)
                      ? (snap.data?.isNotEmpty == true ? snap.data! : 'Ahmad')
                      : '...';
                  return Text(
                    'Hello, $username',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, size: 28),
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/55980690?v=4',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Lets learn ',
            style: TextStyle(fontSize: 28, color: Colors.grey[600]),
          ),
          const Text(
            'something new today',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Search
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 26),
              hintText: 'Search for anything',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: _searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Chips
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    _selectedCategory = cat;
                    // _searchCtrl.clear(); // (اختياري) امسح البحث عند تغيير الفئة
                  }),
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.grey[200],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Data
          FutureBuilder<List<Course>>(
            future: futureCourses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final allCourses = snapshot.data ?? const <Course>[];
              final courses = _applyFilters(allCourses);

              if (courses.isEmpty) {
                final reason = _selectedCategory == 'All'
                    ? 'for your search.'
                    : 'in "${_selectedCategory}" for your search.';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No courses found $reason',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? 'Popular Categories'
                        : '${_selectedCategory} Picks',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Horizontal list
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      itemBuilder: (_, i) => Padding(
                        padding: EdgeInsets.only(
                          right: i == courses.length - 1 ? 0 : 10,
                        ),
                        child: InkWell(
                          onTap: () => _openCourseDetails(context, courses[i]),
                          child: BulidHorizontal(course: courses[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    _selectedCategory == 'All'
                        ? 'Popular Courses'
                        : '${_selectedCategory} Courses',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Vertical list
                  ListView.builder(
                    itemCount: courses.length,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => _openCourseDetails(context, courses[i]),
                      child: BulidVertical(course: courses[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollBottomPadding =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight + 12;
    final pages = <Widget>[
      _buildHomeTab(scrollBottomPadding),
      const MyCourses(),
      Profile(),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tabIndex, children: pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 29, 50, 78),
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'my Courses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'pofile'),
        ],
      ),
    );
  }
}
