class AuthState {
  final bool? userLoggedIn;
  AuthState({this.userLoggedIn});
}

class AuthInitialState extends AuthState {}

class AuthLoggedInState extends AuthState {}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
