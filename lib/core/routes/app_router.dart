import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/success_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'route_names.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _fadeSlide(const LoginScreen());
      case AppRoutes.signup:
        return _fadeSlide(const SignUpScreen());
      case AppRoutes.reset:
        return _fadeSlide(const ResetPasswordScreen());
      case AppRoutes.otp:
        return _fadeSlide(
          OtpVerificationScreen(
            contact: settings.arguments is String
                ? settings.arguments as String
                : '',
          ),
        );
      case AppRoutes.success:
        return _fadeScale(
          SuccessScreen(fromCreateAccount: settings.arguments == true),
        );
      case AppRoutes.splash:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }

  static PageRoute<T> _fadeSlide<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static PageRoute<T> _fadeScale<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 520),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
