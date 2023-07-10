class Task {
  String? taskName;
  bool? taskIsSuccess;
  int? id;

  Task({this.id, required this.taskName, required this.taskIsSuccess});

  Task.fromJson(Map<String, dynamic> json) {
    taskName = json['taskName'];
    taskIsSuccess = json['taskIsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskName'] = taskName;
    data['taskIsSuccess'] = taskIsSuccess;
    return data;
  }
}

class TaskList {
  List<Task>? tasks = [];
  TaskList.fromJsonList(Map value) {
    value.forEach((key, value) {
      var task = Task.fromJson(value);
      task.id = int.parse(key);
      tasks?.add(task);
    });
  }
}
