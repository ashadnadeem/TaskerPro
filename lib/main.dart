import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/task_proider.dart';
import 'package:taskerpro/dialogs.dart';
import 'addTaskPage.dart';
import 'task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // For Flutter firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBXOnFtC1mBJoxigZTNZUHff62y6HyXZFY",
      authDomain: "taskerpro-31e7a.firebaseapp.com",
      projectId: "taskerpro-31e7a",
      storageBucket: "taskerpro-31e7a.appspot.com",
      messagingSenderId: "846401053786",
      appId: "1:846401053786:web:4d0958f83bbc9f656ae463",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MyApp(),
    ),
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
  bool _isLoading = true;

  void _loadDummyData() {
    context.read<TaskProvider>().addTask(Task(
        title: 'Flutter Assignment 4',
        description: 'task management system + flutter',
        dueDate: DateTime(2022, 03, 28)));
    context.read<TaskProvider>().addTask(Task(
        title: 'Buisness Inteligence',
        description: 'Bi Pitch to company',
        dueDate: DateTime(2022, 04, 15)));
    context.read<TaskProvider>().addTask(Task(
        title: 'MobAppDev: Project Phase 3',
        description: 'Working UI in code.',
        dueDate: DateTime(2022, 03, 28)));
    context.read<TaskProvider>().addTask(Task(
        title: 'Corporate Work',
        description: 'Trax Weighing Scales',
        dueDate: DateTime(2022, 03, 30)));
    context.read<TaskProvider>().addTask(Task(
        title: 'Quiz DAA',
        description: 'Quiz on Dynamic Programming',
        dueDate: DateTime(2022, 03, 5)));
  }

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // Dummy Data
    // _loadDummyData();

    //Run circular progress bar
    loadInitial();
  }

  void loadInitial() async {
    // Load from Firebase
    context.read<TaskProvider>().loadTasks();
    // delay(Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    // wait for the data to load
    setState(() {});
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
            children: _isLoading
                ? <Widget>[const CircularProgressIndicator()]
                : <Widget>[
                    if (myTasks.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
              // Mark as done button
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
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await dialogs.showDeleteConfirmationDialog(context, task)
                      ? context.read<TaskProvider>().removeTask(task)
                      : null;
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
        ),
      ),
    );
  }
}
