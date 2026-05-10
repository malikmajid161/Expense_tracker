import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final controller = TextEditingController(text: provider.monthlyBudget.toStringAsFixed(0));

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Personalization',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Monthly Budget'),
            subtitle: Text('Current: ${provider.monthlyBudget.toStringAsFixed(0)} Rs'),
            leading: const Icon(Icons.account_balance_wallet_outlined),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _showBudgetDialog(context, provider, controller),
          ),
          const Divider(),
          const ListTile(
            title: Text('Currency'),
            subtitle: Text('Rupees (Rs)'),
            leading: Icon(Icons.currency_rupee),
          ),
          const ListTile(
            title: Text('Theme'),
            subtitle: Text('System Default'),
            leading: Icon(Icons.dark_mode_outlined),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Semester Project v1.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, TransactionProvider provider, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'Rs'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0;
              provider.setBudget(val);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
