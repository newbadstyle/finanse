import 'package:flutter/material.dart';
import 'balance_page.dart';

class ReceiptPage extends StatefulWidget {
  final Function(Salary) onAddSalary;

  const ReceiptPage({super.key, required this.onAddSalary});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  void _submitSalary() {
    final amount = double.tryParse(_amountController.text);
    final company = _companyController.text.trim();
    final date = DateTime.now().toIso8601String();

    if (amount != null && company.isNotEmpty) {
      final salary = Salary(company: company, amount: amount, date: date);
      widget.onAddSalary(salary);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wypłata zapisana')));

      Future.delayed(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uzupełnij poprawnie wszystkie pola')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj wypłatę"),
        backgroundColor: const Color(0xFF2A6F5B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Nazwa firmy',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Kwota wypłaty',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitSalary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A6F5B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Zapisz wypłatę'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
