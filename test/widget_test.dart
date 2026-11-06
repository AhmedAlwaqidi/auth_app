import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auth_app/app.dart';

void main() {
  testWidgets('StudentAuthApp renders LoginPage with all required components',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAuthApp());
    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('Student Portal'), findsOneWidget);
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Verify form fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Academic ID or University Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify action elements
    expect(find.text('Remember Me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('LoginPage shows validation error on empty submit',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAuthApp());
    await tester.pumpAndSettle();

    // Tap Sign In button without filling form
    final signInButton = find.widgetWithText(FilledButton, 'Sign In');
    expect(signInButton, findsOneWidget);

    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify validation errors are shown
    expect(
      find.text('Academic ID or university email is required.'),
      findsOneWidget,
    );
    expect(find.text('Password is required.'), findsOneWidget);
  });

  testWidgets('Navigation from LoginPage to RegisterPage and back works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAuthApp());
    await tester.pumpAndSettle();

    // Tap Create Account
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // Verify RegisterPage is shown
    expect(find.text('Student Registration'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Academic ID'), findsOneWidget);
    expect(find.text('University Email'), findsOneWidget);
    expect(find.text('I accept the terms and academic regulations.'), findsOneWidget);

    // Tap Back / Sign In link (ensure visible in scroll view)
    final backToLogin = find.widgetWithText(TextButton, 'Sign In');
    await tester.ensureVisible(backToLogin);
    await tester.pumpAndSettle();
    await tester.tap(backToLogin);
    await tester.pumpAndSettle();

    // Back to LoginPage
    expect(find.text('Student Portal'), findsOneWidget);
  });

  testWidgets('Navigation from LoginPage to ForgotPasswordPage and back works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAuthApp());
    await tester.pumpAndSettle();

    // Tap Forgot Password?
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    // Verify ForgotPasswordPage is shown
    expect(find.text('Password Recovery'), findsOneWidget);
    expect(find.text('Simulated Verification Code'), findsOneWidget);
    expect(find.text('Send Verification Code'), findsOneWidget);

    // Tap Back to Login
    await tester.tap(find.text('Back to Login'));
    await tester.pumpAndSettle();

    // Back to LoginPage
    expect(find.text('Student Portal'), findsOneWidget);
  });
}
