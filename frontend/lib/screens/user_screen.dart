import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/blocs/user/user_bloc.dart';
import 'package:frontend/core/blocs/user/user_event.dart';
import 'package:frontend/core/blocs/user/user_state.dart';
import 'package:frontend/utils/provider/api_provider.dart';

Api auth = Api();

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserDataInitalState) {
                return const Text("Click Below to Fetch UserId");
              } else if (state is UserDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserDataLoadedState) {
                return Text(state.data.toString());
              } else if (state is UserDataErrorState) {
                return Text("Error: ${state.errorMessage.toString()}");
              } else {
                return const Text("Something went Wrong!");
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                BlocProvider.of<UserBloc>(context)
                    .add(OnButtonClickToFetchUserId());
              },
              child: const Text("Fetch UserId"))
        ]),
      ),
    );
  }
}
