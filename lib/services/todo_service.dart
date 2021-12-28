import 'dart:convert';

import 'package:http/http.dart';

class TodoService {
  Future<Response> getAllTodoRequest(bool status) async {
    return await get(
        Uri.parse("https://secure-headland-73578.herokuapp.com/todos"));
  }

  Future<Response> getTodoByIdRequest(String id) async {
    return await get(
        Uri.parse("https://secure-headland-73578.herokuapp.com/todos/$id"));
  }

//create a new todo
  Future<Response> createTodoRequest(
      {required String title,
      required String body,
      required String endDate}) async {
    Map<String, String> body1 = {
      "title": title,
      "body": body,
      "endDate": endDate
    };

    Map<String, String> header = {'Content-Type': 'application/json'};

    return await post(
        Uri.parse("https://secure-headland-73578.herokuapp.com/todos"),
        body: jsonEncode(body1),
        headers: header);
  }

  Future<Response> updateTodoRequest(
      {required bool status, required String id}) async {
    Map<String, bool> body = {"status": status};

    Map<String, String> header = {'Content-Type': 'application/json'};

    return await patch(
        Uri.parse("https://secure-headland-73578.herokuapp.com/todos/$id"),
        body: jsonEncode(body),
        headers: header);
  }

  //delete a todo
  Future<Response> deleteTodoRequest(String id) async {
    return await delete(
        Uri.parse("https://secure-headland-73578.herokuapp.com/todos/$id"));
  }
}
