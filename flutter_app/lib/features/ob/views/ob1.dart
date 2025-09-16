import 'package:flutter/material.dart';

class Ob1 extends StatelessWidget {
  const Ob1({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Color(0xFfFA985A),
                child: Image.asset(
                  'assets/images/Group4.png',
                  width: 550,
                  height:400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Explore a wide range of',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const Text(
              'IT Courses',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF40DBD5)),
            ),
            const SizedBox(height: 30),
            const Text(
              'From coding to \n cybersecurity, we have it all!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 50),
            Spacer() ,
            Row(
              children: [
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                }, child: Text('Skip',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),)),
                Spacer(),
                Icon(Icons.circle, size: 10, color:Color(0xFF40DBD5)),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.grey),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.grey),
                Spacer(),
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/ob2');
                }, child: Text('Next',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF40DBD5)),))

              ],
            )
          ],
        ),
      ),
    );
  }
}