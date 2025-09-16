import 'package:flutter/material.dart';

class Ob2 extends StatelessWidget {
  const Ob2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Color(0xFF2FBDEF),
                child: Image.asset(
                  'assets/images/Group3.png',
                  width: 550,
                  height:400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Learn on your own ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF40DBD5)),
            ),
            const SizedBox(height: 30),
            const Text(
              'Access courses on the go, \n anytime, from anywhere.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            Spacer() ,
            Row(
              children: [
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                }, child: Text('Skip',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),)),
                Spacer(),
                Icon(Icons.circle, size: 10, color: Colors.grey),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Color(0xFF40DBD5)),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.grey),
                Spacer(),
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/ob3');
                }, child: Text('Next',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF40DBD5)),))

              ],
            )
          ],
        ),
      ),
    );
  }
}