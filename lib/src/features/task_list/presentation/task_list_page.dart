import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_list/src/features/task_list/presentation/task_list_header_delegate.dart';
import 'package:todo_list/src/models/task_list.dart';

import '../../../common_widgets/my_dialogs.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<TaskListModel>().refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: TaskListHeaderDelegate(
                completed: context.watch<TaskListModel>().completed,
                visibility:
                    context.watch<TaskListModel>().filter == TaskFilter.all,
                onChangeVisibility: () {
                  context.read<TaskListModel>().changeVisibility();
                },
              ),
            ),
            const _TaskListBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          NavigationManager.openNewTask(context);
        },
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListBody extends StatelessWidget {
  const _TaskListBody();

  @override
  Widget build(BuildContext context) {
    var todos = context.watch<TaskListModel>().todos;
    return SliverPadding(
      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 80),
      sliver: SliverToBoxAdapter(
        child: ClipRect(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      for (var task in todos)
                        _TaskElement(
                          task: task,
                          isFirst: task == todos.first,
                        ),
                      if (todos.isNotEmpty) const Divider(),
                      ListTile(
                        onTap: () async {
                          NavigationManager.openNewTask(context);
                        },
                        title: Text(
                          'new',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ).tr(),
                        leading: const SizedBox(
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskElement extends StatelessWidget {
  const _TaskElement({required this.task, this.isFirst = false});

  final Todo task;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    var colorHex =
        GetIt.I<FirebaseRemoteConfig>().getString('importance_color');
    final color =
        Color(int.parse(colorHex.substring(1, 7), radix: 16) + 0xFF000000);

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await MyDialogs.showConfirmDialog(
            context: context,
            title: 'confirm_delete',
            description: 'confirm_delete_description',
            onConfirmed: () {
              context.read<TaskListModel>().removeTask(task);
              log('Task ${task.text} has been removed');
            },
          );
        } else {
          context.read<TaskListModel>().toggleDone(task);
          if (context.read<TaskListModel>().filter == TaskFilter.all) {
            return false;
          }
          return true;
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF34C759),
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )
              : null,
        ),
        child: const Row(
          children: <Widget>[
            SizedBox(width: 25),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                )
              : null,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            if (task.importance == Importance.low && !task.done)
              const Icon(Icons.arrow_downward),
            if (task.importance == Importance.important && !task.done)
              Text(
                '!! ',
                style: TextStyle(color: color),
              ),
            Expanded(
              child: Text(
                task.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: task.done ? TextDecoration.lineThrough : null,
                  color: task.done ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: task.deadline != null ? Text(task.getDeadline()!.date) : null,
        leading: Theme(
          data: ThemeData(
            unselectedWidgetColor:
                task.importance == Importance.important ? color : Colors.grey,
            primarySwatch: Colors.green,
          ),
          child: Checkbox(
            value: task.done,
            onChanged: (bool? value) {
              context.read<TaskListModel>().toggleDone(task);
            },
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () async {
            NavigationManager.openTaskById(context, task.id);
          },
        ),
      ),
    );
  }
}
