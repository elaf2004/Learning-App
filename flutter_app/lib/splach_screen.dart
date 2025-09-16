import 'package:app/core/shared_prefrence/auth.dart';
import 'package:flutter/material.dart';
class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});
  @override
  State<SplachScreen> createState() => _SplachScreenState();
}
class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Future token=getToken();
      token.then((value) {
        if(value!=null){
          Navigator.of(context).pushReplacementNamed('/home');
        }else{
          Navigator.of(context).pushReplacementNamed('/welcome');
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo2.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
