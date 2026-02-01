import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/finance_provider.dart';
import '../widgets/transaction_tile.dart';
import '../../core/constants/app_colors.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.transactions.isEmpty) {
            return const Center(child: Text("No transactions found"));
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: provider.transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (ctx, index) {
              final transaction = provider.transactions[index];
              return TransactionTile(
                transaction: transaction,
                onDelete: () => provider.deleteTransaction(transaction.id!),
              );
            },
          );
        },
      ),
    );
  }
}
