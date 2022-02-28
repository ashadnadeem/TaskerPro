import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/task_proider.dart';
import 'addTaskPage.dart';
import 'task.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MyApp(),
    ),
    // const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskerPro',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Tasker Pro: Tasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> myTasks = [];

  void _loadDummyData() {
    context.read<TaskProvider>().addTask(Task(
        title: 'Flutter Assignment',
        description: 'task management system',
        dueDate: DateTime(2022, 02, 27)));
    context.read<TaskProvider>().addTask(Task(
        title: 'Buisness Inteligence',
        description: 'Bi Dashboarding',
        dueDate: DateTime(2022, 02, 25)));
    context.read<TaskProvider>().addTask(Task(
        title: 'MobAppDev: Project Proposal',
        description:
            'You need to submit a PDF document which contains the following details about your project',
        dueDate: DateTime(2022, 03, 8)));
    context.read<TaskProvider>().addTask(Task(
        title: 'SP Lab 12',
        description: 'Systems Programing Lab task 12',
        dueDate: DateTime(2022, 02, 24)));
    context.read<TaskProvider>().addTask(Task(
        title: 'Quiz DAA',
        description: 'Quiz on recurrences',
        dueDate: DateTime(2022, 02, 28)));
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // Dummy Data
    // _loadDummyData();
  }

  @override
  Widget build(BuildContext context) {
    myTasks = context.watch<TaskProvider>().tasks;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (myTasks.isEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "You have no pending tasks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to add task page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => addTask(),
                              ));
                        },
                        onLongPress: () {
                          //Load Dummy Data
                          _loadDummyData();
                        },
                        child: const Text(
                          'Add a New Task',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: myTasks.length,
                    itemBuilder: (context, index) {
                      return TaskTile(task: myTasks[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: _getFAB());
  }

  Widget _getFAB() {
    if (myTasks.isEmpty) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to add task page
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addTask(),
                ));
          },
          tooltip: 'Add a new task',
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle:
              Text('Due: ${DateFormat("dd MMMM yyyy").format(task.dueDate)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: task.isDone
                    ? const Icon(Icons.check_circle_rounded,
                        color: Colors.green)
                    : const Icon(Icons.circle_outlined),
                onPressed: () {
                  task.isDone
                      ? context.read<TaskProvider>().markTaskNotDone(task)
                      : context.read<TaskProvider>().markTaskDone(task);
                  //tell the parent class to  setState(){};
                },
              ),
              // Rectangle box
              Container(
                width: 15,
                height: 50,
                decoration: BoxDecoration(
                  //check if due date is past or not by dueDate and current date
                  color: task.dueDate.isBefore(DateTime.now())
                      ? const Color.fromARGB(255, 172, 18, 7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => showTask(myTask: task)),
            );
          },
          onLongPress: () {
            //Remove that Task
            context.read<TaskProvider>().removeTask(task);
          },
        ),
      ),
    );
  }
}
