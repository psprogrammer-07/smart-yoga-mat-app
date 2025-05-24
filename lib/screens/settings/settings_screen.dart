import 'package:flutter/material.dart';
import 'lota_update_screen.dart';
import 'app_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('IOTA Update'),
            onTap: () {
              Navigator.pushNamed(context, '/ota'); // Use the named route for IOTA Update
            },
          ),
          ListTile(
            title: const Text('App Info'),
            onTap: () {
              Navigator.pushNamed(context, '/info'); // Use the named route for App Info
            },
          ),
        ],
      ),
    );
  }
}