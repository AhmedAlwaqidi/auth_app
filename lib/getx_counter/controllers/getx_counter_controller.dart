import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../shared/models/timer_status.dart';

/// GetX controller managing counter state, periodic timer execution, and application lifecycle.
class GetxCounterController extends GetxController with WidgetsBindingObserver {
  /// Reactive counter value.
  final RxInt count = 0.obs;

  /// Reactive timer status.
  final Rx<TimerStatus> timerStatus = TimerStatus.idle.obs;

  /// Reactive string describing the most recently observed Flutter lifecycle state.
  final RxString lastLifecycleEvent = 'resumed'.obs;

  /// Tracks whether the timer was paused by lifecycle backgrounding vs manual user action.
  final RxBool isPausedByLifecycle = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    _cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Increments the counter manually by 1.
  void increment() {
    count.value++;
  }

  /// Decrements the counter manually by 1.
  void decrement() {
    count.value--;
  }

  /// Resets the counter value to 0, cancels the timer, and resets state to idle.
  void reset() {
    _cancelTimer();
    count.value = 0;
    timerStatus.value = TimerStatus.idle;
    isPausedByLifecycle.value = false;
  }

  /// Starts the periodic timer (1s interval) if not already running.
  void startTimer() {
    if (timerStatus.value == TimerStatus.running) return;

    _cancelTimer();
    timerStatus.value = TimerStatus.running;
    isPausedByLifecycle.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      count.value++;
    });
  }

  /// Manually pauses the running timer without losing current count.
  void pauseTimer() {
    if (timerStatus.value != TimerStatus.running) return;

    _cancelTimer();
    timerStatus.value = TimerStatus.paused;
    isPausedByLifecycle.value = false;
  }

  /// Resumes counting from paused state.
  void resumeTimer() {
    if (timerStatus.value != TimerStatus.paused) return;
    startTimer();
  }

  /// Stops and cancels the timer.
  void stopTimer() {
    _cancelTimer();
    timerStatus.value = TimerStatus.stopped;
    isPausedByLifecycle.value = false;
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lastLifecycleEvent.value = state.name;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // When backgrounding, pause running timer to save resources
        if (timerStatus.value == TimerStatus.running) {
          _cancelTimer();
          timerStatus.value = TimerStatus.paused;
          isPausedByLifecycle.value = true;
        }
        break;

      case AppLifecycleState.resumed:
        // Automatically resume only if paused by lifecycle; keep manual pause intact
        if (isPausedByLifecycle.value &&
            timerStatus.value == TimerStatus.paused) {
          startTimer();
        }
        break;

      case AppLifecycleState.detached:
        _cancelTimer();
        break;
    }
  }
}
