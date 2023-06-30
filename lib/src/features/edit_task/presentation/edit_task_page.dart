import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/task_list_service.dart';

import '../../../common_widgets/my_dialogs.dart';
import '../../../core/datetime_extension.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({
    super.key,
    required this.task,
    this.newTask = false,
    required this.service,
  });

  final Todo task;
  final bool newTask;
  final TaskListService service;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TaskListService service;
  late TextEditingController titleTextController;
  late Todo task;
  late bool hasDeadline;

  @override
  void initState() {
    service = widget.service;
    task = widget.task;
    hasDeadline = task.deadline != null;
    titleTextController = TextEditingController(text: widget.task.text);
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
                  bool res = titleTextController.text == '';
                  if (res) {
                    log('User tries to save empty task!');
                    MyDialogs.showInfoDialog(
                      context: context,
                      title: 'empty_title',
                      description: 'empty_title_description',
                    );
                  } else {
                    task = task.copyWith(text: titleTextController.text);
                    service.saveTask(task);
                    log('Task ${widget.task.text} has been saved');
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
                            value: task.importance,
                            icon: const SizedBox(),
                            underline: const SizedBox(),
                            items: <DropdownMenuItem<Importance>>[
                              DropdownMenuItem<Importance>(
                                value: Importance.basic,
                                child: Text(
                                  Importance.basic.name,
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
                                value: Importance.important,
                                child: Row(
                                  children: <Widget>[
                                    const Text('!! ',
                                        style: TextStyle(color: Colors.red)),
                                    Text(
                                      Importance.important.name,
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
                              log(
                                'User chose ${value?.name} importance for task ${task.text}',
                              );
                              setState(() {
                                task = task.copyWith(
                                  importance: value ?? task.importance,
                                );
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
                          if (task.deadline != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  var currentDate = DateTime.now();
                                  log('Show Date Picker to user');
                                  showDatePicker(
                                    context: context,
                                    initialDate: currentDate.add(
                                      const Duration(days: 1),
                                    ),
                                    firstDate: currentDate,
                                    lastDate: DateTime(2030),
                                  ).then((value) {
                                    if (value != null) {
                                      task = task.copyWith(deadline: value);
                                    }
                                    setState(() {});
                                  });
                                },
                                child: Text(
                                  task.deadline?.date ?? '',
                                ),
                              ),
                            ),
                        ],
                      ),
                      value: hasDeadline,
                      onChanged: (bool value) {
                        hasDeadline = value;
                        var currentDate = DateTime.now();
                        if (value) {
                          log('Show Date Picker to user');
                          showDatePicker(
                            context: context,
                            initialDate: currentDate.add(
                              const Duration(days: 1),
                            ),
                            firstDate: currentDate,
                            lastDate: DateTime(2030),
                          ).then((value) {
                            task = task.copyWith(deadline: value);
                            if (value == null) {
                              hasDeadline = false;
                            }
                            setState(() {});
                          });
                        } else {
                          task = task.copyWith(deadline: null);
                          hasDeadline = false;
                        }
                        setState(() {});
                      },
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: widget.newTask
                          ? null
                          : () {
                              log('Ask user a confirmation to delete');
                              MyDialogs.showConfirmDialog(
                                context: context,
                                title: 'confirm_delete',
                                description: 'confirm_delete_description',
                                onConfirmed: () {
                                  service.removeTask(task);
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
