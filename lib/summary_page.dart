import 'package:finanse/balance_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryPage extends StatelessWidget {
  final List<Expense> expenses;
  final List<Salary> salaries;

  const SummaryPage({
    super.key,
    required this.expenses,
    required this.salaries,
  });

  // Map to store monthly totals for the current month only
  Map<String, double> get monthlyTotals {
    Map<String, double> totals = {};
    DateTime today =
        DateTime.now(); // Current date: June 5, 2025, 01:59 PM CEST
    final currentMonthAbbr = DateFormat(
      'MMM',
    ).format(today).toLowerCase().substring(0, 3);
    totals[currentMonthAbbr] = 0.0;

    final dateFormat = DateFormat(
      'dd.MM.yyyy',
    ); // Define the date format for parsing (DD.MM.YYYY)

    for (var salary in salaries) {
      try {
        final parsedDate = dateFormat.parse(
          salary.date,
        ); // Parse DD.MM.YYYY format
        final month = DateFormat(
          'MMM',
        ).format(parsedDate).toLowerCase().substring(0, 3);
        if (month == currentMonthAbbr)
          totals[month] = (totals[month]! + salary.amount);
      } catch (e) {
        print('Error parsing salary date $salary.date: $e');
      }
    }
    for (var expense in expenses) {
      try {
        final parsedDate = dateFormat.parse(
          expense.date,
        ); // Parse DD.MM.YYYY format
        final month = DateFormat(
          'MMM',
        ).format(parsedDate).toLowerCase().substring(0, 3);
        if (month == currentMonthAbbr)
          totals[month] = (totals[month]! - expense.amount);
      } catch (e) {
        print('Error parsing expense date $expense.date: $e');
      }
    }

    return totals;
  }

  // Map to store expenses by category for the current month
  Map<String, double> get expensesByCategory {
    Map<String, double> categoryTotals = {};
    DateTime today = DateTime.now();
    final currentMonthAbbr = DateFormat(
      'MMM',
    ).format(today).toLowerCase().substring(0, 3);
    final dateFormat = DateFormat('dd.MM.yyyy');

    for (var expense in expenses) {
      try {
        final parsedDate = dateFormat.parse(expense.date);
        final month = DateFormat(
          'MMM',
        ).format(parsedDate).toLowerCase().substring(0, 3);
        if (month == currentMonthAbbr) {
          categoryTotals[expense.category] =
              (categoryTotals[expense.category] ?? 0.0) + expense.amount;
        }
      } catch (e) {
        print('Error parsing expense date for category $expense.date: $e');
      }
    }

    return categoryTotals;
  }

  Widget _tableCell(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary of expenses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Summary of the current month:'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Table(
                  border: TableBorder.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  children: [
                    TableRow(
                      children: [
                        _tableCell('Month', context),
                        _tableCell('Balance (€)', context),
                      ],
                    ),
                    ...monthlyTotals.entries.map(
                      (entry) => TableRow(
                        children: [
                          _tableCell(entry.key, context),
                          _tableCell(entry.value.toStringAsFixed(2), context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Expenses by category (current month):'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    expensesByCategory.isEmpty
                        ? const Text(
                          'No expenses for the current month.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
                        : Table(
                          border: TableBorder.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.5),
                          ),
                          children: [
                            TableRow(
                              children: [
                                _tableCell('Category', context),
                                _tableCell('Amount (€)', context),
                              ],
                            ),
                            ...expensesByCategory.entries.map(
                              (entry) => TableRow(
                                children: [
                                  _tableCell(entry.key, context),
                                  _tableCell(
                                    entry.value.toStringAsFixed(2),
                                    context,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
