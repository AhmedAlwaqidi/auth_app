/// Represents the current operating state of the periodic counter timer.
enum TimerStatus {
  /// The timer has not been started yet or was reset.
  idle,

  /// The timer is actively ticking and incrementing the counter.
  running,

  /// The timer is paused; counting is suspended without losing current count.
  paused,

  /// The timer was explicitly stopped.
  stopped,
}
