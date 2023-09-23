import 'package:frontend/core/cubits/auth/auth_cubit.dart';
import 'package:frontend/core/cubits/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: 'Your Email',
                  label: Text('Email'),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Your password',
                  label: Text('Password'),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedInState) {
                  context.go('/home');
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context)
                        .login(emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55)),
                  child: const Text('Login'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
