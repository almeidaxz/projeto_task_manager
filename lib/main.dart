import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/reminder/reminder.dart';
import 'package:task_manager/models/task/task.dart';
import 'package:task_manager/pages/add_reminder/add_reminder.dart';
import 'package:task_manager/pages/add_task/add_task.dart';
import 'package:task_manager/pages/edit_profile/edit_profile.dart';
import 'package:task_manager/pages/edit_reminder/edit_reminder.dart';
import 'package:task_manager/pages/edit_task/edit_task.dart';
import 'package:task_manager/clients/base_client.dart';
import 'package:task_manager/pages/login/login.dart';
import 'package:task_manager/utils/format_date.dart';
import 'dart:convert';

import 'package:task_manager/theme/theme_provider.dart';
import 'package:task_manager/widgets/main/reminder_list.dart';
import 'package:task_manager/widgets/main/task_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeMode,
      home: const LoginPage(),
    );
  }
}

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  TaskManagerPageState createState() => TaskManagerPageState();
}

class TaskManagerPageState extends State<TaskManagerPage>
    with SingleTickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  BaseClient client = BaseClient();

  String? userName = '';
  String? userEmail = '';
  String? userId = '';
  List<Task> tasks = [];
  List<Reminder> reminders = [];
  List<Task> originalTasks = [];
  List<Reminder> originalReminders = [];

  late TabController _tabController;
  late final TextEditingController _filterController = TextEditingController();

  bool isMenuOpen = false;
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    readStorage();
    getLists();
    _tabController = TabController(length: 2, vsync: this);
  }

  getLists() async {
    var response = await client.get('/main');
    Map<String, dynamic> data = jsonDecode(response);
    if (data['statusCode'] == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${data['errors'][0]}"),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 800),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      setState(() {
        tasks = data['response']['tasks']!
            .map<Task>((task) => Task(
                  user_id: task['user_id'],
                  id: task['id'],
                  name: task['name'],
                  description: task['description'],
                  categories: task['categories'],
                  due_date: task['due_date'],
                  due_time: task['due_time'],
                  is_done: task['is_done'],
                ))
            .toList();
        tasks.sort((Task a, Task b) {
          return a.is_done ? 1 : -1;
        });
        originalTasks = tasks;

        reminders = data['response']['reminders']!
            .map<Reminder>((reminder) => Reminder(
                  user_id: reminder['user_id'],
                  id: reminder['id'],
                  name: reminder['name'],
                  description: reminder['description'],
                  due_date: reminder['due_date'],
                  due_time: reminder['due_time'],
                  isOverdue: formatDate(
                          "${reminder['due_date']} ${reminder['due_time']}")
                      .isBefore(DateTime.now()),
                ))
            .toList();

        reminders.sort((Reminder a, Reminder b) {
          return a.isOverdue ? -1 : 1;
        });
        originalReminders = reminders;
      });
    }
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _toggleTheme() {
    setState(() {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      isDarkTheme = !isDarkTheme;
    });
  }

  void _toggleSelection(int index, bool isTaskTab) {
    setState(() {
      if (isTaskTab) {
        tasks[index].isSelected = !tasks[index].isSelected;
      } else {
        reminders[index].isSelected = !reminders[index].isSelected;
      }
    });
  }

  Future<void> _toggleDone(Task task, int index, bool isTaskTab) async {
    if (!isTaskTab) return;
    task.is_done = !task.is_done;
    final taskData = {
      "user_id": task.user_id.toString(),
      "name": task.name,
      "description": task.description,
      "categories": task.categories,
      "due_date": task.due_date,
      "due_time": task.due_time.split(" ")[0],
      "is_done": task.is_done,
    };
    var response = await client.put('/task/${task.id}', taskData);
    Map<String, dynamic> data = jsonDecode(response);
    if (data['statusCode'] == 401) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
    if (!data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['errors'][0]),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1, milliseconds: 500),
        ),
      );
      setState(() {
        tasks[index].is_done = !tasks[index].is_done;
      });
    }
    Timer(
        const Duration(milliseconds: 200),
        () => setState(() {
              getLists();
            }));
  }

  readStorage() async {
    var stgName = await storage.read(key: 'name').then((value) => value);
    userName = stgName?.split(' ')[0];
  }

  void _filtrarListas(isTaskTab) {
    setState(() {
      if (isTaskTab && _filterController.text.isEmpty) {
        tasks = originalTasks;
      } else if (isTaskTab && _filterController.text.isNotEmpty) {
        tasks = originalTasks
            .where((task) =>
                task.name.contains(_filterController.text) ||
                task.description.contains(_filterController.text))
            .toList();
      } else if (!isTaskTab && _filterController.text.isEmpty) {
        reminders = originalReminders;
      } else {
        reminders = originalReminders
            .where((reminder) =>
                reminder.name.contains(_filterController.text) ||
                reminder.description.contains(_filterController.text))
            .toList();
      }
    });
    _filterController.text = '';
    Navigator.pop(context);
  }

  void _logout() async {
    await storage.delete(key: 'token').then((value) => value);
    await storage.delete(key: 'name').then((value) => value);
    await storage.delete(key: 'email').then((value) => value);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _editProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    ).then((_) {
      setState(() {
        readStorage();
      });
    });
  }

  void _add(bool isTaskTab) {
    if (isTaskTab) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTaskPage(),
        ),
      ).then((_) {
        setState(() {
          getLists();
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddReminderPage(),
        ),
      ).then((_) {
        setState(() {
          getLists();
        });
      });
    }
  }

  void _edit(bool isTaskTab) {
    if (isTaskTab) {
      final arg = tasks.firstWhere((task) => task.isSelected);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTaskPage(id: arg.id),
        ),
      ).then((_) {
        setState(() {
          getLists();
        });
      });
    } else {
      final arg = reminders.firstWhere((reminder) => reminder.isSelected);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditReminderPage(
            id: arg.id,
          ),
        ),
      ).then((_) {
        setState(() {
          getLists();
        });
      });
    }
  }

  void _delete(bool isTaskTab) async {
    List<int> idsList = [];
    if (isTaskTab) {
      List<Task> listToDelete = tasks.where((task) => task.isSelected).toList();
      idsList = listToDelete.map((item) => item.id).toList();
    } else {
      List<Reminder> listToDelete =
          reminders.where((task) => task.isSelected).toList();
      idsList = listToDelete.map((item) => item.id).toList();
    }

    var route = isTaskTab ? '/task' : '/reminder';
    var response = await client.delete(route, idsList);
    Map<String, dynamic> data = jsonDecode(response);
    if (data['statusCode'] == 401) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
    if (!data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['errors'][0]),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1, milliseconds: 500),
        ),
      );
    }
    Timer(
      const Duration(milliseconds: 200),
      () => setState(() {
        getLists();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_mainContent(context), _sideMenu(context)],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    int selectedCount = _tabController.index == 0
        ? tasks.where((task) => task.isSelected).length
        : reminders.where((reminder) => reminder.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
            "$userName - ${_tabController.index == 0 ? "Tarefas" : "Lembretes"}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                      title: const Text("Filtros"),
                      contentPadding: const EdgeInsets.all(24),
                      children: [
                        const Text(
                          'Filtrar por nome ou descrição:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextField(
                              controller: _filterController,
                              style: const TextStyle(
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text(
                                    'Nome ou descrição ${_tabController.index == 0 ? "da tarefa" : "do lembrete"}'),
                              ),
                            )),
                        FloatingActionButton.extended(
                          onPressed: () =>
                              _filtrarListas(_tabController.index == 0),
                          icon: const Icon(Icons.search_rounded),
                          extendedPadding:
                              const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          label: const Text("Filtrar"),
                          heroTag: const Key('filtrarButton'),
                        ),
                      ]);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _toggleMenu();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {
            tasks.map((task) => task.isSelected = false);
            reminders.map((reminder) => reminder.isSelected = false);
          }),
          tabs: const [
            Tab(text: "Tarefas"),
            Tab(text: "Lembretes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskList(
              tasks: tasks,
              onToggleSelection: _toggleSelection,
              onToggleDone: _toggleDone,
              isDarkTheme: isDarkTheme,
              isTaskTab: _tabController.index == 0),
          RemindersList(
            reminders: reminders,
            isTaskTab: _tabController.index == 0,
            onTap: _toggleSelection,
            isDarkTheme: isDarkTheme,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (selectedCount == 0)
              FloatingActionButton.extended(
                onPressed: () => _add(_tabController.index == 0),
                icon: const Icon(Icons.add),
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                label: Text(_tabController.index == 0
                    ? 'Nova Tarefa'
                    : 'Novo Lembrete'),
                heroTag: const Key('addButton'),
              ),
            if (selectedCount == 1)
              FloatingActionButton.extended(
                onPressed: () => _edit(_tabController.index == 0),
                icon: const Icon(Icons.edit),
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                label: const Text("Editar"),
                heroTag: const Key('editButton'),
              ),
            if (selectedCount > 0)
              FloatingActionButton.extended(
                onPressed: () => {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Excluir"),
                          content: const Text(
                              "Essa ação não poderá ser revertida. Deseja continuar?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: const Text("Excluir"),
                              onPressed: () => {
                                _delete(_tabController.index == 0),
                                Navigator.pop(context),
                              },
                            ),
                          ],
                        );
                      })
                },
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.delete),
                label: const Text("Excluir"),
                heroTag: const Key('deleteButton'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sideMenu(BuildContext context) {
    Color bgColor = !isDarkTheme
        ? const Color.fromARGB(255, 255, 241, 253)
        : const Color.fromARGB(255, 49, 49, 49);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: isMenuOpen ? 0 : -280,
      top: 0,
      bottom: 0,
      child: Container(
        width: 280,
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.only(top: 64),
              child: ListTile(
                title: const Text(
                  'Menu',
                  style: TextStyle(fontSize: 24),
                ),
                onTap: () {
                  _toggleMenu();
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Perfil',
              ),
              onTap: () {
                _editProfile();
              },
              leading: const Icon(Icons.account_circle_outlined,
                  size: 28, color: Colors.purpleAccent),
            ),
            ListTile(
              leading: Icon(
                isDarkTheme
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 26,
                color: isDarkTheme ? Colors.yellow : Colors.purple,
              ),
              title: const Text(
                'Alterar Tema',
              ),
              onTap: () {
                _toggleTheme();
              },
            ),
            ListTile(
              title: const Text(
                'Logout',
              ),
              onTap: () {
                _logout();
              },
              leading: const Icon(
                Icons.logout,
                size: 24,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
