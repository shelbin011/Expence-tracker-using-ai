import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
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
                const Text("Weekly Expenses (Last 7 Days)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Builder(
                    builder: (context) {
                       // Calculate last 7 days data
                       final now = DateTime.now();
                       final List<double> dailyTotals = List.filled(7, 0.0);
                       final List<String> weekDays = [];
                       
                       for (int i = 0; i < 7; i++) {
                         final day = now.subtract(Duration(days: 6 - i));
                         weekDays.add(DateFormat.E().format(day)); // Mon, Tue...
                         
                         // Sum expenses for this day
                         final dayExpenses = expenseTransactions.where((t) {
                           return t.date.year == day.year && 
                                  t.date.month == day.month && 
                                  t.date.day == day.day;
                         });
                         
                         for (var t in dayExpenses) {
                           dailyTotals[i] += t.amount;
                         }
                       }
                       
                       // Find max for Y-axis interval
                        double maxY = dailyTotals.reduce((curr, next) => curr > next ? curr : next);
                        if (maxY == 0) maxY = 100;
                        
                       return BarChart(
                         BarChartData(
                           alignment: BarChartAlignment.spaceAround,
                           maxY: maxY * 1.2,
                           barTouchData: BarTouchData(
                             enabled: true,
                             touchTooltipData: BarTouchTooltipData(
                               getTooltipColor: (_) => Colors.blueGrey,
                               getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    rod.toY.toStringAsFixed(1),
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  );
                               },
                             ),
                           ),
                           titlesData: FlTitlesData(
                             show: true,
                             bottomTitles: AxisTitles(
                               sideTitles: SideTitles(
                                 showTitles: true,
                                 getTitlesWidget: (double value, TitleMeta meta) {
                                   if (value.toInt() < 0 || value.toInt() >= weekDays.length) return const SizedBox.shrink();
                                   return Text(weekDays[value.toInt()], style: const TextStyle(fontSize: 10));
                                 },
                               ),
                             ),
                             leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                           ),
                           gridData: const FlGridData(show: false),
                           borderData: FlBorderData(show: false),
                           barGroups: List.generate(7, (index) {
                             return BarChartGroupData(
                               x: index,
                               barRods: [
                                 BarChartRodData(
                                   toY: dailyTotals[index],
                                   color: AppColors.primary,
                                   width: 16,
                                   borderRadius: BorderRadius.circular(4),
                                 ),
                               ],
                             );
                           }),
                         ),
                       );
                    },
                  ),
                ),
                const SizedBox(height: 30),
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
