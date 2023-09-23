import 'package:frontend/core/cubits/auth/auth_cubit.dart';
import 'package:frontend/core/cubits/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<AuthCubit>(context).state;

    // Delay the navigation to the next frame
    Future.microtask(() {
      if (state is AuthLoggedInState) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });

    return const Center(child: CircularProgressIndicator());
  }
}
