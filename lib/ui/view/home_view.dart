import 'package:flutter/material.dart';
import 'package:todoapp/core/database_helper.dart';
import 'package:todoapp/ui/shared/widgets/custome_card.dart';
import 'package:todoapp/ui/view/add_task_view.dart';
import '../../core/model/task.dart';
import '../shared/styles/text_styles.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TODO LIST'),
      ),
      floatingActionButton: _buildFabButton(),
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Task>>(
              future: databaseHelper.getTasks(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      taskList = snapshot.data!;
                      return _buildListView();
                    }
                    return const Center(
                      child: Text(
                        "TASK BULUNAMADI",
                        style: titleStyle,
                      ),
                    );

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemBuilder: (context, index) => _buildDismissableCard(taskList[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: taskList.length,
    );
  }

  Widget _buildDismissableCard(Task task) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (dismissDirection) async {
        if (task.id != null) {
          await databaseHelper.removeTask(task.id!);
          setState(() {
            taskList.remove(task);
          });
        }
      },
      child: CustomeCard(
        taskName: task.taskName.toString(),
        taskIsSuccess: task.taskIsSuccess == true ? true : false,
        keys: task.id!,
      ),
    );
  }

  Widget _buildFabButton() {
    return FloatingActionButton(
      onPressed: _fabPressed,
      child: const Icon(Icons.add),
    );
  }

  void _fabPressed() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (context) => _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
            thickness: 3,
            endIndent: 50,
            indent: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: const Size.fromWidth(200),
            ),
            child: const Text("Task Ekle"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddTaskView(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
