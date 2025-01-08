import 'package:flutter/material.dart';
import 'package:hive_todo_list/widgets/UI/tasks/tasks/taskWidgetModel.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TaskWidgetModel? _model;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TaskWidgetProvider(model: model, child: TaskWidetBody());
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class TaskWidetBody extends StatelessWidget {
  const TaskWidetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetProvider.watch(context)?.model;

    return Scaffold(
      appBar: AppBar(
        title: Text(model?.groups?.name ?? "Tasks"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
