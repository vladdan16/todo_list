import 'dart:convert';

import 'package:remote_storage_todos_api/env/env.dart';
import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:todo_api/todo_api.dart';
import 'package:http/http.dart' as http;

final class BackendClient {
  final baseUrl = Env.baseUrl;
  final token = Env.token;

  Future<(List<Todo>, int)> getAll() async {
    var url = Uri.https(baseUrl);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Authorisation': token,
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var list = json['list'] as List<Map<String, dynamic>>;
      var todos = List.generate(
        list.length,
        (i) => Todo.fromJson(list[i]),
      );

      var revision = json['revision'] as int;

      return (todos, revision);
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException();
    } else {
      throw Exception();
    }
  }

  Future<(List<Todo>, int)> updateAll(List<Todo> list, int revision) async {
    List<Map<String, dynamic>> jsonList = List.generate(
      list.length,
      (i) => list[i].toJson(),
    );

    var url = Uri.https(baseUrl);
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Authorization': token,
        'X-Last-Known-Revision': revision.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'list': jsonList,
      }),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var newList = json['list'] as List<Map<String, dynamic>>;
      var todos = List.generate(
        newList.length,
        (i) => Todo.fromJson(newList[i]),
      );

      var revision = json['revision'] as int;

      return (todos, revision);
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException();
    } else {
      throw Exception();
    }
  }

  Future<(Todo, int)> getTodo(String id) async {
    var url = Uri.https(baseUrl, id);
    var response = await http.get(url, headers: {
      'Authorization': token,
    });

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var todo = Todo.fromJson(json['element'] as Map<String, dynamic>);
      var revision = json['revision'] as int;
      return (todo, revision);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw Exception();
    }
  }

  Future<(Todo, int)> insert(Todo todo, int revision) async {
    Map<String, dynamic> body = {
      'element': todo.toJson(),
    };
    var url = Uri.https(baseUrl);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': token,
        'X-Last-Known-Revision': revision.toString(),
      },
      body: jsonEncode(body),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var todo = Todo.fromJson(json['element'] as Map<String, dynamic>);
      var revision = json['revision'] as int;
      return (todo, revision);
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else {
      throw Exception();
    }
  }

  Future<(Todo, int)> updateTodo(Todo todo) async {
    Map<String, dynamic> body = {
      'element': todo.toJson(),
    };
    var url = Uri.https(baseUrl, todo.id);
    var response = await http.put(
      url,
      headers: <String, String>{
        'Authorization': token,
      },
      body: jsonEncode(body),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var todo = Todo.fromJson(json['element'] as Map<String, dynamic>);
      var revision = json['revision'] as int;
      return (todo, revision);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else {
      throw Exception();
    }
  }

  Future<(Todo, int)> deleteTodo(Todo todo) async {
    var url = Uri.https(baseUrl, todo.id);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Authorization': token,
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var todo = Todo.fromJson(json['element'] as Map<String, dynamic>);
      var revision = json['revision'] as int;
      return (todo, revision);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else {
      throw Exception();
    }
  }
}
