
import 'package:flutter/material.dart';

import 'todo_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Todo app using firebase',
      home: TodoList(),
    );
  }
}