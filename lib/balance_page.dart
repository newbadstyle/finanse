import 'package:finanse/app/auth_service.dart';
import 'package:flutter/material.dart';
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

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  int _selectedIndex = 0;
  List<Expense> expenses = [];
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  double get totalBalance =>
      expenses.fold(0.0, (sum, expense) => sum + expense.amount);

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
    _navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => _getSelectedPage()),
    );
  }

  Widget _getSelectedPage() {
    final content = {
      0: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Monthly Expenses', style: TextStyle(color: Colors.black)),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    leading: const Icon(Icons.circle),
                    title: Text(expense.category),
                    trailing: Text('₹${expense.amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      1: const ReceiptPage(),
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

    return content[_selectedIndex] ?? content[0]!;
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
                  title: const Text('Home'),
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
