import 'dart:convert';

import 'package:flutter/material.dart';
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
    const userId = 1;
    Future<void> _addReminder() async {
      // Lógica para salvar a tarefa editada
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final due_date = dateController.text.trim();
      final due_time = timeController.text.trim();

      if (name.isEmpty || due_date.isEmpty || due_time.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, preencha os campos obrigatórios.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final reminderData = {
        "user_id": userId.toString(),
        "name": name,
        "description": description,
        "due_date": due_date,
        "due_time": due_time.split(" ")[0],
      };

      final response = await client.post('/reminder', reminderData);
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
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
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
                if (pickedDate != null) {
                  dateController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
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
                  onPressed: _addReminder,
                  extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  icon: const Icon(Icons.add_alarm_rounded),
                  label: const Text("Adicionar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
