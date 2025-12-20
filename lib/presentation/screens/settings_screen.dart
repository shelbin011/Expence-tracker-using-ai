import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/finance_provider.dart';
import '../../logic/providers/theme_provider.dart';
import '../../logic/providers/user_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../logic/services/csv_export_service.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          Consumer<UserProvider>(
            builder: (ctx, userProvider, _) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                accountName: Text(
                  userProvider.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                accountEmail: Text(
                  userProvider.email,
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                onDetailsPressed: () {
                    _showEditProfileDialog(context, userProvider);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Country'),
            subtitle: Consumer<UserProvider>(
              builder: (ctx, userProvider, _) => Text(userProvider.country),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showCountryPicker(context),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Monthly Budget'),
            subtitle: Consumer<UserProvider>(
               builder: (ctx, userProvider, _) => Text(
                userProvider.monthlyBudget > 0 
                  ? '${userProvider.currency}${userProvider.monthlyBudget.toStringAsFixed(2)}' 
                  : 'Not Set'
              ),
            ),
            trailing: const Icon(Icons.edit, size: 16),
            onTap: () => _showBudgetDialog(context),
          ),
           ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            trailing: Consumer<ThemeProvider>(
              builder: (ctx, themeProvider, _) {
                 return Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                );
              },
            ),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          ListTile(
            leading: const Icon(Icons.file_download, color: Colors.blue),
            title: const Text('Export to CSV'),
            onTap: () async {
               final transactions = Provider.of<FinanceProvider>(context, listen: false).transactions;
               if (transactions.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No transactions to export.")));
                 return;
               }
               
               try {
                 await CsvExportService.exportTransactions(transactions);
               } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export failed: $e")));
                 }
               }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Reset Data', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset Data?'),
                  content: const Text('This will delete all transactions and goals. This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                         Provider.of<FinanceProvider>(context, listen: false).resetData();
                         Navigator.pop(ctx);
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All data has been reset.")));
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProvider userProvider) {
    final nameController = TextEditingController(text: userProvider.name);
    final emailController = TextEditingController(text: userProvider.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              userProvider.updateUser(nameController.text, emailController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Select Country',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...AppConstants.countryCurrencies.keys.map((country) {
              return ListTile(
                title: Text(country),
                trailing: country == Provider.of<UserProvider>(context, listen: false).country
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false).updateCountry(country);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        );
      },
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final controller = TextEditingController(
      text: userProvider.monthlyBudget > 0 ? userProvider.monthlyBudget.toStringAsFixed(0) : ''
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Budget Limit',
            prefixText: userProvider.currency,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(ctx),
             child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                userProvider.updateBudget(val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
