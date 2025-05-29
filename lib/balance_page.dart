import 'package:finanse/app/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_expense_page.dart';
import 'reminder_page.dart';
import 'shopping_page.dart';
import 'receipt_page.dart';
import 'welcome_page.dart';

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
  const BalancePage({super.key});

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  int _selectedIndex = 0;
  List<Expense> expenses = [];
  List<Salary> salaries = [];
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  double get totalBalance {
    final totalExpenses = expenses.fold(0.0, (sum, e) => sum - e.amount);
    final totalSalaries = salaries.fold(0.0, (sum, s) => sum + s.amount);
    return totalExpenses + totalSalaries;
  }

  Future<void> _signOut(BuildContext context) async {
    await authService.value.signOut();
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

    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => _getSelectedPage()),
    );
  }

  void _addSalary(Salary salary) {
    setState(() {
      salaries.add(salary);
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
                      subtitle: Text(expense.date),
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
      1: ReceiptPage(onAddSalary: _addSalary),
      2: AddExpensePage(
        onSave: (expense) {
          setState(() {
            expenses.add(expense);
          });
        },
      ),
      3: const ReminderPage(),
      4: const ShoppingPage(),
    };

    return content[_selectedIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState != null &&
            _navigatorKey.currentState!.canPop()) {
          _navigatorKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar:
            _selectedIndex == 0
                ? AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text('Stan Konta'),
                  backgroundColor: const Color(0xFF2A6F5B),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => _signOut(context),
                    ),
                  ],
                )
                : null,
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => _getSelectedPage());
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Receipt',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Reminder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF2A6F5B),
          unselectedItemColor: const Color(0xFF2A6F5B).withOpacity(0.6),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
