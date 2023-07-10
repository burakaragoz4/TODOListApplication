import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'model/task.dart';

class ApiService {
  String? _baseUrl;
  static final ApiService _instance = ApiService.privateConstructor();

  ApiService.privateConstructor() {
    _baseUrl = "https://todoapp-4a075-default-rtdb.firebaseio.com/";
  }

  static ApiService getInstance() {
    // ignore: unnecessary_null_comparison
    if (_instance == null) {
      return ApiService.privateConstructor();
    }
    return _instance;
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse("${_baseUrl}tasks.json"),
    );
    final jsonResponse = jsonDecode(response.body);
    Logger().e(jsonResponse);
    switch (response.statusCode) {
      case HttpStatus.ok:
        var tasklist = TaskList.fromJsonList(jsonResponse);
        return tasklist.tasks!;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return [];
  }

  Future<void> addTask(Task task) async {
    final jsonBody = json.encode(task.toJson());
    final response = await http.post(
      Uri.parse("${_baseUrl}tasks.json"),
      body: jsonBody,
    );

    final jsonResponse = jsonDecode(response.body);

    Logger().e(jsonResponse);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonResponse;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return Future.error("Error");
  }

  Future<void> removeTask(String key) async {
    final response = await http.delete(
      Uri.parse("${_baseUrl}tasks/$key.json"),
    );
    final jsonResponse = jsonDecode(response.body);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonResponse;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return Future.error("Error");
  }

  Future<void> updateTask(
      String key, String taskName, bool taskIsSuccess) async {
    final response = await http.put(
      Uri.parse("${_baseUrl}tasks/$key.json"),
      body: json.encode({
        "taskName": taskName,
        "taskIsSuccess": taskIsSuccess,
      }),
    );
    final jsonResponse = JsonUtf8Encoder(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    throw Exception("Error");
  }
}
