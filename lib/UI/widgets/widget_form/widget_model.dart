import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/domain/entity/group.dart';

class groupFormModel {
  var groupName = '';
  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>("group_box");
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.of(context).pop();
  }
}

class GroupFormProvider extends InheritedWidget {
  final groupFormModel model;

  final Widget child;
  const GroupFormProvider({super.key, required this.child, required this.model})
      : super(child: child);

  static GroupFormProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupFormProvider>();
  }

  static GroupFormProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormProvider>()
        ?.widget;
    return widget is GroupFormProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormProvider oldWidget) {
    return true;
  }
}
