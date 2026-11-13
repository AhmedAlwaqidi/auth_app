import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/counter_state.dart';
import '../../shared/models/timer_status.dart';

/// Riverpod 2.x Notifier managing the immutable [CounterState].
class RiverpodCounterNotifier extends Notifier<CounterState> {
  Timer? _timer;

  @override
  CounterState build() {
    // Automatically clean up timer when provider is disposed
    ref.onDispose(() {
      _cancelTimer();
    });

    return const CounterState();
  }

  /// Increments the counter manually by 1.
  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  /// Decrements the counter manually by 1.
  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }

  /// Resets the counter value to 0, cancels any active timer, and sets status to idle.
  void reset() {
    _cancelTimer();
    state = state.copyWith(
      count: 0,
      timerStatus: TimerStatus.idle,
      isPausedByLifecycle: false,
    );
  }

  /// Starts the periodic timer (1s interval) if not currently running.
  void startTimer() {
    if (state.timerStatus == TimerStatus.running) return;

    _cancelTimer();
    state = state.copyWith(
      timerStatus: TimerStatus.running,
      isPausedByLifecycle: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(count: state.count + 1);
    });
  }

  /// Manually pauses the timer without losing the accumulated count.
  void pauseTimer() {
    if (state.timerStatus != TimerStatus.running) return;

    _cancelTimer();
    state = state.copyWith(
      timerStatus: TimerStatus.paused,
      isPausedByLifecycle: false,
    );
  }

  /// Resumes counting from a paused state.
  void resumeTimer() {
    if (state.timerStatus != TimerStatus.paused) return;
    startTimer();
  }

  /// Stops and cancels the timer.
  void stopTimer() {
    _cancelTimer();
    state = state.copyWith(
      timerStatus: TimerStatus.stopped,
      isPausedByLifecycle: false,
    );
  }

  /// Processes Flutter application lifecycle state transitions.
  void handleLifecycleChange(AppLifecycleState lifecycleState) {
    state = state.copyWith(lastLifecycleEvent: lifecycleState.name);

    switch (lifecycleState) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Automatically pause running timer upon backgrounding
        if (state.timerStatus == TimerStatus.running) {
          _cancelTimer();
          state = state.copyWith(
            timerStatus: TimerStatus.paused,
            isPausedByLifecycle: true,
          );
        }
        break;

      case AppLifecycleState.resumed:
        // Automatically resume ONLY if paused by lifecycle; respect manual pauses
        if (state.isPausedByLifecycle &&
            state.timerStatus == TimerStatus.paused) {
          startTimer();
        }
        break;

      case AppLifecycleState.detached:
        _cancelTimer();
        break;
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Global provider exposing the [RiverpodCounterNotifier] and its [CounterState].
final counterNotifierProvider =
    NotifierProvider<RiverpodCounterNotifier, CounterState>(
      RiverpodCounterNotifier.new,
    );
