import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasawakak/app.dart';
import 'package:tasawakak/core/brand/brand_palette.dart';
import 'package:tasawakak/core/validation/auth_validators.dart';

void _configureView(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  _configureView(tester);
  await tester.pumpWidget(const TasawakakApp());
  await tester.pump();
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('AuthValidators', () {
    test('requires a full name', () {
      expect(AuthValidators.fullName('أحمد محمود'), isNull);
      expect(AuthValidators.fullName('Ahmed'), isNull);
      expect(AuthValidators.fullName('   '), AuthValidators.nameMessage);
    });

    test('accepts only @gmail.com emails', () {
      expect(AuthValidators.email('shopper@gmail.com'), isNull);
      expect(AuthValidators.email('  SHOPPER@GMAIL.COM  '), isNull);

      expect(
        AuthValidators.email('shopper@yahoo.com'),
        AuthValidators.emailMessage,
      );
      expect(
        AuthValidators.email('shopper@gmail.co'),
        AuthValidators.emailMessage,
      );
      expect(
        AuthValidators.email('@gmail.com'),
        AuthValidators.emailMessage,
      );
      expect(
        AuthValidators.email('shop per@gmail.com'),
        AuthValidators.emailMessage,
      );
      expect(AuthValidators.email(''), AuthValidators.emailMessage);
    });

    test('accepts exactly 11 digits for phone numbers', () {
      expect(AuthValidators.phone('01012345678'), isNull);
      expect(AuthValidators.phone('0101234567'), AuthValidators.phoneMessage);
      expect(AuthValidators.phone('010123456789'), AuthValidators.phoneMessage);
      expect(AuthValidators.phone('0101234567a'), AuthValidators.phoneMessage);
      expect(AuthValidators.phone(''), AuthValidators.phoneMessage);
    });

    test('enforces password length, uppercase and number', () {
      expect(AuthValidators.password('Passwor1'), isNull);
      expect(AuthValidators.password('Abcdef1'), isNull);

      expect(AuthValidators.password('Abcde1'), AuthValidators.passwordMessage);
      expect(AuthValidators.password('password1'), AuthValidators.passwordMessage);
      expect(AuthValidators.password('PASSWORD'), AuthValidators.passwordMessage);
      expect(AuthValidators.password('Password'), AuthValidators.passwordMessage);
    });

    test('requires confirm password to match', () {
      expect(AuthValidators.confirmPassword('Passwor1', 'Passwor1'), isNull);
      expect(
        AuthValidators.confirmPassword('', 'Passwor1'),
        AuthValidators.confirmPasswordRequiredMessage,
      );
      expect(
        AuthValidators.confirmPassword('Passwor2', 'Passwor1'),
        AuthValidators.confirmPasswordMessage,
      );
    });

    test('email or phone accepts both formats', () {
      expect(AuthValidators.emailOrPhone('shopper@gmail.com'), isNull);
      expect(AuthValidators.emailOrPhone('01012345678'), isNull);
      expect(
        AuthValidators.emailOrPhone('shopper@yahoo.com'),
        AuthValidators.emailMessage,
      );
      expect(
        AuthValidators.emailOrPhone('12345'),
        AuthValidators.phoneMessage,
      );
    });
  });

  group('Splash', () {
    testWidgets('completes the 2.5s staged animation and opens login',
        (tester) async {
      _configureView(tester);
      await tester.pumpWidget(const TasawakakApp());
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('أهلاً بك مجدداً!'), findsNothing);

      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();

      expect(find.text('أهلاً بك مجدداً!'), findsOneWidget);
      expect(find.byKey(const Key('login-submit')), findsOneWidget);
    });

    testWidgets('holds a fixed icon, then reveals text below it after 1.5s',
        (tester) async {
      _configureView(tester);
      await tester.pumpWidget(const TasawakakApp());
      await tester.pump();

      final icon = find.byKey(const Key('splash-icon'));
      final text = find.byKey(const Key('splash-text'));
      expect(icon, findsOneWidget);
      expect(text, findsOneWidget);
      expect(tester.widget<Opacity>(icon).opacity, 0.0);
      expect(tester.widget<Opacity>(text).opacity, 0.0);

      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.widget<Opacity>(icon).opacity, greaterThan(0.5));
      expect(tester.widget<Opacity>(text).opacity, 0.0);

      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.widget<Opacity>(icon).opacity, 1.0);
      expect(tester.widget<Opacity>(text).opacity, 0.0);
      final fixedCenter = tester.getCenter(icon);

      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.widget<Opacity>(text).opacity, 0.0);
      expect(tester.getCenter(icon), fixedCenter);

      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.widget<Opacity>(text).opacity, greaterThan(0.0));
      expect(tester.getCenter(icon), fixedCenter);

      await tester.pump(const Duration(milliseconds: 400));
      final midReveal = tester.widget<Opacity>(text).opacity;
      expect(midReveal, greaterThan(0.0));
      expect(midReveal, lessThan(1.0));
      expect(tester.getCenter(icon), fixedCenter);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('أهلاً بك مجدداً!'), findsOneWidget);
    });
  });

  group('Authentication flows', () {
    testWidgets('login uses a single email-or-phone field', (tester) async {
      await _pumpApp(tester);

      expect(find.text('البريد الإلكتروني أو رقم الهاتف'), findsOneWidget);
      expect(find.text('رقم الهاتف'), findsNothing);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('login shows the exact inline errors for empty fields',
        (tester) async {
      await _pumpApp(tester);

      await _tapVisible(tester, find.byKey(const Key('login-submit')));

      expect(find.text(AuthValidators.phoneMessage), findsOneWidget);
      expect(find.text(AuthValidators.passwordMessage), findsOneWidget);
      expect(find.text('Wait until complete'), findsNothing);
    });

    testWidgets('login validates password in real time', (tester) async {
      await _pumpApp(tester);
      final passwordField = find.byType(TextField).at(1);

      await tester.enterText(passwordField, 'weakpass');
      await tester.pump();
      expect(find.text(AuthValidators.passwordMessage), findsOneWidget);

      await tester.enterText(passwordField, 'Weakpass1');
      await tester.pump();
      expect(find.text(AuthValidators.passwordMessage), findsNothing);
    });

    testWidgets('login with an email reaches Wait until complete',
        (tester) async {
      await _pumpApp(tester);
      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'shopper@gmail.com');
      await tester.enterText(fields.at(1), 'Shopping1');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('login-submit')));

      expect(find.text('Wait until complete'), findsOneWidget);
      expect(find.byKey(const Key('login-submit')), findsNothing);

      final check = tester.widget<Icon>(find.byIcon(Icons.check_rounded));
      expect(check.color, BrandPalette.navy);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Wait until complete'), findsNothing);
      expect(find.byKey(const Key('login-submit')), findsOneWidget);
    });

    testWidgets('login accepts an 11 digit phone number', (tester) async {
      await _pumpApp(tester);
      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), '01012345678');
      await tester.enterText(fields.at(1), 'Shopping1');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('login-submit')));

      expect(find.text('Wait until complete'), findsOneWidget);
    });

    testWidgets('login contact field caps phone input at 11 digits',
        (tester) async {
      await _pumpApp(tester);
      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), '010123456789');
      await tester.enterText(fields.at(1), 'Shopping1');
      await tester.pump();

      final field = tester.widget<TextField>(fields.at(0));
      expect(field.controller?.text, '01012345678');

      await _tapVisible(tester, find.byKey(const Key('login-submit')));
      expect(find.text('Wait until complete'), findsOneWidget);
    });

    testWidgets('sign up exposes five dedicated fields', (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('إنشاء حساب جديد'));

      expect(find.text('انضم إلى عالم تسوقك'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(5));
      expect(find.text('الاسم الكامل'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('رقم الهاتف'), findsOneWidget);
      expect(find.text('كلمة السر'), findsOneWidget);
      expect(find.text('تأكيد كلمة السر'), findsOneWidget);
    });

    testWidgets('sign up validation blocks an invalid submission',
        (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('إنشاء حساب جديد'));

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), 'shopper@yahoo.com');
      await tester.enterText(fields.at(2), '123');
      await tester.enterText(fields.at(3), 'short');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('signup-submit')));

      expect(find.text(AuthValidators.nameMessage), findsOneWidget);
      expect(find.text(AuthValidators.emailMessage), findsOneWidget);
      expect(find.text(AuthValidators.phoneMessage), findsOneWidget);
      expect(find.text(AuthValidators.passwordMessage), findsOneWidget);
      expect(
        find.text(AuthValidators.confirmPasswordRequiredMessage),
        findsOneWidget,
      );
      expect(find.text('Wait until complete'), findsNothing);
    });

    testWidgets('sign up rejects mismatched passwords', (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('إنشاء حساب جديد'));

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'أحمد محمود');
      await tester.enterText(fields.at(1), 'new.shopper@gmail.com');
      await tester.enterText(fields.at(2), '01198765432');
      await tester.enterText(fields.at(3), 'Boutique7');
      await tester.enterText(fields.at(4), 'Boutique8');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('signup-submit')));

      expect(find.text(AuthValidators.confirmPasswordMessage), findsOneWidget);
      expect(find.text('Wait until complete'), findsNothing);
    });

    testWidgets('sign up with valid data shows the account success state',
        (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('إنشاء حساب جديد'));

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'أحمد محمود');
      await tester.enterText(fields.at(1), 'new.shopper@gmail.com');
      await tester.enterText(fields.at(2), '01198765432');
      await tester.enterText(fields.at(3), 'Boutique7');
      await tester.enterText(fields.at(4), 'Boutique7');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('signup-submit')));

      expect(find.text('create account successful'), findsOneWidget);
      expect(find.text('Wait until complete'), findsNothing);

      final check = tester.widget<Icon>(find.byIcon(Icons.check_rounded));
      expect(check.color, BrandPalette.success);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('create account successful'), findsNothing);
      expect(find.byKey(const Key('login-submit')), findsOneWidget);
    });

    testWidgets('reset password validates email and phone', (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('نسيت كلمة السر؟'));

      expect(find.text('استعادة كلمة السر'), findsOneWidget);

      final field = find.byType(TextField);
      await tester.enterText(field, 'not-an-email');
      await tester.pump();
      expect(find.text(AuthValidators.phoneMessage), findsOneWidget);

      await tester.enterText(field, 'shopper@yahoo.com');
      await tester.pump();
      expect(find.text(AuthValidators.emailMessage), findsOneWidget);
    });

    testWidgets('reset opens OTP verification with the entered contact',
        (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('نسيت كلمة السر؟'));

      await tester.enterText(find.byType(TextField), 'shopper@gmail.com');
      await tester.pump();

      await _tapVisible(tester, find.byKey(const Key('reset-submit')));

      expect(find.text('أدخل رمز التحقق'), findsOneWidget);
      expect(find.text('shopper@gmail.com'), findsOneWidget);
      expect(find.text('Wait until complete'), findsNothing);

      for (var i = 0; i < 6; i++) {
        expect(find.byKey(ValueKey('otp-box-$i')), findsOneWidget);
      }
    });

    testWidgets('OTP turns all boxes green and auto-navigates to completion',
        (tester) async {
      await _pumpApp(tester);
      await _tapVisible(tester, find.text('نسيت كلمة السر؟'));

      await tester.enterText(find.byType(TextField), '01012345678');
      await tester.pump();
      await _tapVisible(tester, find.byKey(const Key('reset-submit')));

      expect(find.text('01012345678'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('otp-input')), '123456');
      await tester.pump(const Duration(milliseconds: 400));

      for (var i = 0; i < 6; i++) {
        final box = find.byKey(ValueKey('otp-box-$i'));
        final container = tester.widget<AnimatedContainer>(
          find.descendant(of: box, matching: find.byType(AnimatedContainer)),
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.border!.top.color, BrandPalette.success);
      }

      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.text('Wait until complete'), findsOneWidget);
    });
  });
}
