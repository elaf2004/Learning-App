import 'package:flutter/material.dart';

class Ob3 extends StatelessWidget {
  const Ob3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Color(0xFF2FBDEF),
                child: Image.asset(
                  'assets/images/image.png',
                  width: 550,
                  height:400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready to dive into ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            const Text(
              'Learning?',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF40DBD5)),
            ),
            const SizedBox(height: 30),
            const Text(
              'Access courses on the go,  \n anytime, from anywhere',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF40DBD5), Color.fromARGB(255, 9, 35, 203)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}