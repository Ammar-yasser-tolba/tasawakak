import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';
import '../../core/validation/contact_input_formatter.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_scaffold.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/primary_button.dart';
import 'state/auth_form_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFormController(mode: AuthFormMode.login),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  bool _obscurePassword = true;

  void _submit() {
    final form = context.read<AuthFormController>();
    FocusScope.of(context).unfocus();
    if (!form.validateAll()) return;
    Navigator.of(context).pushNamed(AppRoutes.success);
  }

  void _showGoogleNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('المتابعة عبر Google ستكون متاحة قريباً.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormController>();

    return AuthScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          const Center(child: BrandLogo(size: 96)),
          const SizedBox(height: 18),
          const Center(child: BrandWordmark()),
          const SizedBox(height: 32),
          const Text(
            'أهلاً بك مجدداً!',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: BrandPalette.navy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'سجّل الدخول لمتابعة تسوق أحدث الصيحات.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BrandPalette.inkMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: 'البريد الإلكتروني أو رقم الهاتف',
            hint: 'you@gmail.com / 01012345678',
            icon: Icons.alternate_email_rounded,
            controller: form.contactController,
            errorText: form.contactError,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [EmailOrPhoneInputFormatter()],
            autofillHints: const [AutofillHints.username],
            onChanged: form.onContactChanged,
            onFocusLost: form.onContactFocusLost,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'كلمة السر',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            controller: form.passwordController,
            errorText: form.passwordError,
            obscureText: _obscurePassword,
            onToggleObscure: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            autofillHints: const [AutofillHints.password],
            onChanged: form.onPasswordChanged,
            onFocusLost: form.onPasswordFocusLost,
            textInputAction: TextInputAction.done,
            labelTrailing: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.reset),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                minimumSize: const Size(0, 26),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: BrandPalette.goldDeep,
                textStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('نسيت كلمة السر؟'),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('login-submit'),
            label: 'تسجيل الدخول',
            onPressed: _submit,
          ),
          const SizedBox(height: 24),
          const OrDivider(),
          const SizedBox(height: 16),
          GoogleSignInButton(onPressed: _showGoogleNotice),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 12),
          AuthFooterPrompt(
            question: 'ليس لديك حساب؟',
            action: 'إنشاء حساب جديد',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.signup),
          ),
        ],
      ),
    );
  }
}
