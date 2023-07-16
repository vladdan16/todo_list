import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/features/edit_task/presentation/edit_task_page.dart';
import 'package:todo_list/src/features/task_list/presentation/task_list_page.dart';
import 'package:todo_list/src/models/edit_task.dart';
import 'package:todo_list/src/models/task_list.dart';

class AppRouter {
  static final router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const TaskListPage(),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) {
            var todo = context
                .read<TaskListModel>()
                .getTodo(state.pathParameters['id']!);
            return EditTaskModel(todo);
          },
          child: const EditTaskPage(),
        ),
      ),
    ],
  );
}
