import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/src/common/models/todo_model.dart';
import 'package:todo_app/src/features/todo_list/widgets/todo_items.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreen();
}

class _ToDoListScreen extends State<ToDoListScreen> {
  final List<ToDo> toDoList = [];
  List<ToDo> _foundToDo = [];
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todoString = prefs.getString('todos');
    if (todoString != null) {
      final List<dynamic> todoJson = json.decode(todoString);
      setState(() {
        toDoList.addAll(todoJson.map((json) => ToDo.fromJson(json)).toList());
      });
    }
  }

  Future<void> _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String todoString =
        json.encode(toDoList.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todoString);
  }

  void _deleteToDoItem(String id) {
    setState(() {
      toDoList.removeWhere((item) => item.id == id);
    });
    _saveToDoList();
  }

  void _handleToDoChange(ToDo toDo) {
    setState(() {
      toDo.isDone = !toDo.isDone;
    });
    _saveToDoList();
  }

  void _addToDoItem(String toDo) {
    if (toDo.isNotEmpty) {
      setState(() {
        final newToDo = ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: toDo,
        );
        toDoList.add(newToDo);
        _foundToDo = toDoList;
      });
      _todoController.clear();
      FocusScope.of(context).unfocus();
    }
    _saveToDoList();
  }

  void _runFilter(String enterKeyboard) {
    List<ToDo> result = [];
    if (enterKeyboard.isEmpty) {
      result = toDoList;
    } else {
      result = toDoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enterKeyboard.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 20,
                          maxWidth: 25,
                        ),
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 50,
                            bottom: 20,
                          ),
                          child: const Text(
                            'All ToDos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (ToDo todos in _foundToDo.reversed)
                          TodoItems(
                            onToDoChanged: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                            toDo: todos,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: 'Добавить новую задачу',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(60, 60),
                        elevation: 10,
                      ),
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
