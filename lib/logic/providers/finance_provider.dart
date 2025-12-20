import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/goal_model.dart';

class FinanceProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  List<GoalModel> _goals = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get currentMonthExpense {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == 'expense' &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get balance => totalIncome - totalExpense;

  FinanceProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await DatabaseHelper.instance.readAllTransactions();
      _goals = await DatabaseHelper.instance.readAllGoals();
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.createTransaction(transaction);
    await fetchData();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await fetchData();
  }

  Future<void> addGoal(GoalModel goal) async {
    await DatabaseHelper.instance.createGoal(goal);
    await fetchData();
  }

    Future<void> deleteGoal(int id) async {
    await DatabaseHelper.instance.deleteGoal(id);
    await fetchData();
  }

  // Simple Insight Logic
  String getDailyTip() {
    if (totalExpense > totalIncome * 0.8 && totalIncome > 0) {
      return "Warning: You have spent over 80% of your income!";
    } else if (_transactions.isEmpty) {
      return "Start tracking your expenses to get insights!";
    } else {
      return "You are doing great! Keep saving.";
    }
  }

  Future<void> resetData() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('transactions');
    await db.delete('goals');
    await fetchData();
  }
}

