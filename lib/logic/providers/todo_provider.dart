import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];
  bool _isLoading = false;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;

  TodoProvider() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _todos = await DatabaseHelper.instance.readAllTodos();
    } catch (e) {
      debugPrint("Error fetching todos: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title, DateTime date) async {
    final newTodo = TodoModel(
      title: title,
      date: date,
      isCompleted: false,
    );
    await DatabaseHelper.instance.createTodo(newTodo);
    await fetchTodos();
  }

  Future<void> toggleTodoStatus(TodoModel todo) async {
    final updatedTodo = TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: !todo.isCompleted,
      date: todo.date,
    );
    await DatabaseHelper.instance.updateTodo(updatedTodo);
    await fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    await fetchTodos();
  }
}
