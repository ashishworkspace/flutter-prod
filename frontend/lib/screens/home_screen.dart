import 'package:frontend/core/cubits/auth/auth_cubit.dart';
import 'package:frontend/core/cubits/auth/auth_state.dart';
// import 'package:frontend/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

final keyController = TextEditingController();

final valueController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<String> crudBox;
  @override
  void initState() {
    crudBox = Hive.box<String>('CRUD');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        actions: [
          Center(
              child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOutState) {
                context.go('/login');
              }
            },
            builder: (context, state) {
              return TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).logout();
                },
                child: const Text('Logout'),
              );
            },
          ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: ValueListenableBuilder(
                        valueListenable: crudBox.listenable(),
                        builder: (context, Box<String> crudBox, child) =>
                            ListView.separated(
                              itemBuilder: (context, index) {
                                final key = crudBox.keys.toList()[index];
                                final value = crudBox.getAt(index);

                                return ListTile(
                                  title: Text('Key: $key'),
                                  subtitle: Text('Value: $value'),
                                );
                              },
                              separatorBuilder: (_, i) => const Divider(),
                              itemCount: crudBox.keys.length,
                            )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => Dialog(
                                child: SizedBox(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.all(34.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: keyController,
                                          decoration: const InputDecoration(
                                              label: Text("Key")),
                                        ),
                                        TextField(
                                          controller: valueController,
                                          decoration: const InputDecoration(
                                              label: Text("value")),
                                        ),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        ElevatedButton(
                                            onPressed: () {
                                              final key = keyController.text;
                                              final value =
                                                  valueController.text;
                                              crudBox.put(key, value);
                                              keyController.clear();
                                              valueController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Submit"))
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    child: const Text("Create")),
                ElevatedButton(onPressed: () {}, child: const Text("Update")),
                ElevatedButton(onPressed: () {}, child: const Text("Delete")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
