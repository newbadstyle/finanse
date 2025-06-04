import 'package:flutter/material.dart';
import 'balance_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReceiptPage extends StatefulWidget {
  final Function(Salary) onAddSalary;

  const ReceiptPage({super.key, required this.onAddSalary});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  void _submitSalary() async {
    final amount = double.tryParse(_amountController.text);
    final company = _companyController.text.trim();
    final date = DateTime.now().toIso8601String();

    if (amount != null && company.isNotEmpty) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to continue')),
          );
          return;
        }

        final ref = FirebaseDatabase.instance
            .ref()
            .child('payments')
            .child(user.uid);
        final newSalaryRef = ref.push();

        await newSalaryRef.set({
          'company': company,
          'amount': amount,
          'date': date,
        });

        // Ukryj klawiaturę
        FocusScope.of(context).unfocus();

        // Wyczyść pola
        _companyController.clear();
        _amountController.clear();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment saved')));
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
        title: const Text("Add payout"),
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
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Payout amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(300, 40),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _submitSalary,
                    child: const Text(' Save Payout'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
