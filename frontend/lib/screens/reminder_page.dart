import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/blocs/add_task/add_task_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatelessWidget {
  final Box<List<String>> localhost = Hive.box<List<String>>('localhost');
  ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task List")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          return Text(
                            DateFormat.yMMMMd().format(state.date),
                            style: const TextStyle(fontSize: 14),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Today',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          final String formattedDateTime =
                              DateFormat('yyyy-MM-dd').format(state.date);
                          context.go('/add-task/$formattedDateTime');
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50)),
                        child: const Text('+ Add Task'),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  return DatePicker(
                    DateTime.now(),
                    initialSelectedDate: state.date,
                    selectionColor: Colors.lightBlue,
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      state.date = date;
                      BlocProvider.of<TaskBloc>(context).add(AddTaskEvent());
                    },
                  );
                },
              ),
            ),
            BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                return Expanded(
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: localhost.listenable(
                          keys: [DateFormat('yyyy-MM-dd').format(state.date)]),
                      builder: (context, Box<List<String>> crudBox, child) =>
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
