import 'package:flutter/material.dart';

class Taskform extends StatefulWidget {
  const Taskform({super.key});

  @override
  State<Taskform> createState() => _TaskformState();
}

class _TaskformState extends State<Taskform> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Form"),
      ),
      body: Container(),
    );
  }
}
