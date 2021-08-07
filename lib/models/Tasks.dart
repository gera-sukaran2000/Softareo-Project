import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:softareo/models/HttpException.dart';

class Task with ChangeNotifier {
  final String id;
  var task;

  Task({@required this.id, @required this.task});
}

class Tasks with ChangeNotifier {
  List<Task> _tasks = [
    // Task(
    //   id: DateTime.now().toString(),
    //   task: 'This is testing',
    // ),
    // Task(
    //   id: DateTime.now().toString(),
    //   task: 'The one is for testing',
    // ),
    // Task(
    //   id: DateTime.now().toString(),
    //   task: 'The one is for testing',
    // ),
    // Task(
    //   id: DateTime.now().toString(),
    //   task: 'the second one for testing',
    // ),
    // Task(
    //   id: DateTime.now().toString(),
    //   task: 'the second one for testing',
    // ),
  ];

  List<Task> _completedTasks = [];

  List<Task> get myTasksList {
    return [..._tasks];
  }

  List<Task> get completedTasks {
    return [..._completedTasks];
  }

  Future<void> fetchAndSetTasks() async {
    final url = Uri.parse(
        'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/tasks.json');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<Task> loadedTasks = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((taskId, taskObj) {
      loadedTasks.add(Task(
        id: taskId,
        task: taskObj['task'],
      ));
    });
    _tasks = loadedTasks;
    notifyListeners();
  }

  Future<void> addToCompletedTask(String taskid) async {
    final url = Uri.parse(
        'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/tasks/$taskid.json');
    int index = _tasks.indexWhere((element) => element.id == taskid);
    final elementRemovedFromTask = _tasks[index];
    _tasks.removeAt(index);
    notifyListeners();
    await http.delete(url); //still have to add error handling here
    addingFromUrL(elementRemovedFromTask);
  }

  Future<void> addingFromUrL(final elementCompleted) async {
    final url = Uri.parse(
        'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/CompletedTasks.json');
    final response = await http.post(url,
        body: json.encode({
          'task': elementCompleted.task,
        }));

    Task completedtask = new Task(
      id: json.decode(response.body)['name'],
      task: elementCompleted.task,
    );
    _completedTasks.add(completedtask);
    notifyListeners();
  }

  Future<void> addtoTask(Task task) async {
    final url = Uri.parse(
        'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/tasks.json');
    final response = await http.post(url,
        body: json.encode({
          'task': task.task,
        }));
    task = new Task(
      id: json.decode(response.body)['name'],
      task: task.task,
    );
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> removeTask(String tskid) async {
    final url = Uri.parse(
        'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/tasks/$tskid.json');
    final _index = _tasks.indexWhere((element) => element.id == tskid);
    var removedElement = _tasks[_index];
    _tasks.removeAt(_index);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _tasks.insert(_index, removedElement);
      notifyListeners();
      throw HttpException('could not delete');
    }
    removedElement = null;
  }

  Future<void> changeData(String tskid, Task newTask) async {
    final prodIndex = _tasks.indexWhere((element) => element.id == tskid);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://softtodo-59d9a-default-rtdb.asia-southeast1.firebasedatabase.app/tasks/$tskid.json');
      await http.patch(url,
          body: json.encode({
            'task': newTask.task,
          }));
      _tasks[prodIndex] = newTask;
      notifyListeners();
    }
  }
}
