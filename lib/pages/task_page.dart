import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_list/core/task_database.dart';
import 'package:todo_list/widgets/my_dialogs.dart';

import '../core/todo.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.task, this.newTask = false});

  final ToDo task;
  final bool newTask;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TextEditingController titleTextController;
  //late TextEditingController descriptionTextController;
  late ToDo curTask;
  var logger = Logger();
  final database = TaskDatabase();

  void _saveTask() {
    curTask.name = titleTextController.text;
    //curTask.description = descriptionTextController.text;
    if (!widget.newTask) database.modifyTaskFromToDo(widget.task, curTask);
  }

  @override
  void initState() {
    titleTextController = TextEditingController(text: widget.task.name);
    //descriptionTextController = TextEditingController(
    //  text: widget.task.description,
    //);
    if (widget.newTask) {
      curTask = widget.task;
    } else {
      curTask = ToDo.copyWith(widget.task);
    }
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
                  _saveTask();
                  if (widget.task.name == '') {
                    MyDialogs.showInfoDialog(
                      context: context,
                      title: 'empty_title',
                      description: 'empty_title_description',
                    );
                  } else {
                    database.saveTask(widget.task);
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
                          minLines: 3,
                          maxLines: null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('importance').tr(),
                      // subtitle: Text(curTask.importance.name).tr(),
                      subtitle: DropdownButton<Importance>(
                        value: curTask.importance,
                        icon: null,
                        items: <DropdownMenuItem<Importance>>[
                          DropdownMenuItem<Importance>(
                            value: Importance.no,
                            child: Text(Importance.no.name).tr(),
                          ),
                          DropdownMenuItem<Importance>(
                            value: Importance.low,
                            child: Text(Importance.low.name).tr(),
                          ),
                          DropdownMenuItem<Importance>(
                            value: Importance.high,
                            child: Row(
                              children: <Widget>[
                                const Text('!! ',
                                    style: TextStyle(color: Colors.red)),
                                Text(Importance.high.name).tr(),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (Importance? value) {
                          setState(() {
                            curTask.importance = value ?? curTask.importance;
                            // logger.i(value?.name);
                          });
                        },
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('deadline').tr(),
                      subtitle: curTask.deadline != null
                          ? Text(curTask.deadline?.date ?? '')
                          : null,
                      value: curTask.hasDeadline,
                      onChanged: (bool value) {
                        curTask.hasDeadline = value;
                        var currentDate = DateTime.now();
                        if (value) {
                          showDatePicker(
                            context: context,
                            initialDate: currentDate.add(
                              const Duration(days: 1),
                            ),
                            firstDate: currentDate,
                            lastDate: DateTime(2030),
                          ).then((value) {
                            curTask.deadline = value;
                            if (value == null) {
                              curTask.hasDeadline = false;
                            }
                            setState(() {});
                          });
                        } else {
                          curTask.deadline = null;
                          curTask.hasDeadline = false;
                        }
                      },
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: widget.newTask
                          ? null
                          : () {
                              MyDialogs.showConfirmDialog(
                                context: context,
                                title: 'confirm_delete',
                                description: 'confirm_delete_description',
                                onConfirmed: () {
                                  database.removeTask(widget.task);
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
