import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskerpro/dialogs.dart';
import 'package:taskerpro/task_proider.dart';
import 'package:provider/provider.dart';
import 'task.dart';

class addTask extends StatefulWidget {
  Task? ptask;
  addTask({Key? key, Task? this.ptask}) : super(key: key);

  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  Object? $;
  bool _isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.ptask != null) {
      _titleController.text = widget.ptask!.title;
      _descriptionController.text = widget.ptask!.description;
      _selectedDate = widget.ptask!.dueDate;
      _isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50.0,
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintStyle: const TextStyle(color: Colors.red),
                  hintText: 'Task Name',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                  ),
                ),
                controller: _titleController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: TextField(
                decoration: const InputDecoration(
                    hintStyle: const TextStyle(color: Colors.red),
                    hintText: 'Task Description',
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 2.0,
                      ),
                    )),
                controller: _descriptionController,
              ),
            ),
            // Date Picker for due date
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select A Due Date!'
                          : 'Due Date: ${DateFormat("dd MMM yyyy").format(_selectedDate!)}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color:
                            _selectedDate == null ? Colors.red : Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        pickDate(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Warn if due date is not is before today
            _selectedDate != null && _selectedDate!.isBefore(DateTime.now())
                ? const Text(
                    "Due Date is in the past!",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                : Container(),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 80.0,
                ),
                child: ElevatedButton(
                  child: Text(_isEdit ? 'Edit Task' : 'Add Task'),
                  onPressed: () {
                    // Check No fields are empty
                    if (_selectedDate == null ||
                        _titleController.text == '' ||
                        _descriptionController.text == '') {
                      dialogs.showEmptyFieldsErrorDialog(context);
                    } else {
                      Task task = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        isDone: false,
                        dueDate:
                            _selectedDate!, //force unwrapping because non null condition already handled
                      );
                      // print(DateFormat("dd MMMM yyyy").format(_selectedDate!));
                      // Check if task is being edited or added
                      if (_isEdit) {
                        task.id = widget.ptask!.id;
                        context.read<TaskProvider>().updateTaskInFirebase(task);
                        Navigator.pop(context);
                      } else {
                        context.read<TaskProvider>().addTask(task);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) {
      return;
    }
    setState(() => _selectedDate = newDate);
  }

  boxBorder({required BorderRadius borderRadius}) {}
}
