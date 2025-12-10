import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome Back!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'User',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
           const ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Feedback'),
          ),
        ],
      ),
    );
  }
}
