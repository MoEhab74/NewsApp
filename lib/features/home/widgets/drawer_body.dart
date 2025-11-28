import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/theme/theme.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // App Header
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.orange),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NewsCloud',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Stay updated with the latest news',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Home Navigation
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // Light and Dark mode toggle
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDarkMode = state.themeMode == ThemeMode.dark;
            
            return ListTile(
              leading: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              title: Text(
                isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              ),
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
                Navigator.pop(context);
              },
            );
          },
        ),
        const Divider(),
        // About/Info
        ListTile(
          leading: const Icon(Icons.info, color: Colors.blue),
          title: const Text(
            'About NewsCloud',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About NewsCloud'),
        content: const Text(
          'NewsCloud is your go-to app for the latest news from around the world. Stay informed with news from various categories including business, entertainment, health, science, sports, and technology.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
