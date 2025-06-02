import 'package:finanse/app/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'add_expense_page.dart';
import 'reminder_page.dart';
import 'receipt_page.dart';
import 'welcome_page.dart';
import 'settings_page.dart';
import 'theme_provider.dart';

class Expense {
  final String category;
  final double amount;
  final String date;
  final String description;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    this.description = '',
  });
}

class Salary {
  final String company;
  final double amount;
  final String date;

  Salary({required this.company, required this.amount, required this.date});
}

class BalancePage extends StatefulWidget {
  final ThemeProvider themeProvider;

  const BalancePage({super.key, required this.themeProvider});

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  int _selectedIndex = 0;
  List<Expense> expenses = [];
  List<Salary> salaries = [];

  late DatabaseReference paymentsRef;
  late DatabaseReference expensesRef;
  Stream<DatabaseEvent>? paymentsStream;
  Stream<DatabaseEvent>? expensesStream;

  double get totalBalance {
    final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final totalSalaries = salaries.fold(0.0, (sum, s) => sum + s.amount);
    return totalSalaries - totalExpenses;
  }

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      paymentsRef = FirebaseDatabase.instance
          .ref()
          .child('payments')
          .child(user.uid);
      expensesRef = FirebaseDatabase.instance
          .ref()
          .child('expenses')
          .child(user.uid);

      paymentsStream = paymentsRef.onValue;
      expensesStream = expensesRef.onValue;

      paymentsStream!.listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        List<Salary> newSalaries = [];

        if (data != null) {
          data.forEach((key, value) {
            final company = value['company'] as String? ?? '';
            final amount = value['amount'] as num? ?? 0;
            final date = value['date'] as String? ?? '';

            newSalaries.add(
              Salary(company: company, amount: amount.toDouble(), date: date),
            );
          });
        }

        setState(() {
          salaries = newSalaries;
        });
      });

      expensesStream!.listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        List<Expense> newExpenses = [];

        if (data != null) {
          data.forEach((key, value) {
            final category = value['category'] as String? ?? '';
            final amount = value['amount'] as num? ?? 0;
            final date = value['date'] as String? ?? '';
            final description = value['description'] as String? ?? '';

            newExpenses.add(
              Expense(
                category: category,
                amount: amount.toDouble(),
                date: date,
                description: description,
              ),
            );
          });
        }

        setState(() {
          expenses = newExpenses;
        });
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await authService.value.signOut();
    setState(() {
      salaries.clear();
      expenses.clear();
    });
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    final content = {
      0: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '€${totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A6F5B),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Historia:'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ...salaries.map(
                    (salary) => ListTile(
                      leading: const Icon(
                        Icons.arrow_downward,
                        color: Colors.green,
                      ),
                      title: Text('Wypłata: ${salary.company}'),
                      subtitle: Text(
                        DateFormat.yMd().format(DateTime.parse(salary.date)),
                      ),
                      trailing: Text(
                        '+€${salary.amount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  ...expenses.map(
                    (expense) => ListTile(
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: Colors.red,
                      ),
                      title: Text(expense.category),
                      subtitle: Text(
                        '${expense.date}${expense.description.isNotEmpty ? ' - ${expense.description}' : ''}',
                      ),
                      trailing: Text(
                        '-€${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      1: ReceiptPage(onAddSalary: (salary) {}),
      2: const AddExpensePage(),
      3: const ReminderPage(),
      4: SettingsPage(themeProvider: widget.themeProvider),
    };

    return content[_selectedIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _selectedIndex == 0
              ? AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text('Stan Konta'),
                backgroundColor: const Color(0xFF2A6F5B),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _signOut(context),
                  ),
                ],
              )
              : null,
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: 'Deposits',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2A6F5B),
        unselectedItemColor: const Color(0xFF2A6F5B).withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }
}
