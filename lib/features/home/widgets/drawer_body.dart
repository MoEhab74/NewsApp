import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/theme/theme_exports.dart';
import 'package:news_app/core/manager/user/user_manager.dart';
import 'package:news_app/features/home/widgets/drawer_list_tile.dart';
import 'package:news_app/features/views/favorites_view.dart';
import 'package:news_app/features/views/saved_articles_view.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({super.key});

  @override
  Widget build(BuildContext context) {
    final userManager = UserManager.instance;
    final isAuthenticated = userManager.isAuthenticated;
    
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // App Header
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.orange),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NewsCloud',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome, ${userManager.currentUserName ?? 'User'}!',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (isAuthenticated && userManager.userEmail != null) ...[
                const SizedBox(height: 4),
                Text(
                  userManager.userEmail!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                isAuthenticated ? 'Logged in with Firebase' : 'Guest Mode - Login to sync across devices',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        // Home Navigation
        DrawerListTile(
          icon: Icons.home,
          title: 'Home',
          onTap: () {
            Navigator.pop(context); // Close the drawer
          },
        ),
        
        // Favorites Navigation
        DrawerListTile(
          icon: Icons.favorite,
          title: 'My Favorites',
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesView()),
            );
          },
        ),
        
        // Saved Articles Navigation
        DrawerListTile(
          icon: Icons.bookmark,
          title: 'Saved Articles',
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedArticlesView()),
            );
          },
        ),
        
        const Divider(),
        
        // Light and Dark mode toggle
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDarkMode = state.themeMode == ThemeMode.dark;

            return DrawerListTile(
              title:
                  isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              icon: isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
                Navigator.pop(context);
              },
            );
          },
        ),
        
        // User Profile/Settings
        DrawerListTile(
          title: 'User Settings',
          icon: Icons.person,
          onTap: () {
            Navigator.pop(context);
            _showUserDialog(context);
          },
        ),
        
        // Logout (only for authenticated users)
        if (isAuthenticated)
          DrawerListTile(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        
        const Divider(),
        
        // About/Info
        DrawerListTile(
          title: 'About NewsCloud',
          icon: Icons.info,
          onTap: () {
            Navigator.pop(context); // Close the drawer
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  void _showUserDialog(BuildContext context) {
    final userManager = UserManager.instance;
    final TextEditingController nameController = TextEditingController(
      text: userManager.currentUserName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${userManager.currentUserId ?? 'Unknown'}'),
            if (userManager.isAuthenticated) ...[
              const SizedBox(height: 8),
              Text('Email: ${userManager.userEmail ?? 'Unknown'}'),
              const SizedBox(height: 8),
              const Text(
                'Account Status: Firebase Authenticated',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ] else ...[
              const SizedBox(height: 8),
              const Text(
                'Account Status: Guest Mode',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'Login to sync your data across devices',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final originalName = userManager.currentUserName ?? '';
              
              // If no changes were made, just close the dialog
              if (newName == originalName) {
                Navigator.pop(context);
                return;
              }
              
              // If name is not empty and different from original, update it
              if (newName.isNotEmpty) {
                await userManager.updateUserName(newName);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Display name updated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                // If name is empty, just close without saving
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout? You will switch to guest mode and your synced data will remain safe in your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                // UserManager will automatically handle the auth state change
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About NewsCloud'),
        content: const Text(
          'NewsCloud is your go-to app for the latest news from around the world. Stay informed with news from various categories including business, entertainment, health, science, sports, and technology.\n\nFeatures:\n• Browse news by category\n• Save articles to read later\n• Mark articles as favorites\n• Offline reading support\n• Sync favorites and saved articles across devices (with account)',
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
