import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/finance_provider.dart';
import '../../logic/providers/user_provider.dart';

import '../widgets/transaction_tile.dart';
import '../widgets/transaction_search_delegate.dart';
import 'add_transaction_screen.dart';
import 'all_transactions_screen.dart';
import '../../core/constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                 final provider = Provider.of<FinanceProvider>(context, listen: false);
                 showSearch(
                   context: context,
                   delegate: TransactionSearchDelegate(
                     transactions: provider.transactions,
                     onDelete: (id) => provider.deleteTransaction(id),
                   ),
                 );
              },
              icon: const Icon(Icons.search, size: 28),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, size: 28),
            ),
          ],
        ),
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          final currency = Provider.of<UserProvider>(context).currency;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Balance Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          InkWell(
                             onTap: () => _showEditAccountDialog(context),
                             child: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.8))
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$currency${provider.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Account Number", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                              const SizedBox(height: 4),
                              Text(provider.accountNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expiry Date", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                              const SizedBox(height: 4),
                              Text(provider.expiryDate, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (ctx) => const AddTransactionScreen(initialType: 'income')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              child: const Text("Add Income"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (ctx) => const AddTransactionScreen(initialType: 'expense')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              child: const Text("Add Expense"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Overview Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Weekly",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Income / Spending Row
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        title: "Income",
                        amount: '$currency${provider.totalIncome.toStringAsFixed(2)}',
                        icon: Icons.arrow_downward,
                        iconBg: AppColors.primary,
                        iconColor: Colors.white,
                        bg: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        title: "Spending",
                        amount: '$currency${provider.totalExpense.toStringAsFixed(2)}',
                        icon: Icons.arrow_upward,
                        iconBg: Colors.white,
                        iconColor: AppColors.primary,
                        bg: AppColors.primaryLight.withValues(alpha: 0.5), // Slightly lighter or different
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                  ],
                ),
                const SizedBox(height: 30),

                // Budget Card (New Feature)
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    if (userProvider.monthlyBudget <= 0) return const SizedBox.shrink();

                    final budget = userProvider.monthlyBudget;
                    final expense = provider.currentMonthExpense;
                    final progress = (expense / budget).clamp(0.0, 1.0);
                    
                    // Simple Projection: (expense / days_passed) * days_in_month
                    final now = DateTime.now();
                    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
                    final dailyAvg = now.day > 0 ? expense / now.day : 0;
                    final projected = dailyAvg * daysInMonth;

                    Color progressColor = Colors.green;
                    if (progress > 0.8) progressColor = Colors.red;
                    else if (progress > 0.5) progressColor = Colors.orange;

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Monthly Budget", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(
                                    "${(progress * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: progressColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                color: progressColor,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$currency${expense.toStringAsFixed(0)} / $currency${budget.toStringAsFixed(0)}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Proj: $currency${projected.toStringAsFixed(0)}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
                
                 // Recent Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllTransactionsScreen()),
                        );
                      },
                      child: const Text("View All"),
                    ),
                  ],
                ),
                 const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.transactions.take(5).length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (ctx, index) {
                    final transaction = provider.transactions[index];
                    return TransactionTile(
                      transaction: transaction,
                      onDelete: () => provider.deleteTransaction(transaction.id!),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, {
    required String title,
    required String amount,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconBg, size: 20),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[400], size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  void _showEditAccountDialog(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final accountController = TextEditingController(text: provider.accountNumber);
    final expiryController = TextEditingController(text: provider.expiryDate);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Account Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: accountController, decoration: const InputDecoration(labelText: 'Account Number')),
            TextField(controller: expiryController, decoration: const InputDecoration(labelText: 'Expiry Date')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              provider.updateAccountDetails(accountController.text, expiryController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
