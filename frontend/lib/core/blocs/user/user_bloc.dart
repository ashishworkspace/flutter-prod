import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/blocs/user/user_event.dart';
import 'package:frontend/core/blocs/user/user_state.dart';
import 'package:frontend/utils/provider/api_provider.dart';

Api auth = Api();

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserDataInitalState()) {
    on<OnButtonClickToFetchUserId>((event, emit) async {
      emit(UserDataLoadingState());
      try {
        var resp = await auth.makeRequest('/user');
        if (resp.statusCode == 200) {
          emit(UserDataLoadedState(data: resp));
        } else {
          emit(UserDataErrorState(errorMessage: 'Failed To Fetch the data!'));
        }
      } on DioException catch (ex) {
        emit(UserDataErrorState(errorMessage: ex.response.toString()));
      }
    });
  }
}
