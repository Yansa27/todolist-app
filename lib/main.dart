import 'package:flutter/material.dart';
import 'todo_list_page.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigoAccent,
        ),
      ),
      home: ToDoListPage(),
    );
  }
}
