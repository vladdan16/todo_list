import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_list/src/features/edit_task/application/task_service.dart';

import '../../../common_widgets/my_dialogs.dart';
import '../../../core/todo.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.task, this.newTask = false});

  final ToDo task;
  final bool newTask;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskService service;
  late TextEditingController titleTextController;
  var logger = Logger();

  @override
  void initState() {
    service = TaskService(widget.task, widget.newTask);
    titleTextController = TextEditingController(text: widget.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  bool res = service.saveTaskText(titleTextController.text);
                  if (res) {
                    logger.i('User tries to save empty task!');
                    MyDialogs.showInfoDialog(
                      context: context,
                      title: 'empty_title',
                      description: 'empty_title_description',
                    );
                  } else {
                    service.saveTask();
                    logger.i('Task ${widget.task.name} has been saved');
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'save'.tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: titleTextController,
                          decoration: InputDecoration(
                            hintText: 'task_description'.tr(),
                            border: InputBorder.none,
                          ),
                          minLines: 4,
                          maxLines: null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'importance',
                            style: TextStyle(fontSize: 16),
                          ).tr(),
                          // subtitle: Text(curTask.importance.name).tr(),
                          DropdownButton<Importance>(
                            value: service.curTask.importance,
                            icon: const SizedBox(),
                            underline: const SizedBox(),
                            items: <DropdownMenuItem<Importance>>[
                              DropdownMenuItem<Importance>(
                                value: Importance.no,
                                child: Text(
                                  Importance.no.name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.8),
                                    fontSize: 15,
                                  ),
                                ).tr(),
                              ),
                              DropdownMenuItem<Importance>(
                                value: Importance.low,
                                child: Text(
                                  Importance.low.name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.8),
                                    fontSize: 15,
                                  ),
                                ).tr(),
                              ),
                              DropdownMenuItem<Importance>(
                                value: Importance.high,
                                child: Row(
                                  children: <Widget>[
                                    const Text('!! ',
                                        style: TextStyle(color: Colors.red)),
                                    Text(
                                      Importance.high.name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 15,
                                      ),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (Importance? value) {
                              logger.i(
                                'User chose ${value?.name} importance for task ${service.curTask.name}',
                              );
                              setState(() {
                                service.curTask.importance =
                                    value ?? service.curTask.importance;
                                // logger.i(value?.name);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  ${'deadline'.tr()}'),
                          if (service.curTask.deadline != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  var currentDate = DateTime.now();
                                  logger.i('Show Date Picker to user');
                                  showDatePicker(
                                    context: context,
                                    initialDate: currentDate.add(
                                      const Duration(days: 1),
                                    ),
                                    firstDate: currentDate,
                                    lastDate: DateTime(2030),
                                  ).then((value) {
                                    if (value != null) {
                                      service.curTask.deadline = value;
                                    }
                                    setState(() {});
                                  });
                                },
                                child: Text(service.curTask.deadline?.date ?? ''),
                              ),
                            ),
                        ],
                      ),
                      value: service.curTask.hasDeadline,
                      onChanged: (bool value) {
                        service.curTask.hasDeadline = value;
                        var currentDate = DateTime.now();
                        if (value) {
                          logger.i('Show Date Picker to user');
                          showDatePicker(
                            context: context,
                            initialDate: currentDate.add(
                              const Duration(days: 1),
                            ),
                            firstDate: currentDate,
                            lastDate: DateTime(2030),
                          ).then((value) {
                            service.curTask.deadline = value;
                            if (value == null) {
                              service.curTask.hasDeadline = false;
                            }
                            setState(() {});
                          });
                        } else {
                          service.curTask.deadline = null;
                          service.curTask.hasDeadline = false;
                        }
                        setState(() {});
                      },
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: widget.newTask
                          ? null
                          : () {
                              logger.i('Ask user a confirmation to delete');
                              MyDialogs.showConfirmDialog(
                                context: context,
                                title: 'confirm_delete',
                                description: 'confirm_delete_description',
                                onConfirmed: () {
                                  service.removeTask();
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                              );
                            },
                      style: ButtonStyle(
                        foregroundColor: widget.newTask
                            ? null
                            : MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          const SizedBox(width: 5),
                          Text(
                            'delete',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                            ),
                          ).tr(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
