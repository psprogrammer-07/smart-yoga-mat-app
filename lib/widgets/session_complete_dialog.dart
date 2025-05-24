import 'package:flutter/material.dart';

class SessionCompleteDialog extends StatelessWidget {
  final int totalSeconds;

  const SessionCompleteDialog({super.key, required this.totalSeconds});

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    // final seconds = totalSeconds % 60;
    // String secondsStr = seconds.toString().padLeft(2, '0');
    // return '${minutes}m ${secondsStr}s';
    if (minutes < 1) {
      return '<1 minute';
    }
    return '$minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(totalSeconds);
    // Placeholder for calories burned
    String caloriesBurned = "<150 kcal"; // As per the image

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF5F7A61)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
          const Text(
            'Session Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildInfoColumn('Total Time:', formattedTime, Icons.timer_outlined, const Color(0xFF7FC6A4)),
              _buildInfoColumn('Calories Burned:', caloriesBurned, Icons.local_fire_department_outlined, const Color(0xFF7FC6A4)),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F7A61), // Dark green
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    // Potentially navigate to a summary screen or home
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD3D3D3), width: 1), // Light grey border
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    // Implement share functionality
                    print('Share button pressed');
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(color: Color(0xFF5F7A61), fontSize: 16), // Dark green text
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, IconData iconData, Color iconColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor.withOpacity(0.5), width: 2),
          ),
          child: Icon(iconData, size: 30, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}