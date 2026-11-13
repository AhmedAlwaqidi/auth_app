import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/counter_display.dart';
import '../controllers/getx_counter_controller.dart';

/// Screen presenting the Interactive Counter using GetX state management.
class GetxCounterPage extends StatelessWidget {
  const GetxCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put or retrieve the controller
    final controller = Get.put(GetxCounterController());

    return Scaffold(
      appBar: AppBar(title: const Text('GetX Counter'), centerTitle: true),
      body: SafeArea(
        child: Obx(
          () => CounterDisplay(
            frameworkTitle: 'GetX Implementation',
            frameworkSubtitle: 'GetxController + Obx Reactive State',
            frameworkColor: const Color(0xFF673AB7), // Deep Purple
            count: controller.count.value,
            timerStatus: controller.timerStatus.value,
            lastLifecycleEvent: controller.lastLifecycleEvent.value,
            isPausedByLifecycle: controller.isPausedByLifecycle.value,
            onIncrement: controller.increment,
            onDecrement: controller.decrement,
            onReset: controller.reset,
            onStartTimer: controller.startTimer,
            onPauseTimer: controller.pauseTimer,
            onResumeTimer: controller.resumeTimer,
            onStopTimer: controller.stopTimer,
          ),
        ),
      ),
    );
  }
}
