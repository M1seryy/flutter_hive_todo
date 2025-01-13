import 'package:flutter/material.dart';
import 'package:hive_todo_list/UI/widgets/tasks/taskForm/taskForm.dart';
import 'package:hive_todo_list/UI/widgets/tasks/tasks/taskWidget.dart';
import 'package:hive_todo_list/UI/widgets/widget_form/widget_form.dart';
import 'package:hive_todo_list/UI/widgets/widget_groups/widget_groups.dart';

abstract class mainNavigationRouteNames {
  static const groups = "/groups/";
  static const groupForm = "/groups/form/";
  static const tasks = "/groups/task/";
  static const tasksForm = "/groups/task/from/";
}

class mainNavigation {
  final initialRoute = mainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    mainNavigationRouteNames.groups: (context) => const Group_widget_screeen(),
    mainNavigationRouteNames.groupForm: (context) => WidgetForm(),
    mainNavigationRouteNames.tasks: (context) => TaskWidget(),
    mainNavigationRouteNames.tasksForm: (context) => Taskform(),
  };
}
