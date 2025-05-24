import 'package:flutter/material.dart';
import 'package:smart_yoga_mat/screens/control_screen.dart';
import 'package:smart_yoga_mat/screens/progress_tracking_screen.dart'; // Import the new screen
import 'package:smart_yoga_mat/screens/product_showcase.dart'; // Import the Product Showcase screen
 import 'package:smart_yoga_mat/screens/settings/settings_screen.dart'; // Import the Settings screen

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    // The original ConnectScreen content
    _ConnectContent(),
    const ProgressTrackingScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      if (_selectedIndex != 0) {
        // If user is not on the main "Connect" tab, go back to it
        setState(() {
          _selectedIndex = 0;
        });
        return false; // Don't exit the app
      } else {
        // Optional: show confirmation dialog before exiting
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      }
    },
    child: Scaffold(
      backgroundColor: Colors.black87,
     
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_connected),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    ),
  );
}

}

// Extract the original ConnectScreen content into a separate StatelessWidget
class _ConnectContent extends StatefulWidget { // Change to StatefulWidget
  @override
  _ConnectContentState createState() => _ConnectContentState();
}

class _ConnectContentState extends State<_ConnectContent> { // Create State class
  String _connectionStatus = 'Not Connected'; // State variable for connection status
  bool _isConnecting = false; // State variable to indicate if connecting

  void _connectToMat() async { // Async function to simulate connection
    setState(() {
      _isConnecting = true;
      _connectionStatus = 'Connecting...';
    });

    // Simulate a delay for connection
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isConnecting = false;
      _connectionStatus = 'Connected to Smart Mat';
    });

   await Future.delayed(const Duration(seconds: 1));
     Navigator.pushNamed(
    context,
    '/control', // Use the named route for ConnectScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D84FF), Color(0xFF4B9FE1)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'YogaSense',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Removed the old navigation buttons for Progress Tracking, Product Showcase, and Settings
                ],
              ),
              const Spacer(),
              // Yoga Mat Illustration with Glow Effect
              Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wireless Icon
                    Positioned(
                      top: 20,
                      child: Icon(
                        Icons.wifi,
                        size: 40,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),

                    Image.asset("assets/images/yoga_mat.png")
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _connectionStatus, // Display connection status
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please make sure your mat is turned on', // Keep this text or modify as needed
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isConnecting ? null : _connectToMat, // Disable button while connecting
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    _isConnecting ? 'Connecting...' : 'Connect to the yoga mat \n and simulate its data', // Change button text based on status
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}