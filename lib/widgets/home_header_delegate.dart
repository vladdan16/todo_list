import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int completed;

  HomeHeaderDelegate({required this.completed});

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
          // if (shrinkOffset == maxExtent)
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.shadow,
          //     spreadRadius: 1,
          //     blurRadius: 10,
          //     offset: const Offset(0, 1),
          //   ),
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
                    progress < 0.7 ? progress : 1,
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
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    progress,
                  ),
                ).tr(),
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
