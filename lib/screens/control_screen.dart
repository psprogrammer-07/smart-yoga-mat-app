import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_yoga_mat/widgets/session_complete_dialog.dart';
import 'package:audioplayers/audioplayers.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isPaused = false;

  String message = '';
  String _feedbackMessage = '';
  Timer? _feedbackTimer;
  Timer? _dataTimer; // Added to manage simulate_live_data timer

  late AudioPlayer _audioPlayer;
  bool _isMusicPlaying = false;
  String? _currentTrack;
  final Map<String, String> _audioTracks = {
    'Calm': 'audio/calm.mp3',
    'Focus': 'audio/focus.mp3',
    'Nature': 'audio/nature.mp3',
  };

  Map<String, double> pressureData = {
    'leftHand': 0.0,
    'rightHand': 0.0,
    'leftFoot': 0.5,
    'rightFoot': 0.5,
    'leftKnee': 0.0,
    'rightKnee': 0.0,
  };

  double balanceValue = 0.5;
  double leftRightValue = 0.5;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    startTimer();
    simulate_live_data();
  }

  @override
  void dispose() {
    _timer.cancel();
    _feedbackTimer?.cancel();
    _dataTimer?.cancel(); // Cancel the data simulation timer
    _audioPlayer.dispose();
    super.dispose();
  }

  void simulate_live_data() {
    _dataTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isPaused) {
        setState(() {
          // Simulate new pressure values (range 0.0 - 1.0)
          pressureData['leftHand'] = _randomValue_for_hand();
          pressureData['rightHand'] = _randomValue_for_hand();
          pressureData['leftFoot'] = _randomValue();
          pressureData['rightFoot'] = _randomValue();
          pressureData['leftKnee'] = _randomValue();
          pressureData['rightKnee'] = _randomValue();

          // Update message based on pressure thresholds
          if ((pressureData['leftHand'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Left Hand';
          } else if ((pressureData['rightHand'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Right Hand';
          } else if ((pressureData['leftFoot'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Left Foot';
          } else if ((pressureData['rightFoot'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Right Foot';
          } else if ((pressureData['leftKnee'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Left Knee';
          } else if ((pressureData['rightKnee'] ?? 0.0) > 0.8) {
            message = 'Too much weight on Right Knee';
          } else {
            message = '';
          }

          // Recalculate balance values
          double left = (pressureData['leftHand'] ?? 0.0) + (pressureData['leftFoot'] ?? 0.0);
          double right = (pressureData['rightHand'] ?? 0.0) + (pressureData['rightFoot'] ?? 0.0);
          double total = left + right;

          // Avoid division by zero
          if (total > 0) {
            balanceValue = left / total;
            leftRightValue = right / total;
          } else {
            balanceValue = 0.5;
            leftRightValue = 0.5;
          }
          print("total: $total");
          print('Balance: $balanceValue');
          print('Left/Right: $leftRightValue');
        });
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  double _randomValue() {
    final random = Random();
    return 0.1 + random.nextDouble() * (1.0 - 0.1);
  }

  double _randomValue_for_hand() {
    final random = Random();
    return 0.0 + random.nextDouble() * (1.0 - 0.1);
  }

  String formatTime() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _playAudio(String trackName) async {
    if (_currentTrack == _audioTracks[trackName] && _isMusicPlaying) {
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(_audioTracks[trackName]!));
    setState(() {
      _isMusicPlaying = true;
      _currentTrack = _audioTracks[trackName];
    });
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isMusicPlaying = false;
      _currentTrack = null;
    });
  }

  void _startWarmUp() {
    _feedbackTimer?.cancel();
    setState(() {
      _feedbackMessage = 'Warming up your body... Get ready to flow!';
    });

    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _feedbackMessage = 'Feel the heat building. Stay focused.';
      });
      _feedbackTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          _feedbackMessage = 'Warm-Up complete! You\'re all set to begin.';
        });
      });
    });
  }

  void _startRelaxation() {
    _feedbackTimer?.cancel();
    setState(() {
      _feedbackMessage = 'Relaxation mode initiated. Breathe in...';
    });

    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _feedbackMessage = 'Let the calm flow through you...';
      });
      _feedbackTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          _feedbackMessage = 'You\'re relaxed and recharged. Namaste 🙏';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9D84FF), Color(0xFF4B9FE1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Session is Live\n${formatTime()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomPaint(
                        size: const Size(200, 300),
                        painter: StickFigurePainter(pressureData),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIndicator('Balance', balanceValue),
                        _buildIndicator('Left/Right', leftRightValue),
                      ],
                    ),
                    // Remove the SizedBox below this line
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    Text(
                      _feedbackMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startWarmUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF9D84FF),
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Start Warm-Up'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startRelaxation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9D84FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Begin Relaxation Mode'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Music and Sound Options:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _audioTracks.keys.map((trackName) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () => _playAudio(trackName),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _currentTrack == _audioTracks[trackName]
                                        ? Colors.green
                                        : Colors.white,
                                    foregroundColor: _currentTrack == _audioTracks[trackName]
                                        ? Colors.white
                                        : const Color(0xFF9D84FF),
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(trackName),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: _stopAudio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Stop Music'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isPaused = !_isPaused;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              _isPaused ? 'Resume' : 'Pause',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _timer.cancel();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return SessionCompleteDialog(totalSeconds: _seconds);
                                },
                              ).then((_) {
                                if (mounted) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'End Session',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(String label, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 120,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white24,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: value > 0.5 ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StickFigurePainter extends CustomPainter {
  final Map<String, double> pressureData;

  StickFigurePainter(this.pressureData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final activeDotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final inactiveDotPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final matWidth = size.width * 0.8;
    final matHeight = size.height * 0.9;
    final matX = (size.width - matWidth) / 2;
    final matY = (size.height - matHeight) / 2;
    final matRect = Rect.fromLTWH(matX, matY, matWidth, matHeight);

    final specificMatPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.deepPurpleAccent.shade100.withOpacity(0.95),
          Colors.deepPurple.shade200,
          Colors.deepPurpleAccent.shade400.withOpacity(0.9),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(matRect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(matRect, const Radius.circular(10)),
      specificMatPaint,
    );

    final zoneWidth = matWidth / 2;
    final zoneHeight = matHeight / 3;

    final pillowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepPurple.shade300.withOpacity(0.8),
          Colors.deepPurple.shade500.withOpacity(0.9),
        ],
      ).createShader(matRect)
      ..style = PaintingStyle.fill;

    final pillowBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double pillowPadding = 4.0;
    const double pillowRadius = 8.0;

    final List<Rect> zoneRects = [
      Rect.fromLTWH(matX + pillowPadding, matY + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
      Rect.fromLTWH(matX + zoneWidth + pillowPadding, matY + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
      Rect.fromLTWH(matX + pillowPadding, matY + zoneHeight + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
      Rect.fromLTWH(matX + zoneWidth + pillowPadding, matY + zoneHeight + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
      Rect.fromLTWH(matX + pillowPadding, matY + 2 * zoneHeight + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
      Rect.fromLTWH(matX + zoneWidth + pillowPadding, matY + 2 * zoneHeight + pillowPadding, zoneWidth - 2 * pillowPadding, zoneHeight - 2 * pillowPadding),
    ];

    for (final rect in zoneRects) {
      final shadowRect = rect.inflate(1.5);
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawRRect(RRect.fromRectAndRadius(shadowRect, const Radius.circular(pillowRadius + 2)), shadowPaint);

      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(pillowRadius)), pillowPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(pillowRadius)), pillowBorderPaint);
    }

    final Map<String, Offset> zoneCenters = {
      'leftHand': Offset(matX + zoneWidth * 0.5, matY + zoneHeight * 0.5),
      'rightHand': Offset(matX + zoneWidth * 1.5, matY + zoneHeight * 0.5),
      'leftKnee': Offset(matX + zoneWidth * 0.5, matY + zoneHeight * 1.5),
      'rightKnee': Offset(matX + zoneWidth * 1.5, matY + zoneHeight * 1.5),
      'leftFoot': Offset(matX + zoneWidth * 0.5, matY + zoneHeight * 2.5),
      'rightFoot': Offset(matX + zoneWidth * 1.5, matY + zoneHeight * 2.5),
    };

    const double dotRadius = 10.0;

    Paint getDotPaintForPressure(double pressureValue) {
      return pressureValue > 0.4 ? activeDotPaint : inactiveDotPaint;
    }

    zoneCenters.forEach((key, center) {
      final double pressure = pressureData[key] ?? 0.0;
      canvas.drawCircle(center, dotRadius, getDotPaintForPressure(pressure));
    });

    final stickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset headCenter = Offset(matX + matWidth / 2, matY + zoneHeight * 0.5);
    final Offset neckBase = Offset(matX + matWidth / 2, matY + zoneHeight * 0.8);
    final Offset torsoBase = Offset(matX + matWidth / 2, matY + zoneHeight * 1.8);
    final Offset hipCenter = Offset(matX + matWidth / 2, matY + zoneHeight * 2.0);

    double leftHandPressure = pressureData['leftHand'] ?? 0.0;
    double rightHandPressure = pressureData['rightHand'] ?? 0.0;
    double leftKneePressure = pressureData['leftKnee'] ?? 0.0;
    double rightKneePressure = pressureData['rightKnee'] ?? 0.0;
    double leftFootPressure = pressureData['leftFoot'] ?? 0.0;
    double rightFootPressure = pressureData['rightFoot'] ?? 0.0;

    bool isStanding = (leftHandPressure < 0.1 &&
        rightHandPressure < 0.1 &&
        leftKneePressure < 0.1 &&
        rightKneePressure < 0.1 &&
        leftFootPressure > 0.1 &&
        rightFootPressure > 0.1);

    canvas.drawCircle(headCenter, dotRadius * 1.5, stickPaint);
    canvas.drawLine(neckBase, torsoBase, stickPaint);

    if (isStanding) {
      final Offset shoulderLeft = Offset(neckBase.dx - zoneWidth * 0.3, neckBase.dy + zoneHeight * 0.1);
      final Offset shoulderRight = Offset(neckBase.dx + zoneWidth * 0.3, neckBase.dy + zoneHeight * 0.1);
      final Offset handLeftStand = Offset(shoulderLeft.dx, torsoBase.dy - zoneHeight * 0.2);
      final Offset handRightStand = Offset(shoulderRight.dx, torsoBase.dy - zoneHeight * 0.2);
      final Offset footLeftStand = zoneCenters['leftFoot']!;
      final Offset footRightStand = zoneCenters['rightFoot']!;

      canvas.drawLine(neckBase, shoulderLeft, stickPaint);
      canvas.drawLine(shoulderLeft, handLeftStand, stickPaint);
      canvas.drawLine(neckBase, shoulderRight, stickPaint);
      canvas.drawLine(shoulderRight, handRightStand, stickPaint);

      final Offset hipLeftStand = Offset(hipCenter.dx - zoneWidth * 0.15, hipCenter.dy);
      final Offset hipRightStand = Offset(hipCenter.dx + zoneWidth * 0.15, hipCenter.dy);

      canvas.drawLine(torsoBase, hipLeftStand, stickPaint);
      canvas.drawLine(hipLeftStand, footLeftStand, stickPaint);
      canvas.drawLine(torsoBase, hipRightStand, stickPaint);
      canvas.drawLine(hipRightStand, footRightStand, stickPaint);
    } else {
      final Offset leftHandPos = zoneCenters['leftHand']!;
      final Offset rightHandPos = zoneCenters['rightHand']!;
      final Offset leftKneePos = zoneCenters['leftKnee']!;
      final Offset rightKneePos = zoneCenters['rightKnee']!;
      final Offset leftFootPos = zoneCenters['leftFoot']!;
      final Offset rightFootPos = zoneCenters['rightFoot']!;

      final Offset shoulderLeft = Offset(neckBase.dx - zoneWidth * 0.25, neckBase.dy + zoneHeight * 0.05);
      final Offset shoulderRight = Offset(neckBase.dx + zoneWidth * 0.25, neckBase.dy + zoneHeight * 0.05);

      final Offset hipLeft = Offset(hipCenter.dx - zoneWidth * 0.20, hipCenter.dy);
      final Offset hipRight = Offset(hipCenter.dx + zoneWidth * 0.20, hipCenter.dy);

      canvas.drawLine(neckBase, shoulderLeft, stickPaint);
      canvas.drawLine(shoulderLeft, leftHandPos, stickPaint);
      canvas.drawLine(neckBase, shoulderRight, stickPaint);
      canvas.drawLine(shoulderRight, rightHandPos, stickPaint);

      canvas.drawLine(torsoBase, hipLeft, stickPaint);
      canvas.drawLine(hipLeft, leftKneePos, stickPaint);
      canvas.drawLine(leftKneePos, leftFootPos, stickPaint);

      canvas.drawLine(torsoBase, hipRight, stickPaint);
      canvas.drawLine(hipRight, rightKneePos, stickPaint);
      canvas.drawLine(rightKneePos, rightFootPos, stickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StickFigurePainter oldDelegate) {
    return pressureData.entries.any((entry) =>
        oldDelegate.pressureData[entry.key] != entry.value);
  }
}