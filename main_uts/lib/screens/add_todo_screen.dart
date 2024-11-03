import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTodoScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();

  AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await apiService.addTodo({'title': titleController.text, 'completed': false});
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
