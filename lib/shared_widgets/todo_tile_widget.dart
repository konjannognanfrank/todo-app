import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utilities/utils.dart';
import 'package:todo_app/views/todo_detail_view.dart';

class TodoTileWidget extends StatelessWidget {
  const TodoTileWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Datum todo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return TodoDetailView(
              todo: todo,
            );
          },
        ));
      },
      child: Card(
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
              leading: Icon(
                todo.status == false
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                size: 30,
                color: dateColor(todo.endDate),
              ),
              title: Text(
                todo.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18),
              ),
              subtitle: Text(
                todo.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications,
                    color: dateColor(todo.endDate),
                  ),
                  Text(
                    todo.endDate,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: dateColor(todo.endDate)),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
