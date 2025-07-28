import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  final TextEditingController _minutesController = TextEditingController(text: '5');
  final TextEditingController _secondsController = TextEditingController(text: '0');

  void _startPauseTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      // Nur Initialzeit setzen, wenn Timer noch nie gestartet wurde oder vollständig abgelaufen ist
      if (_secondsLeft == 0 || _secondsLeft == _totalSeconds) {
        _setInitialTime();
      }
      _startTimer();
    }
  }

  void _setInitialTime() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    _totalSeconds = (minutes * 60) + seconds;
    _secondsLeft = _totalSeconds;
  }

  void _startTimer() {
    if (_isRunning || _totalSeconds == 0) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _setInitialTime(); // setzt auf ursprüngliche Eingabe zurück
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
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
    double percent = _totalSeconds > 0 ? 1 - (_secondsLeft / _totalSeconds) : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 15.0,
              percent: percent.clamp(0, 1),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.blue,
              backgroundColor: Colors.grey[300]!,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_secondsLeft),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (!_isRunning)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Minuten'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: TextField(
                        controller: _secondsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Sekunden'),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startPauseTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  ),
                  child: Text(_isRunning ? 'Pause' : 'Start', style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
