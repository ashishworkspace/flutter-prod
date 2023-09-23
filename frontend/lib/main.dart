import 'package:flutter/foundation.dart';
import 'package:frontend/core/blocs/user/user_bloc.dart';
import 'package:frontend/core/cubits/auth/auth_cubit.dart';
import 'package:frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Hive.initFlutter();
  } else {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  await Hive.openBox<String>('CRUD');

  setPathUrlStrategy();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthCubit()),
      BlocProvider(create: (context) => UserBloc())
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ),
  ));
}
