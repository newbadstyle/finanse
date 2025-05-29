import 'package:flutter/material.dart';
import 'balance_page.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Expense> shoppingExpenses = [
      Expense(
        category: 'Clothes and watch',
        amount: 110.00,
        date: '18/08/2023',
      ),
      Expense(category: 'Laptop', amount: 1012.00, date: '18/08/2023'),
      Expense(category: 'Study table', amount: 4002.00, date: '18/08/2023'),
      Expense(category: 'Paints and brush', amount: 82.00, date: '18/08/2023'),
    ];

    final double totalShopping = shoppingExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
        backgroundColor: const Color(0xFF2A6F5B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '₹${totalShopping.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A6F5B),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('Chart Placeholder')),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingExpenses.length,
                itemBuilder: (context, index) {
                  final expense = shoppingExpenses[index];
                  return ListTile(
                    leading: const Icon(Icons.circle, color: Color(0xFF2A6F5B)),
                    title: Text(expense.category),
                    trailing: Text('₹${expense.amount.toStringAsFixed(2)}'),
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
