import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/shared_widgets/todo_tile_widget.dart';
import 'package:todo_app/utilities/utils.dart';
import 'package:todo_app/views/create_todo_view.dart';
import 'package:todo_app/views/search_delegate.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TodoController _todoController = TodoController();

  int value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 50,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.red,
            backgroundImage: AssetImage('assets/profile_img.jpg'),
          ),
        ),
        title: const Text('My Todos'),
        actions: [
          PopupMenuButton(
              color: Colors.blue,
              icon: const Icon(Icons.sort),
              onSelected: (int value) {
                setState(() {
                  this.value = value;
                });
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text(
                        "Todo",
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Completed",
                          style: TextStyle(color: Colors.white)),
                      value: 2,
                    )
                  ]),
          IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: MySearchDelegate(), query: '');
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<Todo?>(
          future: _todoController.getAllTodos(status: value != 1),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 30),
              );
            }
            return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Dismissible(
                    secondaryBackground: const Material(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    background: const Material(
                      color: Colors.green,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (dismissedDirection) {
                      SnackBar snackBar = const SnackBar(
                        content: Text('Todo has been deleted!',
                            style: TextStyle(
                              color: Colors.green,
                            )),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    confirmDismiss: (dismissedDirection) async {
                      if (dismissedDirection == DismissDirection.endToStart) {
                        return showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    'Are you sure you want to delete this Todo?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        bool isDeleted =
                                            await _todoController.deleteTodo(
                                                snapshot.data!.data[index].id);
                                        Navigator.of(context).pop(isDeleted);
                                      },
                                      child: const Text('Ok')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              );
                            });
                      } else {
                        //update
                        showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    'Are you sure you want to update this Todo\'s status?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        bool isUpdate = await _todoController
                                            .updateTodoStatus(
                                                id: snapshot
                                                    .data!.data[index].id,
                                                status: !snapshot
                                                    .data!.data[index].status);
                                        Navigator.of(context).pop(isUpdate);
                                        setState(() {});
                                      },
                                      child: const Text('Ok')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              );
                            });
                      }

                      // print('confirmDismiss');
                    },
                    key: UniqueKey(),
                    child: TodoTileWidget(
                      todo: snapshot.data!.data[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: snapshot.data!.data.length);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const CreateTodoView();
          }));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SafeArea(
        child: InkWell(
          onTap: () {
            showBarModalBottomSheet(
                context: context,
                builder: (context) {
                  return const CompletedTodoWidget();
                });
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: customBlue,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Completed',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w600, color: customBlue),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: customBlue,
                    )
                  ],
                ),
                Text(
                  '24',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: customBlue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompletedTodoWidget extends StatefulWidget {
  const CompletedTodoWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CompletedTodoWidget> createState() => _CompletedTodoWidgetState();
}

class _CompletedTodoWidgetState extends State<CompletedTodoWidget> {
  final TodoController _todoController = TodoController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Todo?>(
        future: _todoController.getAllTodos(status: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {
            return const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 30),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Dismissible(
                  secondaryBackground: const Material(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  background: const Material(
                    color: Colors.green,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (dismissedDirection) {
                    SnackBar snackBar = const SnackBar(
                      content: Text('Todo has been deleted!',
                          style: TextStyle(
                            color: Colors.green,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  confirmDismiss: (dismissedDirection) async {
                    if (dismissedDirection == DismissDirection.endToStart) {
                      return showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                  'Are you sure you want to delete this Todo?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      bool isDeleted =
                                          await _todoController.deleteTodo(
                                              snapshot.data!.data[index].id);
                                      Navigator.of(context).pop(isDeleted);
                                    },
                                    child: const Text('Ok')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                          });
                    } else {
//update

                      showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                  'Are you sure you want to update this Todo\'s status?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      bool isUpdate = await _todoController
                                          .updateTodoStatus(
                                              id: snapshot.data!.data[index].id,
                                              status: !snapshot
                                                  .data!.data[index].status);
                                      Navigator.of(context).pop(isUpdate);
                                      setState(() {});
                                    },
                                    child: const Text('Ok')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                          });
                    }

                    // print('confirmDismiss');
                  },
                  key: UniqueKey(),
                  child: TodoTileWidget(
                    todo: snapshot.data!.data[index],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: snapshot.data!.data.length);
        });
  }
}
