import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditTodoScreen extends StatelessWidget {
  final Map<String, dynamic> todo;
  final ApiService apiService = ApiService();

  EditTodoScreen({super.key, required this.todo});

  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo['title'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
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
                await apiService.updateTodo(todo['id'], {'title': titleController.text, 'completed': todo['completed']});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
