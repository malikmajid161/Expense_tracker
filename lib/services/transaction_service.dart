import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction.dart';

class TransactionService {
  final Box<Transaction> _box = Hive.box<Transaction>('transactions');

  List<Transaction> getAllTransactions() {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }
}
