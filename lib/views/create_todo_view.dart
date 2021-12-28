import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/utilities/utils.dart';

class CreateTodoView extends StatefulWidget {
  const CreateTodoView({Key? key}) : super(key: key);

  @override
  State<CreateTodoView> createState() => _CreateTodoViewState();
}

class _CreateTodoViewState extends State<CreateTodoView> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _timeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TodoController _todoController = TodoController();

  bool isLoading = false;

  @override
  void dispose() {
    _timeController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _titleController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Todo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  label: const Text('Title'),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  hintText: 'Please enter a title',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: customBlue))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'enter a title';
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  label: const Text('Description'),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  hintText: 'Please enter a description',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((value) {
                        setState(() {
                          _dateController.text =
                              DateFormat.yMMMMd().format(value!);
                        });
                      });
                    },
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        label: const Text('Date'),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        hintText: 'Please enter a date',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: customBlue))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please Select a date';
                      }

                      if (value == DateFormat.yMMMMd().format(DateTime.now())) {
                        return 'You selected today\'s date';
                      } else {
                        return 'you selected $_dateController date';
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) {
                        setState(() {
                          _timeController.text = value!.format(context);
                        });
                      });
                    },
                    controller: _timeController,
                    keyboardType: TextInputType.datetime,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        label: const Text('Time'),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        hintText: 'Please enter a time',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: customBlue))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select enter a time';
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String dateTime =
                            _dateController.text + " " + _timeController.text;
                        // String dateTime = '${_dateController.text}  ${_timeController.text}';
                        setState(() {
                          isLoading = true;
                        });

                        bool isSuccessful = await _todoController.createTodo(
                            title: _titleController.text,
                            body: _descriptionController.text,
                            endDate: dateTime);

                        setState(() {
                          isLoading = false;
                        });
                        if (isSuccessful) {
                          //do something

                          _timeController.clear();
                          _descriptionController.clear();
                          _dateController.clear();
                          _titleController.clear();
                          SnackBar snackBar = const SnackBar(
                            content: Text('Todo created successfully!',
                                style: TextStyle(
                                  color: Colors.green,
                                )),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          //do another thing
                          SnackBar snackBar = const SnackBar(
                            content: Text('Failed to create Todo!',
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        SnackBar snackBar = const SnackBar(
                          content: Text('All fields are required!',
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text(
                      'create Todo',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: customBlue),
                  )
          ],
        ),
      ),
    );
  }
}
