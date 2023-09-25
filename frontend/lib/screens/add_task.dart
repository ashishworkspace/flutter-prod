import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

final Box<List<String>> localhost = Hive.box<List<String>>('localhost');

final valueController = TextEditingController();

void addToHiveBox(final String? key) {
  final String value = valueController.text;

  if (value.isNotEmpty) {
    List<String> list = localhost.get(key) ?? [];
    list.add(value);
    localhost.put(key, list);
  }
}

class AddTask extends StatelessWidget {
  final String? date;
  const AddTask({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddTask'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  label: Text("Value"), border: OutlineInputBorder()),
              controller: valueController,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                addToHiveBox(date);
                valueController.clear();
                print(date);
                print(localhost.get(date));
                context.go('/reminder');
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
