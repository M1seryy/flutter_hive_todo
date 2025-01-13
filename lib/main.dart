import 'package:flutter/material.dart';
import 'package:hive_todo_list/UI/NAVIGATION/mainNavigation.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/UI/widgets/tasks/taskForm/taskForm.dart';
import 'package:hive_todo_list/UI/widgets/tasks/tasks/taskWidget.dart';
import 'package:hive_todo_list/UI/widgets/widget_form/widget_form.dart';
import 'package:hive_todo_list/UI/widgets/widget_groups/widget_groups.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(GroupAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mainNav = mainNavigation();
    return MaterialApp(
      title: 'Flutter Demo',
      routes: mainNav.routes,
      initialRoute: mainNav.initialRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Group_widget_screeen(),
    );
  }
}
