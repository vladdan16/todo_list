import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_list/src/models/edit_task.dart';
import 'package:todo_list/src/models/task_list.dart';

import '../../../common_widgets/my_dialogs.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({
    super.key,
    // required this.id,
  });

  // final String id;

  @override
  Widget build(BuildContext context) {
    bool newTask = context.read<EditTaskModel>().newTask;
    final controller = TextEditingController(
      text: context.read<EditTaskModel>().text,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  context.read<EditTaskModel>().saveTask(
                        text: controller.text,
                        onSaved: (task) {
                          context.read<TaskListModel>().saveTask(task);
                          context.pop();
                        },
                        onTextEmpty: () => MyDialogs.showInfoDialog(
                          context: context,
                          title: 'empty_title',
                          description: 'empty_title_description',
                        ),
                      );
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
                          controller: controller,
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
                            value: context.watch<EditTaskModel>().importance,
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
                              if (value != null) {
                                context.read<EditTaskModel>().importance =
                                    value;
                              }
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
                          if (context.watch<EditTaskModel>().deadline != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  var currentDate = DateTime.now();
                                  showDatePicker(
                                    context: context,
                                    initialDate: currentDate.add(
                                      const Duration(days: 1),
                                    ),
                                    firstDate: currentDate,
                                    lastDate: DateTime(2030),
                                  ).then((value) {
                                    if (value != null) {
                                      context.read<EditTaskModel>().deadline =
                                          value;
                                    }
                                  });
                                },
                                child: Text(
                                  context
                                          .watch<EditTaskModel>()
                                          .deadline
                                          ?.date ??
                                      '',
                                ),
                              ),
                            ),
                        ],
                      ),
                      value: context.watch<EditTaskModel>().hasDeadline,
                      onChanged: (bool value) {
                        context.read<EditTaskModel>().hasDeadline = value;
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
                            context.read<EditTaskModel>().deadline = value;
                          });
                        } else {
                          context.read<EditTaskModel>().deadline = null;
                        }
                      },
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: newTask
                          ? null
                          : () {
                              MyDialogs.showConfirmDialog(
                                context: context,
                                title: 'confirm_delete',
                                description: 'confirm_delete_description',
                                onConfirmed: () {
                                  context.read<TaskListModel>().removeTask(
                                        context.read<EditTaskModel>().task,
                                      );
                                  context.pop();
                                },
                              );
                            },
                      style: ButtonStyle(
                        foregroundColor: newTask
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
