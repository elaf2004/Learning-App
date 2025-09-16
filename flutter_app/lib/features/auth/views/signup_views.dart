import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/singup_bloc/singup_bloc.dart';
import 'package:app/features/auth/singup_bloc/singup_event.dart';
import 'package:app/features/auth/singup_bloc/singup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupViews extends StatefulWidget {
  const SignupViews({super.key});

  @override
  State<SignupViews> createState() => _SignupViewsState();
}

class _SignupViewsState extends State<SignupViews> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingupBloc(AuthRepository()),
      child: BlocListener<SingupBloc, SingupState>(
        listenWhen: (prev, curr) =>
            prev.success != curr.success || prev.error != curr.error,
        listener: (context, state) {
          if (state.success && context.mounted) {
            // الانتقال للصفحة الرئيسية عند التسجيل بنجاح
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<SingupBloc, SingupState>(
                builder: (context, state) {
                  final bloc = context.read<SingupBloc>();
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your details to sign up',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) =>
                              bloc.add(SingupNameChanged(value)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Name',
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) =>
                              bloc.add(SingupEmailChanged(value)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) =>
                              bloc.add(SingupPasswordChanged(value)),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) =>
                              bloc.add(SingupPasswordConfirmChanged(value)),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 24),
                        state.loading
                            ? const CircularProgressIndicator()
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF40DBD5),
                                      Color.fromARGB(255, 9, 35, 203),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // إرسال الحدث لتسجيل المستخدم
                                    bloc.add(const SingupSubmitted());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
