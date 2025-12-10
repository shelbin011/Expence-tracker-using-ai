import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/finance_provider.dart';
import '../../logic/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("john.doe@example.com"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person, size: 40)),
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
}
