import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_list/src/features/edit_task/bloc/edit_task_bloc.dart';
import 'package:todo_repository/todo_repository.dart';

import '../../../common_widgets/my_dialogs.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key});

  static Route<void> route({Todo? initialTask}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => EditTaskBloc(
          repository: context.read<TodoRepository>(),
          initialTask: initialTask,
        ),
        child: const EditTaskPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTaskBloc, EditTaskState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTaskStatus.success,
      listener: (context, status) => Navigator.of(context).pop(),
      child: const EditTaskView(),
    );
  }
}

class EditTaskView extends StatelessWidget {
  const EditTaskView({super.key});

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
                  final text =
                      context.select((EditTaskBloc bloc) => bloc.state.text);
                  if (text == '') {
                    MyDialogs.showInfoDialog(
                      context: context,
                      title: 'empty_title',
                      description: 'empty_title_description',
                    );
                  } else {
                    context.read<EditTaskBloc>().add(const EditTaskSubmitted());
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
          const _EditTaskContent(),
        ],
      ),
    );
  }
}

class _EditTaskContent extends StatelessWidget {
  const _EditTaskContent();

  @override
  Widget build(BuildContext context) {
    final importance =
        context.select((EditTaskBloc bloc) => bloc.state.importance);
    final deadline = context.select((EditTaskBloc bloc) => bloc.state.deadline);
    var hasDeadline = deadline != null;
    final isNewTask =
        context.select((EditTaskBloc bloc) => bloc.state.isNewTask);

    return SliverPadding(
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
                    decoration: InputDecoration(
                      hintText: 'task_description'.tr(),
                      border: InputBorder.none,
                    ),
                    minLines: 4,
                    maxLines: null,
                    onChanged: (text) {
                      context
                          .read<EditTaskBloc>()
                          .add(EditTaskTextChanged(text));
                    },
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
                      value: importance,
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
                          context
                              .read<EditTaskBloc>()
                              .add(EditTaskImportanceChanged(value));
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
                    if (deadline != null)
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
                                context
                                    .read<EditTaskBloc>()
                                    .add(EditTaskDeadlineChanged(value));
                              }
                            });
                          },
                          child: Text(
                            deadline.date,
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
                    showDatePicker(
                      context: context,
                      initialDate: currentDate.add(
                        const Duration(days: 1),
                      ),
                      firstDate: currentDate,
                      lastDate: DateTime(2030),
                    ).then((value) {
                      context
                          .read<EditTaskBloc>()
                          .add(EditTaskDeadlineChanged(value));
                      if (value == null) {
                        hasDeadline = false;
                      }
                    });
                  } else {
                    context
                        .read<EditTaskBloc>()
                        .add(const EditTaskDeadlineChanged(null));
                  }
                },
              ),
              const Divider(),
              TextButton(
                onPressed: isNewTask
                    ? null
                    : () {
                        MyDialogs.showConfirmDialog(
                          context: context,
                          title: 'confirm_delete',
                          description: 'confirm_delete_description',
                          onConfirmed: () {
                            context
                                .read<EditTaskBloc>()
                                .add(const EditTaskDeletionRequested());
                          },
                        );
                      },
                style: ButtonStyle(
                  foregroundColor: isNewTask
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
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
