import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_todo_list/UI/widgets/tasks/tasks/taskWidgetModel.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class taskWidgetConfig {
  final int groupKey;
  final String title;

  taskWidgetConfig({required this.groupKey, required this.title});
}

class TaskWidget extends StatefulWidget {
  
  final taskWidgetConfig config;
  const TaskWidget({super.key, required this.config});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TaskWidgetModel _model;
  @override
  void initState() {
    _model = TaskWidgetModel(config: widget.config);
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
        title: Text(model?.config.title ?? "Tasks"),
      ),
      body: TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.openForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCount = TaskWidgetProvider.watch(context)!.model.tasks.length;
    print(groupsCount);
    // if (groupsCount.length == 0) {
    //   return const Center(child: Text("No groups available"));
    // }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return RowTaskListWidget(
          listIndex: index,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1);
      },
      itemCount: groupsCount,
    );
  }
}

class RowTaskListWidget extends StatelessWidget {
  final int listIndex;
  const RowTaskListWidget({super.key, required this.listIndex});

  @override
  Widget build(BuildContext context) {
    final _model = TaskWidgetProvider.read(context)?.model;
    final currentTask = _model?.tasks[listIndex];
    final icon =
        currentTask!.isDone ? Icons.done : Icons.check_box_outline_blank;
    final style = currentTask!.isDone
        ? TextStyle(decoration: TextDecoration.lineThrough)
        : TextStyle(decoration: TextDecoration.none);
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) =>
                TaskWidgetProvider.read(context)!.model.delteTasks(listIndex),
            backgroundColor: const Color.fromARGB(255, 233, 5, 46),
            icon: Icons.delete,

            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        trailing: Icon(icon),
        title: Text(
          currentTask?.text ?? "Unnamed Group",
          style: style,
        ),
        onTap: () => _model?.taskToggle(listIndex),
      ),
    );
  }
}
