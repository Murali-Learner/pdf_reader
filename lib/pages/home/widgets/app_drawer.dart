import 'package:flutter/material.dart';
import 'package:pdf_reader/pages/dictionary/dictionary_page.dart';
import 'package:pdf_reader/pages/home/widgets/drawer_item.dart';
import 'package:pdf_reader/utils/extensions/context_extension.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: context.height(12),
            child: const DrawerHeader(
              margin: EdgeInsets.zero,
              child: Text(
                'Pocket PDF',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          DrawerItem(
            icon: Icons.book_rounded,
            text: 'Dictionary',
            onTap: () {
              context.pop();
              context.push(navigateTo: const DictionaryPage());
            },
          ),
          DrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              context.pop();
              // Navigate to Home
            },
          ),
          DrawerItem(
            icon: Icons.book,
            text: 'My Library',
            onTap: () {
              context.pop();
              // Navigate to My Library
            },
          ),
          DrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              context.pop();
              // Navigate to Settings
            },
          ),
        ],
      ),
    );
  }
}
