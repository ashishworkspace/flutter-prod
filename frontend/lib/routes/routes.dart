import 'package:frontend/screens/add_task.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/reminder_page.dart';
import 'package:frontend/screens/user_screen.dart';
import 'package:frontend/screens/wrapper.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const Wrapper();
    },
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) {
      return const LoginScreen();
    },
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) {
      return const HomeScreen();
    },
  ),
  GoRoute(
    path: '/user',
    builder: (context, state) {
      return const UserScreen();
    },
  ),
  GoRoute(
    path: '/reminder',
    builder: (context, state) {
      return ReminderPage();
    },
  ),
  GoRoute(
    path: '/add-task/:currentDate',
    builder: (context, state) {
      return AddTask(
        date: state.pathParameters['currentDate'],
      );
    },
  ),
]);
