import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_list/core/task_database.dart';
import 'package:todo_list/utils/my_dialogs.dart';

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
  late TextEditingController descriptionTextController;
  var logger = Logger();
  final database = TaskDatabase();

  void _saveTask() {
    widget.task.name = titleTextController.text;
    widget.task.description = descriptionTextController.text;
  }

  @override
  void initState() {
    titleTextController = TextEditingController(text: widget.task.name);
    descriptionTextController = TextEditingController(
      text: widget.task.description,
    );
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
                    database.addTask(widget.task);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: titleTextController,
                        decoration: InputDecoration(
                          hintText: 'task_title'.tr(),
                        ),
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.fontSize,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: descriptionTextController,
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
                      subtitle: Text(widget.task.importance.name).tr(),
                      onTap: () {
                        final overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromRect(
                            Rect.fromPoints(
                              overlay.localToGlobal(Offset.zero),
                              overlay.localToGlobal(
                                overlay.size.bottomRight(Offset.zero),
                              ),
                            ),
                            Offset.zero & overlay.size,
                          ),
                          items: <PopupMenuEntry<Importance>>[
                            PopupMenuItem<Importance>(
                              value: Importance.no,
                              child: Text(Importance.no.name).tr(),
                            ),
                            PopupMenuItem<Importance>(
                              value: Importance.low,
                              child: Text(Importance.low.name).tr(),
                            ),
                            PopupMenuItem<Importance>(
                              value: Importance.high,
                              child: Text(Importance.high.name).tr(),
                            ),
                          ],
                        ).then((Importance? value) {
                          setState(() {
                            widget.task.importance =
                                value ?? widget.task.importance;
                            //logger.i(value?.name);
                          });
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('deadline').tr(),
                      subtitle: widget.task.deadline != null
                          ? Text(widget.task.deadline?.date ?? '')
                          : null,
                      value: widget.task.hasDeadline,
                      onChanged: (bool value) {
                        widget.task.hasDeadline = value;
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
                            widget.task.deadline = value;
                            if (value == null) {
                              widget.task.hasDeadline = false;
                            }
                            setState(() {});
                          });
                        } else {
                          widget.task.deadline = null;
                          widget.task.hasDeadline = false;
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
