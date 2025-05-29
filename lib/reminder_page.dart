import 'package:flutter/material.dart';

class Reminder {
  final String title;
  final String date;
  final String time;

  Reminder({required this.title, required this.date, required this.time});
}

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedCategory;

  final List<String> categories = [
    'Shopping',
    'Bills & Utility',
    'Education',
    'Food',
  ];
  List<Reminder> reminders = [
    Reminder(title: 'School Fee', date: '10/08/2023', time: '5:30 AM'),
    Reminder(title: 'Water Tax', date: '10/08/2023', time: '5:30 AM'),
    Reminder(title: 'Washing Machine', date: '10/08/2023', time: '5:30 AM'),
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        backgroundColor: const Color(0xFF2A6F5B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (e.g., 18/08/2023)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items:
                  categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time (e.g., 5:30 AM)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ListTile(
                    leading: const Icon(Icons.alarm, color: Color(0xFF2A6F5B)),
                    title: Text(reminder.title),
                    subtitle: Text('${reminder.date} ${reminder.time}'),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed: () {
                  if (_selectedCategory != null &&
                      _dateController.text.isNotEmpty &&
                      _timeController.text.isNotEmpty) {
                    setState(() {
                      reminders.add(
                        Reminder(
                          title: _selectedCategory!,
                          date: _dateController.text,
                          time: _timeController.text,
                        ),
                      );
                    });
                    _dateController.clear();
                    _timeController.clear();
                    _selectedCategory = null;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
                child: const Text('Add Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
