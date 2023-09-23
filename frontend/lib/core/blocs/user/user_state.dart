abstract class UserState {}

class UserDataInitalState extends UserState {}

class UserDataLoadingState extends UserState {}

class UserDataLoadedState extends UserState {
  final dynamic data;
  UserDataLoadedState({required this.data});
}

class UserDataErrorState extends UserState {
  final String errorMessage;
  UserDataErrorState({required this.errorMessage});
}
