import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/datetime_extension.dart';
import 'package:todo_list/src/features/edit_task/presentation/task_page.dart';
import 'package:todo_list/src/features/task_list/bloc/task_list_bloc.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_repository/todo_repository.dart';

import '../../../common_widgets/my_dialogs.dart';
import 'task_list_header_delegate.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc(
        repository: context.read<TodoRepository>(),
      )..add(const TaskListSubscriptionRequested()),
      child: const TaskListView(),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocBuilder<TaskListBloc, TaskListState>(
            builder: (context, state) {
              if (state.status == TaskListStatus.success) {
                return SliverPersistentHeader(
                  delegate: TaskListHeaderDelegate(
                    completed: state.filteredTodos.length,
                    visibility: state.filter == TaskFilter.all,
                    onChangeVisibility: () {
                      context.read<TaskListBloc>().add(
                          TaskListVisibilityChanged(
                              state.filter == TaskFilter.all
                                  ? TaskFilter.active
                                  : TaskFilter.all));
                    },
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          BlocBuilder<TaskListBloc, TaskListState>(
            builder: (context, state) {
              if (state.status == TaskListStatus.loading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state.status == TaskListStatus.failure) {
                return SliverToBoxAdapter(
                  child: Center(child: const Text('something_went_wrong').tr()),
                );
              } else {
                return const _TaskListContent();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final _ = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // TODO: go to Task page
              //return TaskPage(task: ToDo(), newTask: true);
              throw UnimplementedError();
            }),
          );
        },
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListContent extends StatelessWidget {
  const _TaskListContent();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 80),
      sliver: SliverToBoxAdapter(
        child: ClipRect(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: BlocBuilder<TaskListBloc, TaskListState>(
                builder: (context, state) {
                  return Column(
                    children: <Widget>[
                      for (var task in state.filteredTodos)
                        Dismissible(
                          key: UniqueKey(),
                          // onDismissed: (direction) {
                          // },
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await MyDialogs.showConfirmDialog(
                                context: context,
                                title: 'confirm_delete',
                                description: 'confirm_delete_description',
                                onConfirmed: () {
                                  context
                                      .read<TaskListBloc>()
                                      .add(TaskListDeletionRequested(task));
                                },
                              );
                            } else {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListTodoCompletionToggled(
                                    todo: task,
                                    isCompleted: !task.done,
                                  ));
                              if (state.filter == TaskFilter.all) {
                                return false;
                              }
                              return true;
                            }
                          },
                          background: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF34C759),
                              borderRadius: state.filteredTodos.first == task
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
                              color: const Color(0xFFFF3B30),
                              borderRadius: state.filteredTodos.first == task
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
                                if (task.importance == Importance.low &&
                                    !task.done)
                                  const Icon(Icons.arrow_downward),
                                if (task.importance == Importance.important &&
                                    !task.done)
                                  const Text(
                                    '!! ',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                Expanded(
                                  child: Text(
                                    task.text,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      decoration: task.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: task.deadline != null
                                ? Text(task.deadline!.date)
                                : null,
                            leading: Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                    task.importance == Importance.important
                                        ? Colors.red
                                        : Colors.grey,
                                primarySwatch: Colors.green,
                              ),
                              child: Checkbox(
                                value: task.done,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    context
                                        .read<TaskListBloc>()
                                        .add(TaskListTodoCompletionToggled(
                                      todo: task,
                                      isCompleted: value,
                                    ));
                                  }
                                  // setState(() {
                                  //   service.modifyTask(task, done: value);
                                  // });
                                },
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () async {
                                final _ = await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return TaskPage(task: task);
                                  }),
                                );
                              },
                            ),
                          ),
                        ),
                      if (state.filteredTodos.isNotEmpty) const Divider(),
                      ListTile(
                        onTap: () async {
                          final _ = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // TODO: open Task page
                              //return TaskPage(task: ToDo(), newTask: true);
                              throw UnimplementedError();
                            }),
                          );
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
