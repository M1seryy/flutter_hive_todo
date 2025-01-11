import 'package:flutter/material.dart';
import 'package:hive_todo_list/widgets/UI/tasks/taskForm/taskFormModel.dart';

class Taskform extends StatefulWidget {
  const Taskform({super.key});

  @override
  State<Taskform> createState() => _TaskformState();
}

class _TaskformState extends State<Taskform> {
  taskFormModel? _model;
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = taskFormModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormProvider(child: taskWidgetBody(), model: _model!);
  }
}

class taskWidgetBody extends StatelessWidget {
  const taskWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: Text('Нове завдання'),
      ),
      body: Center(
        child: widget_task_form_field(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.saveTask(context),
        child: Icon(Icons.done),
      ),
    );
  }
}

class widget_task_form_field extends StatelessWidget {
  const widget_task_form_field({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormProvider.read(context)?.model;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        autofocus: true,
        onChanged: (value) => model?.taskName = value,
        onEditingComplete: () => model?.saveTask(context),
        decoration: InputDecoration(
            hintText: 'Додати групу',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
