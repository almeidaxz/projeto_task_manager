import 'package:flutter/material.dart';
import 'package:task_manager/add_reminder/add_reminder.dart';
import 'package:task_manager/add_task/add_task.dart';

void main() {
  runApp(const TaskReminderApp());
}

class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String buttonText = "Nova Tarefa";
  String titleText = "Tarefas";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      buttonText = _tabController.index == 0 ? "Nova Tarefa" : "Novo Lembrete";
      titleText = _tabController.index == 0 ? "Tarefas" : "Lembretes";
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int current_tab = _tabController.index;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lucas - $titleText"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tarefas'),
            Tab(text: 'Lembretes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TaskTab(),
          ReminderTab(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        current_tab == 0 ? AddTaskPage() : AddReminderPage()));
          },
          child: Padding(
              padding: const EdgeInsets.all(16.0), child: Text(buttonText)),
        ),
      ),
    );
  }
}

class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Tarefa n1'),
          subtitle: const Text('Terminar protótipo até dia 20'),
          trailing: Checkbox(value: false, onChanged: (value) {}),
        ),
        ListTile(
          title: const Text('List item'),
          subtitle: const Text('Lorem ipsum dolor sit amet'),
          trailing: Checkbox(value: false, onChanged: (value) {}),
        ),
        // Adicione mais ListTile conforme necessário
      ],
    );
  }
}

class ReminderTab extends StatelessWidget {
  const ReminderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.warning_amber_rounded, color: Colors.red),
          title: Text('Terminar Protótipo'),
          subtitle: Text('12/10/2023'),
        ),
        ListTile(
          leading: Icon(Icons.tag_faces_sharp, color: Colors.green),
          title: Text('Pagar MEI'),
          subtitle: Text('10/10/2023'),
        ),
        // Adicione mais ListTile conforme necessário
      ],
    );
  }
}
