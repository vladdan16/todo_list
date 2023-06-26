import 'dart:convert';

import 'package:remote_storage_todos_api/env/env.dart';
import 'package:todo_api/todo_api.dart';
import 'package:http/http.dart' as http;

final class BackendClient {
  final baseUrl = Env.baseUrl;
  final token = Env.token;

  Future<(List<Todo>, int)> getAll() async {
    var url = Uri.parse('$baseUrl/list');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      var revision = json['revision'] as int;
      if ((json['list'] as List).isEmpty) {
        return (<Todo>[], revision);
      }
      var list = json['list'] as List;
      var todos = List.generate(
        list.length,
        (i) => Todo.fromJson(list[i]),
      );

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

    var url = Uri.parse('$baseUrl/list');
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Authorization': token,
        'Content-Type': 'application/json',
        'X-Last-Known-Revision': revision.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'list': jsonList,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      var revision = json['revision'] as int;
      if ((json['list'] as List).isEmpty) {
        return (<Todo>[], revision);
      }
      var newList = json['list'] as List;
      var todos = List.generate(
        newList.length,
        (i) => Todo.fromJson(newList[i]),
      );

      return (todos, revision);
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException();
    } else {
      throw Exception();
    }
  }

  Future<(Todo, int)> getTodo(String id) async {
    var url = Uri.parse('$baseUrl/list/$id');
    var response = await http.get(url, headers: {
      'Authorization': token,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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
    var url = Uri.parse('$baseUrl/list');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': token,
        'Content-Type': 'application/json',
        'X-Last-Known-Revision': revision.toString(),
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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
    var url = Uri.parse('$baseUrl/list/${todo.id}');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<(Todo, int)> deleteTodo(String id, int revision) async {
    var url = Uri.parse('$baseUrl/list/$id');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Authorization': token,
        'X-Last-Known-Revision': revision.toString(),
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      var todo = Todo.fromJson(json['element'] as Map<String, dynamic>);
      var revision = json['revision'] as int;
      return (todo, revision);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else if (response.statusCode == 400) {
      throw BadRequestException(response.body);
    } else {
      throw Exception();
    }
  }
}
