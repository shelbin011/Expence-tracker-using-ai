import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/finance_provider.dart';
import '../../data/models/goal_model.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Goal Name')),
            TextField(controller: targetController, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
            TextField(controller: savedController, decoration: const InputDecoration(labelText: 'Current Saved'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final title = titleController.text;
              final target = double.tryParse(targetController.text) ?? 0;
              final saved = double.tryParse(savedController.text) ?? 0;

              if (title.isNotEmpty && target > 0) {
                final goal = GoalModel(
                  title: title,
                  targetAmount: target,
                  savedAmount: saved,
                  deadline: DateTime.now().add(const Duration(days: 30)), // Default 30 days for simplicity
                );
                Provider.of<FinanceProvider>(context, listen: false).addGoal(goal);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.goals.isEmpty) {
            return const Center(child: Text("No goals set yet."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.goals.length,
            itemBuilder: (ctx, index) {
              final goal = provider.goals[index];
              final progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

              return Dismissible(
                key: Key(goal.id.toString()),
                 background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  provider.deleteGoal(goal.id!);
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${(progress * 100).toInt()}%', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Saved: \$${goal.savedAmount.toStringAsFixed(0)}'),
                            Text('Target: \$${goal.targetAmount.toStringAsFixed(0)}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
