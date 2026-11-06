import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

/// Root application widget that configures theme, manages [AuthController] lifecycle,
/// and establishes initial route to [LoginPage].
class StudentAuthApp extends StatefulWidget {
  final AuthRepository? repository;

  const StudentAuthApp({
    super.key,
    this.repository,
  });

  @override
  State<StudentAuthApp> createState() => _StudentAuthAppState();
}

class _StudentAuthAppState extends State<StudentAuthApp> {
  late final AuthRepository _repository;
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? AuthRepositoryImpl();
    _controller = AuthController(repository: _repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E3A8A), // Academic Navy Blue
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Student Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorScheme.error),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 1,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: LoginPage(controller: _controller),
    );
  }
}

