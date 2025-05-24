import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IOTAUpdateScreen extends StatefulWidget {
  const IOTAUpdateScreen({Key? key}) : super(key: key);

  @override
  _IOTAUpdateScreenState createState() => _IOTAUpdateScreenState();
}

class _IOTAUpdateScreenState extends State<IOTAUpdateScreen> {
  String _currentVersion = '1.0.0'; // Placeholder for current version
  String _latestVersion = '';
  bool _isCheckingForUpdate = false;

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch the actual current firmware version here.
    // For this simulation, we use a placeholder.
  }

  Future<void> _checkForUpdate() async {
    setState(() {
      _isCheckingForUpdate = true;
    });

    try {
      DocumentSnapshot updateDoc = await FirebaseFirestore.instance
          .collection('update')
          .doc('new_update')
          .get();

      if (updateDoc.exists) {
        setState(() {
          _latestVersion = updateDoc['version'];
          print("the latest version is $_latestVersion");
        });

        // Compare versions (simple string comparison for simulation)
        if (_latestVersion.compareTo(_currentVersion) > 0) {
          _showUpdatePrompt();
          
        } else {
          _showSnackBar('You are already on the latest version.');
        }
      } else {
        _showSnackBar('Could not retrieve update information.');
      }
    } catch (e) {
      _showSnackBar('Error checking for update: ${e.toString()}');
    } finally {
      setState(() {
        _isCheckingForUpdate = false;
      });
    }
  }

  void _showUpdatePrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: Text('A new version ($_latestVersion) is available. Would you like to update?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update Now'),
              onPressed: () {
                Navigator.of(context).pop();
                _simulateUpdate();
                
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _simulateUpdate() async {
    _showSnackBar('Starting update...');
    // Simulate update process
    await Future.delayed(const Duration(seconds: 3));
    _showSnackBar('Update complete!');
    setState(() {
            _currentVersion=_latestVersion;
          });
    // In a real app, you would update _currentVersion here after a successful update.
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('IOTA Update'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Firmware Version:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentVersion,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _isCheckingForUpdate ? null : _checkForUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: _isCheckingForUpdate
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Check for Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}