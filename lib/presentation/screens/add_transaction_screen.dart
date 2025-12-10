import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/finance_provider.dart';
import '../../data/models/transaction_model.dart';
import '../../core/constants/app_colors.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'expense';
  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Salary',
    'Investment',
    'Health',
    'Entertainment',
    'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      if (_transactionType == 'income' && _selectedCategory == 'Food') {
         // Optionally reset category for income if it's strictly expense type categories, but for now allow all.
      }
      
      final newTransaction = TransactionModel(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        type: _transactionType,
        category: _selectedCategory,
        note: _noteController.text,
      );

      Provider.of<FinanceProvider>(context, listen: false).addTransaction(newTransaction);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Added!')),
      );

      // Clear form
      _titleController.clear();
      _amountController.clear();
      _noteController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _transactionType = 'expense';
        _selectedCategory = 'Food';
      });
      // Optionally navigate back if this was a pushed screen, but here it is a tab.
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Switcher
              SegmentedButton<String>(
                segments: const [
                   ButtonSegment(value: 'expense', label: Text('Expense'), icon: Icon(Icons.arrow_upward)),
                   ButtonSegment(value: 'income', label: Text('Income'), icon: Icon(Icons.arrow_downward)),
                ],
                selected: {_transactionType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _transactionType = newSelection.first;
                    // Auto-select Salary for income if simple logic desired, simplified here.
                    if (_transactionType == 'income') {
                       _selectedCategory = 'Salary'; 
                    } else {
                       _selectedCategory = 'Food';
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
                keyboardType: TextInputType.number,
                 validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(val) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (Optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: _submitData,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Add Transaction', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
