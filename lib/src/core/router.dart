import 'package:go_router/go_router.dart';
import 'package:todo_list/src/features/edit_task/presentation/edit_task_page.dart';
import 'package:todo_list/src/features/task_list/presentation/task_list_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const TaskListPage(),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) => EditTaskPage(
          id: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
