import 'package:flutter/material.dart';
import 'package:todoapp/core/database_helper.dart';
import 'package:todoapp/ui/shared/styles/text_styles.dart';
import '../../../core/model/task.dart';

class CustomeCard extends StatefulWidget {
  const CustomeCard({
    Key? key,
    required this.keys,
    required this.taskName,
    required this.taskIsSuccess,
  }) : super(key: key);

  final int keys;
  final String taskName;
  final bool taskIsSuccess;

  @override
  // ignore: library_private_types_in_public_api
  _CustomeCardState createState() => _CustomeCardState();
}

class _CustomeCardState extends State<CustomeCard> {
  bool isChecked = false;
  Color successColor = Colors.green;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    isChecked = widget.taskIsSuccess;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isChecked ? successColor : Colors.red,
      elevation: 20,
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: (value) async {
            setState(() {
              isChecked = value!;
            });
            if (isChecked) {
              Task task = Task(
                id: widget.keys,
                taskName: widget.taskName,
                taskIsSuccess: true,
              );
              await databaseHelper.updateTask(task);
            } else {
              Task task = Task(
                id: widget.keys,
                taskName: widget.taskName,
                taskIsSuccess: false,
              );
              await databaseHelper.updateTask(task);
            }
          },
        ),
        title: Text(widget.taskName, style: titleStyle),
      ),
    );
  }
}
