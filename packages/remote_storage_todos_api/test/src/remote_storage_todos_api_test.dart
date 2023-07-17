import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:todo_api/todo_api.dart';

@GenerateNiceMocks([MockSpec<BackendClient>()])
import 'remote_storage_todos_api_test.mocks.dart';

void main() {
  late RemoteStorageTodosApi api;
  late BackendClient client;

  setUp(() {
    client = MockBackendClient();
    api = RemoteStorageTodosApi(client);
  });

  group('saveTodo test group', () {
    test('saveTodo tries to save new task', () async {
      var id = '1';
      var todo = Todo(
        id: id,
        text: 'task1',
        lastUpdatedBy: 'test_device',
        createdAt: DateTime.now(),
        changedAt: DateTime.now(),
      );
      var revision = 1;

      provideDummy(todo);
      when(client.getTodo(id)).thenThrow(NotFoundException());
      when(client.insert(todo, revision))
          .thenAnswer((_) async => (todo, revision + 1));

      var newRevision = await api.saveTodo(todo, revision);

      expect(newRevision, revision + 1);
    });

    test('saveTodo tries to save existing task', () async {
      var id = '1';
      var todo = Todo(
        id: id,
        text: 'task1',
        lastUpdatedBy: 'test_device',
        createdAt: DateTime.now(),
        changedAt: DateTime.now(),
      );
      var newTodo = Todo(
        id: '2',
        text: 'task2',
        lastUpdatedBy: 'test_device',
        createdAt: DateTime.now(),
        changedAt: DateTime.now(),
      );
      var revision = 1;

      provideDummy(todo);
      when(client.getTodo(id)).thenAnswer((_) async => (todo, revision));
      when(client.updateTodo(newTodo, revision))
          .thenAnswer((_) async => (newTodo, revision + 1));

      var newRevision = await api.saveTodo(newTodo, revision);

      expect(newRevision, revision + 1);
    });
  });

  tearDown(() {
    clearInteractions(client);
  });
}
