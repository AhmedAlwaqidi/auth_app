import 'package:flutter/foundation.dart';

import 'timer_status.dart';

/// Immutable model representing the unified state of the counter and timer.
@immutable
class CounterState {
  /// The current integer counter value.
  final int count;

  /// The active operating status of the periodic timer.
  final TimerStatus timerStatus;

  /// The name of the most recently observed application lifecycle state.
  final String lastLifecycleEvent;

  /// True if the timer was paused automatically by a background lifecycle transition,
  /// rather than intentionally by the user.
  final bool isPausedByLifecycle;

  const CounterState({
    this.count = 0,
    this.timerStatus = TimerStatus.idle,
    this.lastLifecycleEvent = 'resumed',
    this.isPausedByLifecycle = false,
  });

  /// Creates a copy of this state with the given fields replaced by the non-null parameter values.
  CounterState copyWith({
    int? count,
    TimerStatus? timerStatus,
    String? lastLifecycleEvent,
    bool? isPausedByLifecycle,
  }) {
    return CounterState(
      count: count ?? this.count,
      timerStatus: timerStatus ?? this.timerStatus,
      lastLifecycleEvent: lastLifecycleEvent ?? this.lastLifecycleEvent,
      isPausedByLifecycle: isPausedByLifecycle ?? this.isPausedByLifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          timerStatus == other.timerStatus &&
          lastLifecycleEvent == other.lastLifecycleEvent &&
          isPausedByLifecycle == other.isPausedByLifecycle;

  @override
  int get hashCode =>
      Object.hash(count, timerStatus, lastLifecycleEvent, isPausedByLifecycle);

  @override
  String toString() =>
      'CounterState(count: $count, timerStatus: $timerStatus, lastLifecycleEvent: $lastLifecycleEvent, isPausedByLifecycle: $isPausedByLifecycle)';
}
