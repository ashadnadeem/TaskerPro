import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskerpro/task.dart';

class TaskProvider extends ChangeNotifier {
  CollectionReference firebaseTask =
      FirebaseFirestore.instance.collection('tasks');
  List<Task> _myTasks = [];

  // List<Task> getTasks() {
  //   return _myTasks;
  // }

  List<Task> get tasks => _myTasks; //inline function for getter

  void addTask(Task task) async {
    // Add task to Firebase
    // Generate a unique id for the task and task.id <=
    var newTaskRef = await firebaseTask.add(task.toJson());
    task.id = newTaskRef.id;
    _myTasks.add(task);
    sortTasks();
    notifyListeners();
  }

  void markTaskDone(Task task) {
    int index = _myTasks.indexOf(task);
    _myTasks[index].isDone = true;
    _myTasks[index].markedDoneDate = DateTime.now();
    sortTasks();
    updateTaskInFirebase(task);
    notifyListeners();
  }

  void markTaskNotDone(Task task) {
    int index = _myTasks.indexOf(task);
    _myTasks[index].isDone = false;
    _myTasks[index].markedDoneDate = null;
    sortTasks();
    updateTaskInFirebase(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _myTasks.remove(task);
    deleteTaskFromFirebase(task);
    notifyListeners();
  }

  void sortTasks() {
    //Sort by dueDates , due Before comes first
    _myTasks.sort(((a, b) => a.dueDate.compareTo(b.dueDate)));
    // _myTasks.sort(((a, b) => a.dueDate.isBefore(b.dueDate) ? 1 : 0));
    //If task is done sort it to the end of the list
    _myTasks.sort(((a, b) => a.isDone & !b.isDone ? 1 : -1));
  }

  Future loadTasks() async {
    _myTasks = [];
    int count = 0;
    await firebaseTask.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Task task = Task.fromJson(doc.data() as Map<String, dynamic>);
        task.id = doc.id;
        _myTasks.add(task);
        count++;
        // print(
        //     "${task.id}, ${task.title}, ${task.description}, ${task.dueDate}, ${task.isDone}, ${task.markedDoneDate}");
      });
    });
    sortTasks();
    notifyListeners();
    print('$count Tasks loaded');
  }

  //delete task from firebase
  Future deleteTaskFromFirebase(Task task) async {
    await firebaseTask.doc(task.id).delete();
  }

  // update task in firebase
  Future updateTaskInFirebase(Task task) async {
    await firebaseTask.doc(task.id).update(task.toJson());
    // loadTasks();
    for (int i = 0; i < _myTasks.length; i++) {
      // Check and replace task with same ID
      if (_myTasks[i].id == task.id) {
        _myTasks[i] = task;
      }
    }
    sortTasks();
    notifyListeners();
  }
}
