import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions.where((t) => !t.isIncome).toList();

    // Group by category
    final Map<String, double> categoryMap = {};
    for (var t in transactions) {
      categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
    }

    final totalExpense = provider.totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: transactions.isEmpty
          ? const Center(child: Text('No expense data to analyze'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Expense Breakdown',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sections: categoryMap.entries.map((entry) {
                          final percentage = (entry.value / totalExpense) * 100;
                          return PieChartSectionData(
                            value: entry.value,
                            title: '${percentage.toStringAsFixed(0)}%',
                            radius: 100,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            color: _getCategoryColor(entry.key),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Legend
                  ...categoryMap.entries.map((entry) => _buildLegendItem(entry.key, entry.value)),
                ],
              ),
            ),
    );
  }

  Widget _buildLegendItem(String category, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getCategoryColor(category),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(category, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            '${amount.toStringAsFixed(0)} Rs',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.blue;
      case 'Shopping': return Colors.purple;
      case 'Health': return Colors.red;
      case 'Entertainment': return Colors.pink;
      case 'Salary': return Colors.green;
      default: return Colors.grey;
    }
  }
}
