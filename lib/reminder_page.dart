import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Reminder {
  final String category;
  final double amount;
  final String date;
  final String description;

  Reminder({
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });
}

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  List<Reminder> reminders = [];

  final List<String> categories = [
    'Shopping',
    'Bills & Utility',
    'Education',
    'Food',
    'Other',
  ];

  late DatabaseReference remindersRef;
  Stream<DatabaseEvent>? remindersStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      remindersRef = FirebaseDatabase.instance
          .ref()
          .child('reminders')
          .child(user.uid);

      remindersStream = remindersRef.onValue;

      remindersStream!.listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        List<Reminder> newReminders = [];

        if (data != null) {
          data.forEach((key, value) {
            final category = value['category'] as String? ?? '';
            final amount = value['amount'] as num? ?? 0;
            final date = value['date'] as String? ?? '';
            final description = value['description'] as String? ?? '';

            newReminders.add(
              Reminder(
                category: category,
                amount: amount.toDouble(),
                date: date,
                description: description,
              ),
            );
          });
        }

        setState(() {
          reminders = newReminders;
        });
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitReminder() async {
    final date = _dateController.text.trim();
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text);
    final category = _selectedCategory;

    if (category != null &&
        amount != null &&
        date.isNotEmpty &&
        description.isNotEmpty) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You are not logged in')),
          );
          return;
        }

        final ref = FirebaseDatabase.instance
            .ref()
            .child('reminders')
            .child(user.uid);
        final newReminderRef = ref.push();

        await newReminderRef.set({
          'category': category,
          'amount': amount,
          'date': date,
          'description': description,
        });

        // Ukryj klawiaturę
        FocusScope.of(context).unfocus();

        // Wyczyść pola
        setState(() {
          _dateController.clear();
          _descriptionController.clear();
          _amountController.clear();
          _selectedCategory = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder has been saved')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Saving failed: $e')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Complete all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF2A6F5B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Due Date (e.g., 18/08/2023)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Reminder Category',
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
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
                onPressed: _submitReminder,
                child: const Text('Add Reminder'),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ListTile(
                    leading: const Icon(Icons.alarm, color: Color(0xFF2A6F5B)),
                    title: Text(
                      'Pay ${reminder.category} (€${reminder.amount.toStringAsFixed(2)})',
                    ),
                    subtitle: Text(
                      'Due: ${reminder.date}${reminder.description.isNotEmpty ? ' - ${reminder.description}' : ''}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
