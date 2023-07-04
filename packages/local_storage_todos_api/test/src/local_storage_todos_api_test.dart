import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:todo_api/todo_api.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'local_storage_todos_api_test.mocks.dart';

void main() {
  late LocalStorageTodosApi api;
  late SharedPreferences prefs;

  setUp(() {
    prefs = MockSharedPreferences();
    api = LocalStorageTodosApi(prefs);
  });

  group('getTodoList', () {
    test('getTodoList returns empty list when SharedPreferences is empty',
        () async {
      when(prefs.getString('todos')).thenReturn(null);
      when(prefs.getInt('revision')).thenReturn(null);

      var (todos, revision) = await api.getTodoList();

      expect(todos, []);
      expect(revision, 0);
    });

    test('getTodoList returns todos when SharedPreferences contains todos',
        () async {
      when(prefs.getString('todos')).thenReturn(
          '[{"created_at": 1688302736131,"text": "test","importance": "basic","done": true,"changed_at": 1688302736131,"last_updated_by": "device_id","id": "some_id"}]');
      when(prefs.getInt('revision')).thenReturn(1);

      var (todos, revision) = await api.getTodoList();

      expect(todos.length, 1);
      expect(todos[0].id, "some_id");
      expect(todos[0].done, true);
      expect(todos[0].text, "test");
      expect(todos[0].importance, Importance.basic);
      expect(todos[0].lastUpdatedBy, "device_id");

      expect(revision, 1);
    });
  });

  test('getTodo returns todo when SharedPreferences contains todo', () async {
    var id = "some_id";

    when(prefs.getString('todos')).thenReturn(
        '[{"created_at": 1688302736131,"text": "test","importance": "basic","done": true,"changed_at": 1688302736131,"last_updated_by": "device_id","id": "$id"}]');
    when(prefs.getInt('revision')).thenReturn(1);

    var (todo, revision) = await api.getTodo(id);

    expect(todo.id, id);
    expect(todo.done, true);
    expect(todo.text, "test");
    expect(todo.importance, Importance.basic);
    expect(todo.lastUpdatedBy, "device_id");

    expect(revision, 1);
  });

  tearDown(() {
    clearInteractions(prefs);
  });
}
