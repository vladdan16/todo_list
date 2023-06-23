import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TaskListHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int completed;
  bool visibility;
  final void Function() onChangeVisibility;

  TaskListHeaderDelegate({
    required this.completed,
    required this.onChangeVisibility,
    required this.visibility,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.secondaryContainer,
          progress,
        ),
        boxShadow: [
          BoxShadow.lerp(
                const BoxShadow(),
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
                progress > 0.5 ? progress : 0,
              ) ??
              const BoxShadow(),
        ],
      ),
      child: SafeArea(
        child: AnimatedContainer(
          width: double.infinity,
          height: double.infinity,
          duration: const Duration(microseconds: 50),
          padding: EdgeInsets.lerp(
            const EdgeInsets.only(left: 40, bottom: 8, right: 15),
            const EdgeInsets.only(left: 15, bottom: 8, right: 15),
            progress,
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Text(
                  '${'completed'.tr()} - $completed',
                  style: TextStyle.lerp(
                    TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const TextStyle(
                      fontSize: 16,
                      color: Colors.transparent,
                    ),
                    progress * 2 > 1 ? 1 : progress * 2,
                  ),
                ),
              ),
              Positioned(
                bottom: _titlePosition(shrinkOffset),
                child: Text(
                  'todo_list',
                  style: TextStyle.lerp(
                    TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    progress,
                  ),
                ).tr(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: onChangeVisibility,
                  icon: Icon(
                    visibility ? Icons.visibility_off : Icons.visibility,
                    //color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _titlePosition(double shrinkOffset) =>
      (1 - max(0.0, shrinkOffset) / maxExtent) * 20;

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
