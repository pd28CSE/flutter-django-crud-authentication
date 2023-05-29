import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

import './list_screen.dart';
import './login_screen.dart';
import './favorite_screen.dart';
import './complete_screen.dart';

enum SelectedOptions { logout }

class HomeScreen extends StatelessWidget {
  static const String routeName = '/list-screen';
  const HomeScreen({super.key});

  Future<bool?> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          icon: const Icon(Icons.logout),
          title: const Text('Are you sure?'),
          content: const Text('Are you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(true);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider = Provider.of<TaskProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Tasks'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<SelectedOptions>(
              onSelected: (SelectedOptions selectedOptions) {
                switch (selectedOptions) {
                  case SelectedOptions.logout:
                    showLogoutDialog(context).then((value) {
                      if (value == true) {
                        userTaskProvider.logout();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                      }
                    });
                }
              },
              itemBuilder: (cntxt) {
                return [
                  const PopupMenuItem<SelectedOptions>(
                    value: SelectedOptions.logout,
                    child: Text('Logout'),
                  ),
                ];
              },
              child: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            splashBorderRadius: BorderRadius.circular(50),
            indicatorColor: Colors.amber,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(
                text: 'Task List',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Favorite Task',
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              Tab(
                text: 'Completed Task',
                icon: Icon(Icons.done),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListScreen(),
            FavoriteScreen(),
            CompleteScreen(),
          ],
        ),
      ),
    );
  }
}
