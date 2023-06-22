import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/src/features/edit_task/presentation/task_page.dart';
import 'package:todo_list/src/features/task_list/application/home_service.dart';

import '../../../common_widgets/my_dialogs.dart';
import '../../../core/todo.dart';
import 'home_header_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();
  late HomeService service;

  @override
  void initState() {
    service = HomeService(widget.prefs);
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
            delegate: HomeHeaderDelegate(
                completed: service.completed,
                visibility: service.showCompleteTasks,
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
                        for (var task in service.tasks)
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
                                    logger.i(
                                      'Task ${task.name} has been removed',
                                    );
                                  },
                                );
                              } else {
                                service.modifyTask(task, done: !task.done);
                                if (service.showCompleteTasks) {
                                  setState(() {});
                                  return false;
                                }
                                return true;
                              }
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF34C759),
                                borderRadius: service.tasks.first == task
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
                                borderRadius: service.tasks.first == task
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
                                  if (task.importance == Importance.high &&
                                      !task.done)
                                    const Text(
                                      '!! ',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  Expanded(
                                    child: Text(
                                      task.name,
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
                              subtitle: task.hasDeadline
                                  ? Text(task.deadline!.date)
                                  : null,
                              leading: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      task.importance == Importance.high
                                          ? Colors.red
                                          : Colors.grey,
                                  primarySwatch: Colors.green,
                                ),
                                child: Checkbox(
                                  value: task.done,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      service.modifyTask(task, done: value);
                                    });
                                  },
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () async {
                                  final _ = await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      logger.i('User opens a TaskPage');
                                      return TaskPage(task: task);
                                    }),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        if (service.tasks.isNotEmpty) const Divider(),
                        ListTile(
                          onTap: () async {
                            final _ = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                logger.i('User opens a TaskPage');
                                return TaskPage(task: ToDo(), newTask: true);
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
              logger.i('User opens a TaskPage');
              return TaskPage(task: ToDo(), newTask: true);
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
