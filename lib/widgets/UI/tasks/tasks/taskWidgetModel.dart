import 'package:flutter/material.dart';

class TaskWidgetModel extends ChangeNotifier {
  final int groupKey;

  TaskWidgetModel({required this.groupKey});
}

class TaskWidgetProvider extends InheritedNotifier {
  final Widget child;
  final TaskWidgetModel model;

  const TaskWidgetProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  static TaskWidgetProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskWidgetProvider>();
  }

  static TaskWidgetProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetProvider>()
        ?.widget;
    return widget is TaskWidgetProvider ? widget : null;
  }
}
