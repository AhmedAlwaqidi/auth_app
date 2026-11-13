import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auth_app/getx_counter/controllers/getx_counter_controller.dart';
import 'package:auth_app/riverpod_counter/providers/riverpod_counter_provider.dart';
import 'package:auth_app/shared/models/timer_status.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetxCounterController Unit Tests', () {
    late GetxCounterController controller;

    setUp(() {
      controller = GetxCounterController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('Initial state: count is 0, timer is idle, no lifecycle pause', () {
      expect(controller.count.value, 0);
      expect(controller.timerStatus.value, TimerStatus.idle);
      expect(controller.isPausedByLifecycle.value, isFalse);
    });

    test('increment and decrement update count correctly', () {
      controller.increment();
      expect(controller.count.value, 1);

      controller.increment();
      expect(controller.count.value, 2);

      controller.decrement();
      expect(controller.count.value, 1);
    });

    test('reset clears count and timer status', () {
      controller.increment();
      controller.increment();
      expect(controller.count.value, 2);

      controller.reset();
      expect(controller.count.value, 0);
      expect(controller.timerStatus.value, TimerStatus.idle);
      expect(controller.isPausedByLifecycle.value, isFalse);
    });

    test('timer lifecycle: start, pause, resume, and stop', () async {
      controller.startTimer();
      expect(controller.timerStatus.value, TimerStatus.running);

      // Verify repeated start does not duplicate timer or change running state
      controller.startTimer();
      expect(controller.timerStatus.value, TimerStatus.running);

      controller.pauseTimer();
      expect(controller.timerStatus.value, TimerStatus.paused);
      expect(controller.isPausedByLifecycle.value, isFalse);

      controller.resumeTimer();
      expect(controller.timerStatus.value, TimerStatus.running);

      controller.stopTimer();
      expect(controller.timerStatus.value, TimerStatus.stopped);
    });

    test('lifecycle backgrounding pauses running timer and auto-resumes on foreground', () {
      controller.startTimer();
      expect(controller.timerStatus.value, TimerStatus.running);

      // Simulate app backgrounding
      controller.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(controller.timerStatus.value, TimerStatus.paused);
      expect(controller.isPausedByLifecycle.value, isTrue);
      expect(controller.lastLifecycleEvent.value, 'paused');

      // Simulate app returning to foreground
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(controller.timerStatus.value, TimerStatus.running);
      expect(controller.isPausedByLifecycle.value, isFalse);
    });

    test('lifecycle backgrounding does not auto-resume if manually paused', () {
      controller.startTimer();
      controller.pauseTimer(); // user manually paused
      expect(controller.timerStatus.value, TimerStatus.paused);
      expect(controller.isPausedByLifecycle.value, isFalse);

      // Simulate backgrounding
      controller.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(controller.timerStatus.value, TimerStatus.paused);
      expect(controller.isPausedByLifecycle.value, isFalse);

      // Simulate foregrounding -> should STAY paused!
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(controller.timerStatus.value, TimerStatus.paused);
    });
  });

  group('RiverpodCounterNotifier Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state: count is 0, timer is idle, no lifecycle pause', () {
      final state = container.read(counterNotifierProvider);
      expect(state.count, 0);
      expect(state.timerStatus, TimerStatus.idle);
      expect(state.isPausedByLifecycle, isFalse);
    });

    test('increment and decrement update count correctly', () {
      final notifier = container.read(counterNotifierProvider.notifier);

      notifier.increment();
      expect(container.read(counterNotifierProvider).count, 1);

      notifier.increment();
      expect(container.read(counterNotifierProvider).count, 2);

      notifier.decrement();
      expect(container.read(counterNotifierProvider).count, 1);
    });

    test('reset clears count and timer status', () {
      final notifier = container.read(counterNotifierProvider.notifier);

      notifier.increment();
      notifier.increment();
      expect(container.read(counterNotifierProvider).count, 2);

      notifier.reset();
      final state = container.read(counterNotifierProvider);
      expect(state.count, 0);
      expect(state.timerStatus, TimerStatus.idle);
      expect(state.isPausedByLifecycle, isFalse);
    });

    test('timer lifecycle: start, pause, resume, and stop', () {
      final notifier = container.read(counterNotifierProvider.notifier);

      notifier.startTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.running,
      );

      // Repeated start should not duplicate
      notifier.startTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.running,
      );

      notifier.pauseTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.paused,
      );
      expect(
        container.read(counterNotifierProvider).isPausedByLifecycle,
        isFalse,
      );

      notifier.resumeTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.running,
      );

      notifier.stopTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.stopped,
      );
    });

    test('lifecycle backgrounding pauses running timer and auto-resumes on foreground', () {
      final notifier = container.read(counterNotifierProvider.notifier);

      notifier.startTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.running,
      );

      // App backgrounding
      notifier.handleLifecycleChange(AppLifecycleState.paused);
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.paused,
      );
      expect(
        container.read(counterNotifierProvider).isPausedByLifecycle,
        isTrue,
      );

      // App foregrounding -> auto resumes
      notifier.handleLifecycleChange(AppLifecycleState.resumed);
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.running,
      );
      expect(
        container.read(counterNotifierProvider).isPausedByLifecycle,
        isFalse,
      );
    });

    test('lifecycle backgrounding does not auto-resume if manually paused', () {
      final notifier = container.read(counterNotifierProvider.notifier);

      notifier.startTimer();
      notifier.pauseTimer();
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.paused,
      );
      expect(
        container.read(counterNotifierProvider).isPausedByLifecycle,
        isFalse,
      );

      // App backgrounding
      notifier.handleLifecycleChange(AppLifecycleState.paused);
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.paused,
      );

      // App foregrounding -> remains paused
      notifier.handleLifecycleChange(AppLifecycleState.resumed);
      expect(
        container.read(counterNotifierProvider).timerStatus,
        TimerStatus.paused,
      );
    });
  });
}
