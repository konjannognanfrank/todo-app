import 'dart:convert';

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoController {
  final TodoService _todoService = TodoService();

  Future<Todo?> getAllTodos({bool status = false}) async {
    Todo? _todo;
    await _todoService.getAllTodoRequest(status).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        //success
        _todo = Todo.fromMap(json.decode(response.body));
      } else {
        //error
        _todo = null;
      }
    }).catchError((onError) {
      _todo = null;
    });
    return _todo;
  }

  Future<bool> createTodo(
      {required String title,
      required String body,
      required String endDate}) async {
    bool isSuccessful = false;
    await _todoService
        .createTodoRequest(
            title: title, body: body, endDate: endDate)
        .then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 201) {
        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    }).catchError((onError) {
      isSuccessful = false;
    });
    return isSuccessful;
  }

  //delete a todo
  Future<bool> deleteTodo(String id) async {
    bool isDeleted = false;

    await _todoService.deleteTodoRequest(id).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        //delete success
        isDeleted = true;
      } else {
        // delete error
        isDeleted = false;
      }
    }).catchError((onError) {
      isDeleted = false;
    });

    return isDeleted;
  }

  //update todo status to true
  Future<bool> updateTodoStatus(
      {required String id, required bool status}) async {
    bool isUpdated = false;
    await _todoService
        .updateTodoRequest(status: status, id: id)
        .then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        isUpdated = true;
      } else {
        isUpdated = false;
      }
    }).catchError((onError) {
      isUpdated = false;
    });
    return isUpdated;
  }
}
