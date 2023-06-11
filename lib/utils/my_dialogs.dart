import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class MyDialogs {
  static void showAddTaskDialog({required BuildContext context}) {
    final titleTextController = TextEditingController();
    final descriptionTextController = TextEditingController();
    var dialog = Dialog.fullscreen(
      child: CustomScrollView(
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
                          fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }
}
