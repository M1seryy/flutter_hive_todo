import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/widgets/widget_groups/widget_group_model.dart';

class Group_widget_screeen extends StatefulWidget {
  const Group_widget_screeen({super.key});

  @override
  State<Group_widget_screeen> createState() => _Group_widget_screeenState();
}

@override
class _Group_widget_screeenState extends State<Group_widget_screeen> {
  final _model = GroupWidgetModel();

  @override
  Widget build(BuildContext context) {
    return group_widget_provider(model: _model, child: group_body());
  }
}

class group_body extends StatelessWidget {
  const group_body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body: GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            group_widget_provider.read(context)?.model.showForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        group_widget_provider.watch(context)!.model.groups.length;
    print(groupsCount);
    // if (groupsCount.length == 0) {
    //   return const Center(child: Text("No groups available"));
    // }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return RowGroupListWidget(
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

class RowGroupListWidget extends StatelessWidget {
  final int listIndex;
  const RowGroupListWidget({super.key, required this.listIndex});

  @override
  Widget build(BuildContext context) {
    final _model = group_widget_provider.read(context)?.model;
    final currentGroup = _model?.groups[listIndex];

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) => group_widget_provider
                .read(context)!
                .model
                .deleteGroup(listIndex),
            backgroundColor: const Color.fromARGB(255, 233, 5, 46),
            icon: Icons.delete,

            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        trailing: Icon(Icons.chevron_right_outlined),
        title: Text(currentGroup?.name ?? "Unnamed Group"),
        onTap: () => _model!.showTasks(context,listIndex),
      ),
    );
  }
}
