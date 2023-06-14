import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/task_database.dart';
import 'package:todo_list/core/todo.dart';
import 'package:todo_list/pages/task_page.dart';
import 'package:todo_list/widgets/home_header_delegate.dart';
import 'package:todo_list/widgets/my_dialogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final database = TaskDatabase();
  late bool _showCompleteTasks;
  late List<ToDo> tasks;

  @override
  void initState() {
    _showCompleteTasks = widget.prefs.getBool('show_completed_tasks') ?? true;
    tasks = _showCompleteTasks ? database.tasks : database.uncompletedTasks;
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
            delegate: HomeHeaderDelegate(completed: database.completed),
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
                        for (var task in tasks)
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
                                    database.removeTask(task);
                                  },
                                );
                              } else {
                                database.modifyTask(task, done: !task.done);
                                return true;
                              }
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF34C759),
                                borderRadius: tasks.first == task
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
                                borderRadius: tasks.first == task
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
                                  if (task.importance == Importance.low)
                                    const Icon(Icons.arrow_downward),
                                  if (task.importance == Importance.high)
                                    const Text(
                                      '!! ',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  Text(
                                    task.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (task.description != '')
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (task.hasDeadline)
                                    Text(task.deadline!.date)
                                ],
                              ),
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
                                      database.modifyTask(task, done: value);
                                    });
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
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        if (tasks.isNotEmpty) const Divider(),
                        ListTile(
                          onTap: () async {
                            final _ = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
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
