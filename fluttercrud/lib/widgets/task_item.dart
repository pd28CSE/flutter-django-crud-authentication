import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/taks.dart';
import '../screens/detail_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider = Provider.of<TaskProvider>(context);
    final Task task = Provider.of<Task>(context, listen: false);

    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          userTaskProvider.deleteTaskFromList(task.id);
        }
      },
      confirmDismiss: (direction) {
        return showDialog<bool>(
            context: context,
            builder: (cntxtx) {
              return AlertDialog(
                icon: const Icon(Icons.delete_forever),
                iconColor: Colors.red,
                title: const Text('Are you Confirm?'),
                content: const Text(
                  'You want to delete this task?',
                ),
                alignment: Alignment.center,
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        elevation: 5,
        child: ListTile(
          title: Text(task.task),
          subtitle: Text(
              DateFormat.yMMMMEEEEd().format(DateTime.parse(task.created))),
          leading: Consumer<Task>(
            builder: (cntxt, myTask, child) {
              return IconButton(
                onPressed: () {
                  myTask.togolFavoriteTask();
                  userTaskProvider.updateTaskFavorites(myTask.id);
                },
                icon: Icon(
                  myTask.isfavorite == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            },
          ),
          trailing: Consumer<Task>(
            builder: (context, _task, child) {
              return Checkbox(
                value: _task.iscomplete,
                activeColor: Colors.green,
                checkColor: Colors.white,
                onChanged: (value) {
                  _task.togolCompleteTask();
                  userTaskProvider.updateTaskCompleted(_task.id);
                },
              );
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
                  taskDetail: task,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
