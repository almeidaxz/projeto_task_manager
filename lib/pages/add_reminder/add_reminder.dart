import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/clients/base_client.dart';

class AddReminderPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  AddReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    BaseClient client = BaseClient();
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? userId = '';

    getStorage() async {
      userId = await storage.read(key: 'id').then((value) => value);
    }

    getStorage();

    Future<void> addReminder() async {
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final dueDate = dateController.text.trim();
      final dueTime = timeController.text.trim();

      if (name.isEmpty || dueDate.isEmpty || dueTime.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, preencha os campos obrigatórios.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final reminderData = {
        "user_id": userId,
        "name": name,
        "description": description,
        "due_date": dueDate,
        "due_time": dueTime.split(" ")[0],
      };

      final response =
          await client.post('/reminder', reminderData, needToken: true);
      Map<String, dynamic> data = jsonDecode(response);
      if (!data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['errors'][0]),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1, milliseconds: 500),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lembrete adicionado com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Lembrete"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('addNameReminderField'),
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('addDescriptionReminderField'),
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('addDateReminderField'),
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Data*',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                );
                dateController.text =
                    DateFormat('dd/MM/yyyy').format(pickedDate!);
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('addTimeReminderField'),
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Hora*',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  timeController.text = DateFormat('HH:mm').format(
                      DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute));
                }
              },
              readOnly: true,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: addReminder,
                  extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  icon: const Icon(Icons.add_alarm_rounded),
                  label: const Text("Adicionar"),
                  heroTag: const Key('addReminderButton'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
