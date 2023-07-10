import 'package:flutter/material.dart';
import 'package:todoapp/core/model/task.dart';

import '../../core/database_helper.dart';
import '../shared/styles/textformfield_decoration.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({Key? key}) : super(key: key);

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

TextEditingController nameController = TextEditingController();

class _AddTaskViewState extends State<AddTaskView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? validator(String? val) {
    if (val!.isEmpty) {
      return 'Lütfen Boş Bırakmayınız';
    }
    return null;
  }

  @override
  void initState() {
    nameController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Ekle'),
      ),
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(20),
        child: Form(
          //autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text("Lütfen Task Ekleyiniz",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          validator: validator,
                          decoration: buildInputDecoration('Name'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.red,
                    fixedSize: const Size.fromWidth(200),
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    DatabaseHelper databaseHelper = DatabaseHelper();
                    var task = Task(
                        taskName: nameController.text, taskIsSuccess: false);
                    await databaseHelper.addTask(task);
                    // ignore: use_build_context_synchronously
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Ürün Eklenmiştir"),
                              content: const Text("Ürün başarıyla eklendi"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            ));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text('Task Ekle'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
