import 'package:frontend/core/cubits/auth/auth_state.dart';
import 'package:frontend/utils/provider/api_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getPrefs() async {
  return await SharedPreferences.getInstance();
}

class AuthCubit extends Cubit<AuthState> {
  final auth = Api();

  AuthCubit() : super(AuthInitialState()) {
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    final prefs = await getPrefs();
    final bool? userLoggedIn = prefs.getBool('LoggedIn');
    print(userLoggedIn);
    if (userLoggedIn != null && userLoggedIn == true) {
      emit(AuthLoggedInState());
    } else {
      emit(AuthLoggedOutState());
    }
  }

  void login(final String email, final String password) async {
    final prefs = await getPrefs();
    final response =
        await auth.isLoggedIn({"email": email, "password": password});
    if (response['loggedIn']) {
      await prefs.setBool('LoggedIn', true);
      AuthState(userLoggedIn: true);
      emit(AuthLoggedInState());
    } else {
      await prefs.setBool('LoggedIn', false);
      AuthState(userLoggedIn: false);
      emit(AuthLoggedOutState());
    }
  }

  void logout() async {
    final prefs = await getPrefs();
    AuthState(userLoggedIn: false);
    await prefs.setBool('LoggedIn', false);
    emit(AuthLoggedOutState());
  }
}
