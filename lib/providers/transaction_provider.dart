import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _service = TransactionService();
  List<Transaction> _allTransactions = [];
  String _searchQuery = '';
  double _monthlyBudget = 10000; // Default budget

  List<Transaction> get transactions {
    if (_searchQuery.isEmpty) return _allTransactions;
    return _allTransactions.where((t) => 
      t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      t.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  double get monthlyBudget => _monthlyBudget;

  double get totalIncome => _allTransactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpenses => _allTransactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get currentMonthExpenses {
    final now = DateTime.now();
    return _allTransactions
        .where((t) => !t.isIncome && t.date.month == now.month && t.date.year == now.year)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get balance => totalIncome - totalExpenses;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setBudget(double amount) {
    _monthlyBudget = amount;
    notifyListeners();
  }

  void loadTransactions() {
    _allTransactions = _service.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction t) async {
    await _service.addTransaction(t);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _service.deleteTransaction(id);
    loadTransactions();
  }
}

