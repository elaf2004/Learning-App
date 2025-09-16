import 'package:app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter BLoC',
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/splash',
    );
  }
}

