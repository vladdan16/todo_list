import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_repository/src/todo_repository.dart';

@GenerateNiceMocks([MockSpec<TodoApi>(), MockSpec<Connectivity>()])
import 'todo_repository_test.mocks.dart';

void main() {
  late TodoApi localApi;
  late TodoApi remoteApi;
  late Connectivity connectivity;
  late TodoRepository repository;
  late StreamController<ConnectivityResult> controller;

  var initialList = [
    Todo(
      id: '1',
      text: 'task1',
      lastUpdatedBy: 'test_device',
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
    )
  ];
  var initialRevision = 1;

  setUp(() async {
    localApi = MockTodoApi();
    remoteApi = MockTodoApi();
    connectivity = MockConnectivity();
    controller = StreamController<ConnectivityResult>();

    when(localApi.getTodoList())
        .thenAnswer((_) async => (initialList, initialRevision));
    when(remoteApi.patchList(initialList, initialRevision))
        .thenAnswer((_) async => (initialList, initialRevision));
    when(localApi.patchList(initialList, initialRevision))
        .thenAnswer((_) async => (initialList, initialRevision));
    when(connectivity.onConnectivityChanged)
        .thenAnswer((_) => controller.stream);

    repository = await TodoRepository.create(
      todoApiLocal: localApi,
      todoApiRemote: remoteApi,
      connectivity: connectivity,
    );
  });

  test('getTodos returns current list', () {
    var list = repository.getTodos();

    expect(list, initialList);
  });

  test('getTodo returns todo from initial list', () {
    var todo = repository.getTodo('1');

    expect(todo, initialList[0]);
  });

  group('saveTodo group', () {
    test('saveTodo tries to save existing todo', () async {
      var modifiedTodo = initialList[0].copyWith(text: 'modified task1');

      when(remoteApi.saveTodo(modifiedTodo, initialRevision))
          .thenAnswer((_) async => initialRevision + 1);
      when(localApi.saveTodo(modifiedTodo, initialRevision + 1))
          .thenAnswer((_) async => initialRevision + 1);

      await repository.saveTodo(modifiedTodo);

      expect(repository.getTodo('1'), modifiedTodo);
    });

    test('saveTodo tries to save new todo', () async {
      var newTodo = Todo(
        id: '2',
        text: 'task2',
        lastUpdatedBy: 'test_device',
        createdAt: DateTime.now(),
        changedAt: DateTime.now(),
      );

      when(remoteApi.saveTodo(newTodo, initialRevision))
          .thenAnswer((_) async => initialRevision + 1);
      when(localApi.saveTodo(newTodo, initialRevision + 1))
          .thenAnswer((_) async => initialRevision + 1);

      await repository.saveTodo(newTodo);

      expect(repository.getTodo('2'), newTodo);
    });
  });

  test('deleteTodo tries to delete existing todo', () async {
    provideDummy(initialList[0]);
    when(remoteApi.deleteTodo('1', initialRevision))
        .thenAnswer((_) async => (initialList[0], initialRevision + 1));
    when(localApi.deleteTodo('1', initialRevision + 1))
        .thenAnswer((_) async => (initialList[0], initialRevision + 1));

    await repository.deleteTodo('1');

    expect(repository.getTodos().length, 0);
  });

  tearDown(() {
    clearInteractions(localApi);
    clearInteractions(remoteApi);
    clearInteractions(connectivity);
  });
}
