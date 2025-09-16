import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopicDetails extends StatefulWidget {
  const TopicDetails({super.key});
  @override
  State<TopicDetails> createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  // بيانات تجريبية
  final List<_WeekItem> weeks = const [
    _WeekItem(weekLabel: 'Week 1-2', title: 'Introduction to UI/UX Design'),
    _WeekItem(weekLabel: 'Week 3-4', title: 'User Research & Analysis'),
    _WeekItem(weekLabel: 'Week 5-6', title: 'Wireframing & Prototyping'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ================= Header (صورة + رجوع + Play) =================
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            expandedHeight: 230,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.pexels.com/photos/3184306/pexels-photo-3184306.jpeg',
                    fit: BoxFit.cover,
                  ),
                  const _BottomGradient(),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _CircleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Material(
                      color: Colors.white.withOpacity(.9),
                      shape: const CircleBorder(),
                      elevation: 6,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.play_arrow_rounded, size: 34),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ================= المعلومات والنصوص =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '48 Lessons  •  25 Chapters',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'UI & UX Design Basic',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  // ✅ أعطينا الـ AvatarStack عرضًا محددًا حتى لا يكون غير منتهٍ داخل Row
                  Row(
                    children: [
                      const _AvatarStack(), // فيها عرض محسوب بالداخل
                      const SizedBox(width: 8),
                      _Pill(text: '163+', bg: Colors.teal.shade700),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A UI/UX Designer is a professional who identifies opportunities to create better user '
                    'experiences. Aesthetically pleasing branding strategies help them effectively reach new '
                    'customers. They also ensure that end-to-end journeys with their products or services '
                    'meet desired outcomes.',
                    style: TextStyle(color: Colors.grey[800], height: 1.4),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          // ================= قائمة الأسابيع =================
          // لا يوجد SliverList.separated بالـ SDK القياسي → نبني فواصل يدويًا
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index.isOdd) {
                return const SizedBox(height: 10); // فاصل
              }
              final i = index ~/ 2;
              final item = weeks[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _WeekTile(item: item),
              );
            }, childCount: weeks.isEmpty ? 0 : (weeks.length * 2 - 1)),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ), // مساحة للـ FAB
        ],
      ),
    );
  }
}

/* ==================== Widgets مساعدة ==================== */
class _BottomGradient extends StatelessWidget {
  const _BottomGradient();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: Container(
          height: 90,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  const _Pill({required this.text, required this.bg});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();
  @override
  Widget build(BuildContext context) {
    const urls = [
      'https://i.pravatar.cc/150?img=3',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=8',
    ];
    // ✅ احسب عرض الستاك: عرض دائرة واحدة (32) + تراكب 22 لكل أفاتار إضافي
    final double width = 32 + (urls.length - 1) * 22;
    return SizedBox(
      height: 32,
      width: width, // مهم جدًا حتى لا يكون Stack بلا قيود داخل Row
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(urls.length, (i) {
          return Positioned(
            left: i * 22,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(urls[i]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _WeekItem {
  final String weekLabel;
  final String title;
  const _WeekItem({required this.weekLabel, required this.title});
}

class _WeekTile extends StatelessWidget {
  final _WeekItem item;
  const _WeekTile({required this.item});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFEFF6F7),
            child: Icon(Icons.menu_book_outlined, color: Colors.teal.shade700),
          ),
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(item.weekLabel),
          trailing: Text('12 min', style: TextStyle(color: Colors.grey[700])),
          onTap: () {},
        ),
      ),
    );
  }
}
