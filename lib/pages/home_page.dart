import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/core/task_database.dart';
import 'package:todo_list/core/todo.dart';
import 'package:todo_list/pages/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _showCompleteTasks = false;
  var database = TaskDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('todo_list').tr(),
                IconButton(
                  icon: Icon(_showCompleteTasks
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      // TODO: show only not completed tasks
                      _showCompleteTasks = !_showCompleteTasks;
                    });
                  },
                ),
              ],
            ),
            floating: true,
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 80),
            sliver: SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      for (var task in database.tasks)
                        ListTile(
                          title: Text(task.name),
                          leading: Checkbox(
                            value: task.done,
                            onChanged: (bool? value) {
                              setState(() {
                                database.modifyTask(task, done: value);
                              });
                            },
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // MyDialogs.showTaskDialog(context: context);
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
