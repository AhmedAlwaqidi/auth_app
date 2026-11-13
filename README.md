# Interactive Counter & Student Auth: GetX vs Riverpod 2.x

This repository presents two independent, side-by-side implementations of the **Interactive Counter with Timer Controls and Application Lifecycle Analysis** in Flutter:
1. **GetX Reactive State Management** (`GetxController` + `Obx`)
2. **Modern Riverpod 2.x State Management** (`Notifier` + `NotifierProvider` + `ConsumerWidget`)

Both implementations share an identical, cohesive user interface and feature parity while maintaining 100% architectural independence. Additionally, this repository includes the **Student Authentication System** (strict MVC + Repository pattern).

---

## Architecture & Directory Structure

```text
lib/
├── main.dart                               # Application entry point with ProviderScope
├── app.dart                                # Root MaterialApp & theme configuration
│
├── shared/                                 # Shared models & reusable presentation
│   ├── models/
│   │   ├── timer_status.dart               # TimerStatus enum (idle, running, paused, stopped)
│   │   └── counter_state.dart              # Immutable CounterState model
│   └── widgets/
│       └── counter_display.dart            # Unified UI layout for both implementations
│
├── getx_counter/                           # --- Version A: GetX Implementation ---
│   ├── controllers/
│   │   └── getx_counter_controller.dart    # GetxController with reactive state & lifecycle
│   └── views/
│       └── getx_counter_page.dart          # Obx reactive UI view
│
├── riverpod_counter/                       # --- Version B: Riverpod 2.x Implementation ---
│   ├── providers/
│   │   └── riverpod_counter_provider.dart  # Notifier + NotifierProvider with immutable state
│   └── views/
│       └── riverpod_counter_page.dart      # ConsumerStatefulWidget view with lifecycle observer
│
├── views/
│   ├── home/
│   │   └── main_navigation_page.dart       # Bottom navigation tab shell connecting all flows
│   └── auth/                               # Student Authentication views
│       ├── login_page.dart
│       ├── register_page.dart
│       ├── forgot_password_page.dart
│       └── reset_password_page.dart
│
├── controllers/                            # AuthController (Student Auth)
├── models/                                 # Student Auth models
├── repositories/                           # AuthRepository & AuthRepositoryImpl
└── utils/                                  # Centralized FormValidators
```

---

## Features & Behavior

Both counter implementations provide identical functionality:
- **Manual Counter Controls**: Increment (`+`), Decrement (`-`), and Reset (`0`).
- **Periodic Timer (1-second interval)**:
  - **Start**: Initiates periodic ticking; prevents duplicate timer creation.
  - **Pause**: Suspends counting without losing accumulated count.
  - **Resume**: Continues periodic ticking from paused count.
  - **Stop**: Cancels scheduled timer callbacks and marks status as stopped.
- **Visual Status Indicators**:
  - Live timer status chip (`IDLE`, `RUNNING`, `PAUSED`, `STOPPED`).
  - Active application lifecycle indicator displaying the most recent `AppLifecycleState`.
  - Distinguishes background lifecycle pauses from user-initiated manual pauses.

---

## Application Lifecycle vs State-Management Lifecycle

A critical requirement of this project is distinguishing between **Application Lifecycle** and **Controller / Provider Lifecycle**:

### 1. Application Lifecycle (`WidgetsBindingObserver`)
Handles operating system and platform events when the Flutter app transitions between foreground and background:
- **`paused` / `inactive` / `hidden` (Backgrounded)**:
  - If a timer is currently `running`, it is automatically cancelled/paused to save battery and system resources.
  - An internal flag (`isPausedByLifecycle = true`) records that the pause was initiated by the system.
- **`resumed` (Foregrounded)**:
  - The application inspects `isPausedByLifecycle`. If the timer was paused due to backgrounding, it automatically resumes ticking.
  - **User Manual Pauses are strictly preserved**: If the user clicked "Pause" before backgrounding, returning to the foreground will **NOT** restart the timer.

### 2. Controller & Provider Lifecycle (Disposal)
- **GetX (`GetxCounterController`)**:
  - Registered via `Get.put(GetxCounterController())`.
  - Observes lifecycle using `WidgetsBindingObserver`.
  - In `onClose()`, the periodic timer is cancelled and `WidgetsBinding.instance.removeObserver(this)` is invoked, preventing memory leaks and callbacks against disposed state.
- **Riverpod (`RiverpodCounterNotifier`)**:
  - Created via `NotifierProvider<RiverpodCounterNotifier, CounterState>`.
  - Uses `ref.onDispose(() { _cancelTimer(); })` to safely shut down background timers whenever the provider is unmounted.
  - Screen lifecycle events are forwarded cleanly from `ConsumerStatefulWidget`'s `WidgetsBindingObserver` to the notifier.

---

## Detailed Comparison: GetX vs Riverpod 2.x

| Feature | Version A: GetX | Version B: Modern Riverpod 2.x |
| :--- | :--- | :--- |
| **State Holder** | `GetxCounterController extends GetxController` | `RiverpodCounterNotifier extends Notifier<CounterState>` |
| **State Mutation** | Mutable reactive observables (`.obs`, `RxInt`, `Rx<TimerStatus>`) | Immutable state model (`CounterState` via `state = state.copyWith(...)`) |
| **Reactive UI Widget** | `Obx(() => ...)` | `ConsumerWidget` / `ConsumerStatefulWidget` |
| **Observing State** | Automatic dependency tracking inside `Obx` | Explicit declaration via `ref.watch(counterNotifierProvider)` |
| **Triggering Actions** | Direct method invocation on `controller` (`controller.increment()`) | Notifier access via `ref.read(counterNotifierProvider.notifier).increment()` |
| **Timer Disposal** | In controller's `onClose()` method | In notifier's `ref.onDispose()` hook |
| **App Lifecycle Binding** | Controller mixes in `WidgetsBindingObserver` | View observes `WidgetsBindingObserver` and dispatches to notifier |
| **Global Context / DI** | Global service locator (`Get.put` / `Get.find`) | Root `ProviderScope` without global singletons |
| **Compile Safety** | Runtime service location | Fully compile-time safe provider tree |

---

## Getting Started & Running the Project

### Prerequisites
- Flutter SDK 3.13+ / 3.47+ (Dart 3.13+)

### Installation
```bash
# Clone the repository
git clone https://github.com/AhmedAlwaqidi/auth_app.git
cd auth_app

# Fetch dependencies
flutter pub get
```

### Running the App
```bash
flutter run
```

### Navigating Between Implementations
The application launches into a unified `MainNavigationPage` with a 3-tab `NavigationBar`:
- **Tab 1 — GetX Counter**: Explore the GetX reactive implementation.
- **Tab 2 — Riverpod Counter**: Explore the modern Riverpod 2.x implementation.
- **Tab 3 — Student Auth**: Access the student authentication portal (Login, Register, Forgot Password, Reset Password).

---

## Verification & Automated Tests

All tests and static analysis pass with zero warnings:

```bash
# Format code
dart format .

# Static analysis
flutter analyze

# Run complete test suite (41 unit and widget tests)
flutter test
```
