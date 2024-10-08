import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  final String task;

  TaskDetailPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
      ),
      body: Center(
        child: Text(task),
      ),
    );
  }
}
