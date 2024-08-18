import 'package:flutter/material.dart';
import 'package:todo_app/src/common/models/todo_model.dart';

class TodoItems extends StatelessWidget {
  final ToDo toDo;
  final dynamic onToDoChanged;
  final dynamic onDeleteItem;

  const TodoItems({
    super.key,
    required this.toDo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: ListTile(
        onTap: () {
          onToDoChanged(toDo);
        },
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          toDo.todoText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            decoration: toDo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Icon(
          toDo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        trailing: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          padding: const EdgeInsets.all(0),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 20,
            onPressed: () {
              onDeleteItem(
                toDo.id,
              );
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ),
      ),
    );
  }
}
