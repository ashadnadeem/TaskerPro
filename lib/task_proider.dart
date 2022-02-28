import 'package:flutter/foundation.dart';
import 'package:taskerpro/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _myTasks = [];

  // List<Task> getTasks() {
  //   return _myTasks;
  // }

  List<Task> get tasks => _myTasks; //inline function for getter

  void addTask(Task task) {
    _myTasks.add(task);
    sortTasks();
    notifyListeners();
  }

  void markTaskDone(Task task) {
    int index = _myTasks.indexOf(task);
    _myTasks[index].isDone = true;
    _myTasks[index].markedDoneDate = DateTime.now();
    sortTasks();
    notifyListeners();
  }

  void markTaskNotDone(Task task) {
    int index = _myTasks.indexOf(task);
    _myTasks[index].isDone = false;
    _myTasks[index].markedDoneDate = null;
    sortTasks();
    notifyListeners();
  }

  void removeTask(Task task) {
    _myTasks.remove(task);
    notifyListeners();
  }

  void sortTasks() {
    //Sort by dueDates , due Before comes first
    _myTasks.sort(((a, b) => a.dueDate.compareTo(b.dueDate)));
    // _myTasks.sort(((a, b) => a.dueDate.isBefore(b.dueDate) ? 1 : 0));
    //If task is done sort it to the end of the list
    _myTasks.sort(((a, b) => a.isDone & !b.isDone ? 1 : -1));
  }
}
