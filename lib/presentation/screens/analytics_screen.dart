import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../logic/providers/finance_provider.dart';


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.transactions.isEmpty) {
            return const Center(child: Text("No data available yet"));
          }

          final expenseTransactions = provider.transactions.where((t) => t.type == 'expense').toList();
          
          if (expenseTransactions.isEmpty) {
             return const Center(child: Text("No expenses to analyze"));
          }

          final Map<String, double> categoryTotals = {};
          for (var t in expenseTransactions) {
            if (!categoryTotals.containsKey(t.category)) {
              categoryTotals[t.category] = 0;
            }
            categoryTotals[t.category] = categoryTotals[t.category]! + t.amount;
          }

          final totalExpense = provider.totalExpense;
          int colorIndex = 0;
          final List<Color> colors = [
            Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.amber, Colors.pink
          ];

          final List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
             final percentage = (entry.value / totalExpense) * 100;
             final color = colors[colorIndex % colors.length];
             colorIndex++;
             
             return PieChartSectionData(
               color: color,
               value: entry.value,
               title: '${percentage.toStringAsFixed(1)}%',
               radius: 50,
               titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
             );
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Expense Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Legend
                ...categoryTotals.entries.map((entry) {
                  // Re-find color (not efficient but works for simple list)
                  final index = categoryTotals.keys.toList().indexOf(entry.key);
                  final color = colors[index % colors.length];
                  
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: color, radius: 8),
                    title: Text(entry.key),
                    trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
