import 'package:get/get.dart';
import 'package:todoapp/db/db_helper.dart';
import 'package:todoapp/models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
  var taskList = <Task>[].obs;
  // add Task
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get task
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  Future<void> markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}