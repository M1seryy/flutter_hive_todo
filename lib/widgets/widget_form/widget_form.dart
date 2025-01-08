import 'package:flutter/material.dart';
import 'package:hive_todo_list/widgets/widget_form/widget_model.dart';

class WidgetForm extends StatelessWidget {
  WidgetForm({super.key});
  final _model = groupFormModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormProvider(model: _model, child: groupWidgetBody());
  }
}

class groupWidgetBody extends StatelessWidget {
  const groupWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: Text('Нова група'),
      ),
      body: Center(
        child: widget_form_field(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.saveGroup(context),
        child: Icon(Icons.done),
      ),
    );
  }
}

class widget_form_field extends StatelessWidget {
  const widget_form_field({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormProvider.read(context)?.model;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        autofocus: true,
        onChanged: (value) => model?.groupName = value,
        onEditingComplete: () => model?.saveGroup(context),
        decoration: InputDecoration(
            hintText: 'Додати групу',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
