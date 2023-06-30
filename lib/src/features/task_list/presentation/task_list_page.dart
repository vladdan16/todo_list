import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_list/src/features/edit_task/presentation/edit_task_page.dart';
import 'package:todo_list/src/core/task_list_service.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_list/src/features/task_list/presentation/task_list_header_delegate.dart';
import 'package:todo_repository/todo_repository.dart';

import '../../../common_widgets/my_dialogs.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key, required this.repository});

  final TodoRepository repository;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskListService service;

  @override
  void initState() {
    service = TaskListService(widget.repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: TaskListHeaderDelegate(
                completed: service.completed,
                visibility: service.filter == TaskFilter.all,
                onChangeVisibility: () {
                  service.changeVisibility();
                  setState(() {});
                }),
          ),
          SliverPadding(
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
                    child: Column(
                      children: <Widget>[
                        for (var task in service.filteredTodos)
                          Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              setState(() {});
                            },
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                return await MyDialogs.showConfirmDialog(
                                  context: context,
                                  title: 'confirm_delete',
                                  description: 'confirm_delete_description',
                                  onConfirmed: () {
                                    service.removeTask(task);
                                    log('Task ${task.text} has been removed');
                                  },
                                );
                              } else {
                                service.saveTask(task.copyWith(
                                  done: !task.done,
                                ));
                                if (service.filter == TaskFilter.all) {
                                  setState(() {});
                                  return false;
                                }
                                return true;
                              }
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF34C759),
                                borderRadius:
                                    service.filteredTodos.first == task
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
                                borderRadius:
                                    service.filteredTodos.first == task
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
                                    setState(() {
                                      service.saveTask(task.copyWith(
                                        done: value,
                                      ));
                                    });
                                  },
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () async {
                                  final _ = await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return EditTaskPage(
                                        task: task,
                                        newTask: false,
                                        service: service,
                                      );
                                    }),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        if (service.filteredTodos.isNotEmpty) const Divider(),
                        ListTile(
                          onTap: () async {
                            final _ = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return EditTaskPage(
                                  task: Todo(
                                    text: '',
                                    lastUpdatedBy: DeviceId.deviceId!,
                                  ),
                                  newTask: true,
                                  service: service,
                                );
                              }),
                            );
                            setState(() {});
                          },
                          title: Text(
                            'new',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final _ = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return EditTaskPage(
                task: Todo(
                  text: '',
                  lastUpdatedBy: DeviceId.deviceId!,
                ),
                newTask: true,
                service: service,
              );
            }),
          );
          setState(() {});
        },
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
