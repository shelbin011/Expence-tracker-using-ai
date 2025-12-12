import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/finance_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/app_drawer.dart';
import '../../core/constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Financial Tips Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text("Financial Tip", style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.getDailyTip(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Balances Grid
                SizedBox(
                  height: 240, // Adjust based on need
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SummaryCard(
                        title: 'Balance',
                        amount: '\$${provider.balance.toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      SummaryCard(
                        title: 'Income',
                        amount: '\$${provider.totalIncome.toStringAsFixed(2)}',
                        icon: Icons.arrow_downward,
                        color: AppColors.income,
                        backgroundColor: AppColors.income.withValues(alpha: 0.1),
                      ),
                      SummaryCard(
                        title: 'Expenses',
                        amount: '\$${provider.totalExpense.toStringAsFixed(2)}',
                        icon: Icons.arrow_upward,
                        color: AppColors.expense,
                        backgroundColor: AppColors.expense.withValues(alpha: 0.1),
                      ),
                      SummaryCard(
                        title: 'Goals Active',
                        amount: '${provider.goals.length}',
                        icon: Icons.flag,
                        color: Colors.orange,
                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Recent Transactions", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.transactions.take(5).length,
                  itemBuilder: (ctx, index) {
                    final transaction = provider.transactions[index];
                    return TransactionTile(
                      transaction: transaction,
                      onDelete: () => provider.deleteTransaction(transaction.id!),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
