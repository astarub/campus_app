import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart';  // <-- native vibration (keine Plugins!)

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  Timer? _timer;
  int _totalSeconds = 0;
  int _secondsLeft = 0;
  bool _isRunning = false;

  final TextEditingController _minutesController =
      TextEditingController(text: '5');
  final TextEditingController _secondsController =
      TextEditingController(text: '0');

  static const Color campusBlue = Color(0xFF003A70);
  static const Color campusLightBlue = Color(0xFF4A90E2);

  void _startPauseTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      if (_secondsLeft == 0 || _secondsLeft == _totalSeconds) {
        _setInitialTime();
      }
      _startTimer();
    }
  }

  void _setInitialTime() {
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;
    final seconds = int.tryParse(_secondsController.text.trim()) ?? 0;
    _totalSeconds = (minutes * 60) + seconds;
    _secondsLeft = _totalSeconds;
  }

  void _startTimer() {
    if (_isRunning || _totalSeconds == 0) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);

        // 🔥 Handy vibriert (Flutter native)
        _triggerVibration();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    _setInitialTime();
    setState(() => _isRunning = false);
  }

  // Native Vibrations-Funktion (ohne Plugins, ohne Fehler)
  void _triggerVibration() {
    HapticFeedback.heavyImpact();
    HapticFeedback.vibrate();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    double pct = _totalSeconds > 0 ? 1 - (_secondsLeft / _totalSeconds) : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Study Timer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0F1A),
                    const Color(0xFF001020),
                  ]
                : [
                    campusLightBlue,
                    campusBlue,
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 140.0,
                lineWidth: 16.0,
                percent: pct.clamp(0, 1),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: isDark ? Colors.cyanAccent : Colors.white,
                backgroundColor: isDark ? Colors.white10 : Colors.white24,
                animation: false,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_secondsLeft),
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isRunning ? "läuft..." : "bereit",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              if (!_isRunning)
                Container(
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Minuten / Sekunden",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(child: _buildTimeField(_minutesController)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildTimeField(_secondsController)),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startPauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white10 : Colors.white,
                      foregroundColor: isDark ? Colors.cyanAccent : campusBlue,
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _isRunning ? "Pause" : "Start",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide.none,
        ),
      ),
      textAlign: TextAlign.center,
    );
  }
}
