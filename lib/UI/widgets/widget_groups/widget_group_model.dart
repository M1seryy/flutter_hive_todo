import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/UI/NAVIGATION/mainNavigation.dart';
import 'package:hive_todo_list/UI/widgets/tasks/tasks/taskWidget.dart';
import 'package:hive_todo_list/domain/dataProvider/boxManager.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class GroupWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  GroupWidgetModel() {
    setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(mainNavigationRouteNames.groupForm);
  }

  void showTasks(BuildContext context, int listIndex) async {
    final group = (await _box).getAt(listIndex);
    if (group != null) {
      final config =
          taskWidgetConfig(groupKey: group.key as int, title: group.name);
      Navigator.of(context)
          .pushNamed(mainNavigationRouteNames.tasks, arguments: config);
    }
  }

  void deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskName = BoxManager.instance.makeTaskBoxName(groupIndex);
    Hive.deleteBoxFromDisk(taskName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readHiveData() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> setup() async {
    _box = BoxManager.instance.openGroupBox();

    _readHiveData();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(() => _readHiveData);
  }

  @override
  void dispose() async {
    _listenableBox?.removeListener(_readHiveData);
    await BoxManager.instance.closeBox((await _box));

    // TODO: implement dispose

    super.dispose();
  }
}

class group_widget_provider extends InheritedNotifier {
  final Widget child;
  final GroupWidgetModel model;
  const group_widget_provider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  static group_widget_provider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<group_widget_provider>();
  }

  static group_widget_provider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<group_widget_provider>()
        ?.widget;
    return widget is group_widget_provider ? widget : null;
  }
}
