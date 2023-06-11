import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

  @override
  void initState() {
    titleTextController = TextEditingController(text: widget.task.name);
    descriptionTextController = TextEditingController(
      text: widget.task.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // TODO: save
                  Navigator.of(context).pop();
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: titleTextController,
                        decoration: InputDecoration(
                          hintText: 'task_title'.tr(),
                          //border: const OutlineInputBorder()
                        ),
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.fontSize,
                        ),
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
