import 'package:flutter/material.dart';
import 'package:main_uts/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final fetchedTodos = await apiService.fetchTodos();
    todos = fetchedTodos.map((todo) {
      return {
        'id': int.tryParse(todo['id'].toString()) ?? todo['id'],
        'title': todo['title'],
        'completed': todo['completed'],
      };
    }).toList();
    setState(() {});
  }

  void _showAddDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await apiService.addTodo({
                    'title': titleController.text,
                    'completed': false,
                    'id': (todos.length + 1).toString(),
                  });
                  if (mounted) {
                    Navigator.of(context).pop();
                    _fetchTodos();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> todo) {
    TextEditingController titleController = TextEditingController(text: todo['title']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await apiService.updateTodo(todo['id'], {
                  'title': titleController.text,
                  'completed': todo['completed'],
                });
                if (mounted) {
                  Navigator.of(context).pop();
                  _fetchTodos();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await apiService.deleteTodo(id);
                if (mounted) {
                  Navigator.of(context).pop();
                  _fetchTodos();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo['title']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(context, todo);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(context, todo['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
