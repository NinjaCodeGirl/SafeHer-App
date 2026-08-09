import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeService {
  static StreamSubscription<AccelerometerEvent>? _subscription;
  static int _shakeCount = 0;
  static DateTime? _firstShakeTime;
  static double _threshold = 2.7; // G-force threshold (approx 26-28 m/s^2)

  static void startListening({
    required Function() onThreeShakeDetected,
    double thresholdG = 2.7,
  }) {
    _threshold = thresholdG;
    _subscription?.cancel();

    _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate G-force magnitude normalized to 1G earth gravity (~9.81 m/s^2)
      final double gForce =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z) / 9.80665;

      if (gForce > _threshold) {
        final now = DateTime.now();

        if (_firstShakeTime == null ||
            now.difference(_firstShakeTime!).inMilliseconds > 1500) {
          // Reset window if 1.5 seconds elapsed since first shake
          _firstShakeTime = now;
          _shakeCount = 1;
        } else {
          _shakeCount++;
          if (_shakeCount >= 3) {
            _shakeCount = 0;
            _firstShakeTime = null;
            onThreeShakeDetected();
          }
        }
      }
    });
  }

  static void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
