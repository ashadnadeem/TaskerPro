import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/task_proider.dart';

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  bool isDone = false;
  DateTime? markedDoneDate;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class showTask extends StatefulWidget {
  const showTask({Key? key, required this.myTask}) : super(key: key);
  final myTask;
  @override
  State<showTask> createState() => _showTaskState();
}

class _showTaskState extends State<showTask> {
  // Will initialise it in initState hence late
  late Task _myTask;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myTask = widget.myTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Center(
        // Main Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Column Left Aligned for Texts
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text for the Task Title
                    Text(
                      _myTask.title,
                      // style: Theme.of(context).textTheme.headline4,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4?.color,
                        fontSize:
                            Theme.of(context).textTheme.headline4?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text for the Task Description
                    Text(
                      _myTask.description,
                      softWrap: true,
                      maxLines: 8,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    // Text for the Task Due Date
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Text(
                        'Due date: ${DateFormat("dd MMMM yyyy").format(_myTask.dueDate)}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    // Text for the Task Status
                    Text(
                      _myTask.dueDate.isAfter(DateTime.now())
                          ? ""
                          : "Due date has passed!",
                      // text color red
                      style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            Theme.of(context).textTheme.headline5?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text to display when was task marked done
                    Text(
                      _myTask.markedDoneDate != null
                          ? 'You marked this task\nas done on\n${DateFormat("dd MMMM yyyy").format(_myTask.markedDoneDate!)}'
                          : "",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize:
                            Theme.of(context).textTheme.headline5?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
            _myTask.isDone
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              //Mark this Task as Done
                              context
                                  .read<TaskProvider>()
                                  .markTaskDone(_myTask);
                              Navigator.pop(context);
                            },
                            child: const Text("Mark as Done"),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
