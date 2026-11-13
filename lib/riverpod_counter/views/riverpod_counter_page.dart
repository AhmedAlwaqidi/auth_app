import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/counter_display.dart';
import '../providers/riverpod_counter_provider.dart';

/// Screen presenting the Interactive Counter using Riverpod 2.x state management.
class RiverpodCounterPage extends ConsumerStatefulWidget {
  const RiverpodCounterPage({super.key});

  @override
  ConsumerState<RiverpodCounterPage> createState() =>
      _RiverpodCounterPageState();
}

class _RiverpodCounterPageState extends ConsumerState<RiverpodCounterPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(counterNotifierProvider.notifier).handleLifecycleChange(state);
  }

  @override
  Widget build(BuildContext context) {
    final counterState = ref.watch(counterNotifierProvider);
    final notifier = ref.read(counterNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Counter'), centerTitle: true),
      body: SafeArea(
        child: CounterDisplay(
          frameworkTitle: 'Riverpod 2.x Implementation',
          frameworkSubtitle: 'Notifier + ConsumerWidget State',
          frameworkColor: const Color(0xFF00897B), // Teal
          count: counterState.count,
          timerStatus: counterState.timerStatus,
          lastLifecycleEvent: counterState.lastLifecycleEvent,
          isPausedByLifecycle: counterState.isPausedByLifecycle,
          onIncrement: notifier.increment,
          onDecrement: notifier.decrement,
          onReset: notifier.reset,
          onStartTimer: notifier.startTimer,
          onPauseTimer: notifier.pauseTimer,
          onResumeTimer: notifier.resumeTimer,
          onStopTimer: notifier.stopTimer,
        ),
      ),
    );
  }
}
