import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("App Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Smart Yoga Mat", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("This app helps users connect with their smart yoga mat, start routines, play relaxing sounds, and receive updates wirelessly."),
            Divider(height: 30),
            Text("📱 App Version: 1.0.0"),
            SizedBox(height: 10),
            Text("👨‍💻 Developer: Periyasamy P"),
            Text("📧 Email: periad061@rmkcet.ac.in"),
            SizedBox(height: 10),
            Text("🔧 Tech Stack:"),
            Text("• Flutter (Cross-platform UI)"),
            Text("• Firebase (Cloud data)"),
            Text("• Simulated Bluetooth/Wi-Fi"),
            Text("• OTA Update Logic"),
            Divider(height: 30),
            Text("⚠️ Permissions Used:"),
            Text("• Bluetooth"),
            Text("• Wi-Fi"),
            Text("• Internet"),
          ],
        ),
      ),
    );
  }
}
