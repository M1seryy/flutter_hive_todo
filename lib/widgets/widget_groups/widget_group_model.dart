import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/domain/entity/group.dart';

class GroupWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  GroupWidgetModel() {
    setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void showTasks(BuildContext context, int listIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>("group_box");
    final groupKey = box.keyAt(listIndex) as int;

    Navigator.of(context).pushNamed('/groups/task', arguments: groupKey);
  }

  void deleteGroup(int groupIndex) async {
    final box = await Hive.openBox<Group>("group_box");
    await box.deleteAt(groupIndex);
  }

  void _readHiveData(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  Future<void> setup() async {
    // if (!Hive.isAdapterRegistered(1)) {
    //   Hive.registerAdapter(GroupAdapter());
    // }

    final box = await Hive.openBox<Group>("group_box");
    _groups = box.values.toList();
    _readHiveData(box);
    box.listenable().addListener(() {
      _readHiveData(box);
    });
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
