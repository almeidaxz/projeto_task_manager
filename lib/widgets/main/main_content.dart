import 'package:flutter/material.dart';
import 'package:task_manager/models/reminder/reminder.dart';
import 'package:task_manager/models/task/task.dart';
import 'package:task_manager/widgets/main/reminder_list.dart';
import 'package:task_manager/widgets/main/task_list.dart';

class MainContent extends StatelessWidget {
  final String? userName;
  final TabController tabController;
  final TextEditingController filterController;
  final bool isDarkTheme;
  final List<Task> tasks;
  final List<Reminder> reminders;
  final Function(int index, bool isTaskTab) toggleSelection;
  final Function(Task task, int index, bool isTaskTab) toggleDone;
  final Function(bool isTaskTab) addItem;
  final Function(bool isTaskTab) editItem;
  final Function(bool isTaskTab) deleteItem;
  final Function() toggleMenu;
  final Function(bool isTaskTab) filterLists;

  const MainContent({
    super.key,
    required this.userName,
    required this.tabController,
    required this.filterController,
    required this.isDarkTheme,
    required this.tasks,
    required this.reminders,
    required this.toggleSelection,
    required this.toggleDone,
    required this.addItem,
    required this.editItem,
    required this.deleteItem,
    required this.toggleMenu,
    required this.filterLists,
  });

  @override
  Widget build(BuildContext context) {
    int selectedCount = tabController.index == 0
        ? tasks.where((task) => task.isSelected).length
        : reminders.where((reminder) => reminder.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
            "$userName - ${tabController.index == 0 ? "Tarefas" : "Lembretes"}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: toggleMenu,
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          onTap: (index) {
            tasks.forEach((task) => task.isSelected = false);
            reminders.forEach((reminder) => reminder.isSelected = false);
          },
          tabs: const [
            Tab(text: "Tarefas"),
            Tab(text: "Lembretes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          TaskList(
            tasks: tasks,
            onToggleSelection: toggleSelection,
            onToggleDone: toggleDone,
            isDarkTheme: isDarkTheme,
            isTaskTab: tabController.index == 0,
          ),
          RemindersList(
            reminders: reminders,
            isTaskTab: tabController.index == 0,
            onTap: toggleSelection,
            isDarkTheme: isDarkTheme,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildFloatingActionButtons(selectedCount, context),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
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
                controller: filterController,
                style: const TextStyle(height: 1.0),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(
                      'Nome ou descrição ${tabController.index == 0 ? "da tarefa" : "do lembrete"}'),
                ),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () => filterLists(tabController.index == 0),
              icon: const Icon(Icons.search_rounded),
              label: const Text("Filtrar"),
              heroTag: const Key('filtrarButton'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFloatingActionButtons(
      int selectedCount, BuildContext context) {
    if (selectedCount == 0) {
      return [
        FloatingActionButton.extended(
          onPressed: () => addItem(tabController.index == 0),
          icon: const Icon(Icons.add),
          label:
              Text(tabController.index == 0 ? 'Nova Tarefa' : 'Novo Lembrete'),
          heroTag: const Key('addButton'),
        ),
      ];
    } else if (selectedCount == 1) {
      return [
        FloatingActionButton.extended(
          onPressed: () => editItem(tabController.index == 0),
          icon: const Icon(Icons.edit),
          label: const Text("Editar"),
          heroTag: const Key('editButton'),
        ),
      ];
    } else {
      return [
        FloatingActionButton.extended(
          onPressed: () => _showDeleteDialog(context),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.delete),
          label: const Text("Excluir"),
          heroTag: const Key('deleteButton'),
        ),
      ];
    }
  }

  void _showDeleteDialog(BuildContext context) {
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
              onPressed: () {
                deleteItem(tabController.index == 0);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
