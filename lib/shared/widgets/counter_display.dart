import 'package:flutter/material.dart';

import '../models/timer_status.dart';

/// Reusable counter and timer UI component shared between GetX and Riverpod views.
///
/// Ensures 100% visual consistency and identical user experience across both implementations.
class CounterDisplay extends StatelessWidget {
  final String frameworkTitle;
  final String frameworkSubtitle;
  final Color frameworkColor;
  final int count;
  final TimerStatus timerStatus;
  final String lastLifecycleEvent;
  final bool isPausedByLifecycle;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onStartTimer;
  final VoidCallback onPauseTimer;
  final VoidCallback onResumeTimer;
  final VoidCallback onStopTimer;

  const CounterDisplay({
    super.key,
    required this.frameworkTitle,
    required this.frameworkSubtitle,
    required this.frameworkColor,
    required this.count,
    required this.timerStatus,
    required this.lastLifecycleEvent,
    required this.isPausedByLifecycle,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResumeTimer,
    required this.onStopTimer,
  });

  Color _getTimerStatusColor(TimerStatus status) {
    switch (status) {
      case TimerStatus.running:
        return Colors.green;
      case TimerStatus.paused:
        return Colors.orange;
      case TimerStatus.stopped:
        return Colors.red;
      case TimerStatus.idle:
        return Colors.grey.shade600;
    }
  }

  IconData _getTimerStatusIcon(TimerStatus status) {
    switch (status) {
      case TimerStatus.running:
        return Icons.timer_outlined;
      case TimerStatus.paused:
        return Icons.pause_circle_outline;
      case TimerStatus.stopped:
        return Icons.stop_circle_outlined;
      case TimerStatus.idle:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getTimerStatusColor(timerStatus);
    final statusIcon = _getTimerStatusIcon(timerStatus);

    final isRunning = timerStatus == TimerStatus.running;
    final isPaused = timerStatus == TimerStatus.paused;
    final isStoppedOrIdle =
        timerStatus == TimerStatus.idle || timerStatus == TimerStatus.stopped;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Framework identification banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: frameworkColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: frameworkColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: frameworkColor,
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            frameworkTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: frameworkColor,
                            ),
                          ),
                          Text(
                            frameworkSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Main Counter Display Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'COUNTER VALUE',
                        style: theme.textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        child: Text(
                          '$count',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: frameworkColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Status row: Timer status & App Lifecycle status
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Timer Status Chip
                          Chip(
                            avatar: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 18,
                            ),
                            label: Text(
                              'Timer: ${timerStatus.name.toUpperCase()}',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: statusColor.withValues(alpha: 0.1),
                            side: BorderSide(
                              color: statusColor.withValues(alpha: 0.3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),

                          // App Lifecycle State Chip
                          Chip(
                            avatar: const Icon(
                              Icons.sync,
                              color: Colors.blue,
                              size: 18,
                            ),
                            label: Text(
                              'Lifecycle: $lastLifecycleEvent',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            side: BorderSide(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ],
                      ),
                      if (isPausedByLifecycle) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.amber.shade900,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Paused by application backgrounding',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Manual Counter Controls Section
              Text(
                'Manual Counter Controls',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                      style: FilledButton.styleFrom(
                        backgroundColor: frameworkColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Periodic Timer Controls Section
              Text(
                'Periodic Timer Controls (1s Interval)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  // Start Timer
                  SizedBox(
                    width: 135,
                    child: ElevatedButton.icon(
                      onPressed: isStoppedOrIdle ? onStartTimer : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Pause Timer
                  SizedBox(
                    width: 135,
                    child: ElevatedButton.icon(
                      onPressed: isRunning ? onPauseTimer : null,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Resume Timer
                  SizedBox(
                    width: 135,
                    child: ElevatedButton.icon(
                      onPressed: isPaused ? onResumeTimer : null,
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Stop Timer
                  SizedBox(
                    width: 135,
                    child: ElevatedButton.icon(
                      onPressed: (isRunning || isPaused) ? onStopTimer : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Educational Lifecycle Explanation Box
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Lifecycle Analysis Policy: Backgrounding the app pauses an active timer automatically to preserve battery and resources. Returning to foreground auto-resumes only if paused by lifecycle; user manual pauses are strictly preserved.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
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
}
