import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import 'state/auth_form_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFormController(mode: AuthFormMode.reset),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView();

  void _submit(BuildContext context) {
    final form = context.read<AuthFormController>();
    FocusScope.of(context).unfocus();
    if (!form.validateAll()) return;
    Navigator.of(context).pushNamed(
      AppRoutes.otp,
      arguments: form.contactController.text.trim(),
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
          const AuthTopBar(pillLabel: 'إعادة التعيين'),
          const SizedBox(height: 36),
          Center(
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: BrandPalette.goldMist,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: BrandPalette.goldSoft),
                boxShadow: [
                  BoxShadow(
                    color: BrandPalette.gold.withValues(alpha: 0.16),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.key_rounded,
                size: 30,
                color: BrandPalette.goldDeep,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'استعادة كلمة السر',
            textAlign: TextAlign.center,
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
            'أدخل بريدك الإلكتروني أو رقم هاتفك لإرسال رمز التحقق.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BrandPalette.inkMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
          AppTextField(
            label: 'البريد الإلكتروني أو رقم الهاتف',
            hint: 'example@gmail.com / 01012345678',
            icon: Icons.mark_email_read_outlined,
            controller: form.contactController,
            errorText: form.contactError,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: form.onContactChanged,
            onFocusLost: form.onContactFocusLost,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('reset-submit'),
            label: 'إرسال رمز التحقق',
            subLabel: 'Send Code',
            onPressed: () => _submit(context),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 12),
          AuthFooterPrompt(
            question: 'تذكرت كلمة السر؟',
            action: 'الرجوع لتسجيل الدخول',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}
