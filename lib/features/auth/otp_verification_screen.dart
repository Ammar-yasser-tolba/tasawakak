import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';
import '../../core/widgets/auth_scaffold.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.contact});

  final String contact;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _codeLength = 6;
  static const Duration _resendWindow = Duration(minutes: 5);
  static const Duration _autoVerifyDelay = Duration(milliseconds: 1100);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _countdownTimer;
  Timer? _autoVerifyTimer;

  int _secondsLeft = _resendWindow.inSeconds;
  bool _isComplete = false;
  bool _navigated = false;

  String get _code => _controller.text;
  bool get _isEmail => widget.contact.contains('@');
  bool get _isFocused => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onCodeChanged);
    _focusNode.addListener(_onFocusChanged);
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _autoVerifyTimer?.cancel();
    _controller
      ..removeListener(_onCodeChanged)
      ..dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  void _onCodeChanged() {
    final complete = _controller.text.length == _codeLength;
    setState(() => _isComplete = complete);

    _autoVerifyTimer?.cancel();
    if (!complete) return;

    _focusNode.unfocus();
    HapticFeedback.mediumImpact();
    _autoVerifyTimer = Timer(_autoVerifyDelay, _goToSuccess);
  }

  void _goToSuccess() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed(AppRoutes.success);
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _secondsLeft = _resendWindow.inSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _resendCode() {
    if (_secondsLeft > 0) return;
    _autoVerifyTimer?.cancel();
    _controller.clear();
    setState(() => _isComplete = false);
    _startCountdown();
    _focusNode.requestFocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('تم إعادة إرسال رمز التحقق.')),
      );
  }

  String get _countdownLabel {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact.trim().isEmpty
        ? 'بيانات حسابك'
        : widget.contact.trim();

    return AuthScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTopBar(pillLabel: 'رمز التحقق'),
          const SizedBox(height: 30),
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
                Icons.sms_outlined,
                size: 28,
                color: BrandPalette.goldDeep,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'أدخل رمز التحقق',
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
            'تم إرسال رمز التحقق إلى',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BrandPalette.inkMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: _ContactPill(
              contact: contact,
              isEmail: _isEmail,
              highlighted: _isComplete,
            ),
          ),
          const SizedBox(height: 30),
          _buildOtpBoxes(),
          const SizedBox(height: 20),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _secondsLeft > 0
                  ? Text.rich(
                      key: const ValueKey('otp-countdown'),
                      TextSpan(
                        text: 'إعادة الإرسال خلال ',
                        children: [
                          TextSpan(
                            text: _countdownLabel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: BrandPalette.navy,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: BrandPalette.hint,
                      ),
                    )
                  : TextButton(
                      key: const ValueKey('otp-resend'),
                      onPressed: _resendCode,
                      style: TextButton.styleFrom(
                        foregroundColor: BrandPalette.goldDeep,
                        textStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const Text('لم تستلم الرمز؟ إعادة الإرسال'),
                    ),
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: Text(
                _isComplete
                    ? 'تم إدخال الرمز، جارٍ التحقق...'
                    : 'سيتم التحقق تلقائياً بعد إدخال الرمز',
                key: ValueKey(_isComplete),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _isComplete
                      ? BrandPalette.success
                      : BrandPalette.hint,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 12),
          AuthFooterPrompt(
            question: 'تريد تغيير البيانات؟',
            action: 'الرجوع للسابق',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final boxSize = math.min(
          54.0,
          (constraints.maxWidth - gap * (_codeLength - 1)) / _codeLength,
        );

        return SizedBox(
          height: boxSize,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      key: const Key('otp-input'),
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(_codeLength),
                      ],
                      showCursor: false,
                      enableInteractiveSelection: false,
                      style: const TextStyle(
                        fontSize: 1,
                        color: Colors.transparent,
                      ),
                      cursorColor: Colors.transparent,
                      onSubmitted: (_) {
                        if (_isComplete) _goToSuccess();
                      },
                      decoration: const InputDecoration(
                        filled: false,
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: AnimatedScale(
                      scale: _isComplete ? 1.015 : 1,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutBack,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var i = 0; i < _codeLength; i++)
                            KeyedSubtree(
                              key: ValueKey('otp-box-$i'),
                              child: _OtpBox(
                                digit: i < _code.length ? _code[i] : null,
                                isActive: !_isComplete &&
                                    _isFocused &&
                                    i == _code.length,
                                isComplete: _isComplete,
                                size: boxSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.digit,
    required this.isActive,
    required this.isComplete,
    required this.size,
  });

  final String? digit;
  final bool isActive;
  final bool isComplete;
  final double size;

  @override
  Widget build(BuildContext context) {
    final filled = digit != null;

    final Color borderColor;
    if (isComplete) {
      borderColor = BrandPalette.success;
    } else if (isActive) {
      borderColor = BrandPalette.goldDeep;
    } else if (filled) {
      borderColor = BrandPalette.gold;
    } else {
      borderColor = BrandPalette.border;
    }

    final Color fillColor;
    if (isComplete) {
      fillColor = BrandPalette.successMist;
    } else if (filled || isActive) {
      fillColor = BrandPalette.goldMist;
    } else {
      fillColor = Colors.white;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: isComplete || isActive ? 1.8 : 1.2,
        ),
        boxShadow: [
          if (isComplete)
            BoxShadow(
              color: BrandPalette.success.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          else if (isActive || filled)
            BoxShadow(
              color: BrandPalette.gold.withValues(alpha: 0.14),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.86, end: 1).animate(animation),
              child: child,
            ),
          );
        },
        child: filled
            ? Text(
                digit!,
                key: ValueKey(digit),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w800,
                  color:
                      isComplete ? BrandPalette.success : BrandPalette.navy,
                  height: 1,
                ),
              )
            : isActive
                ? Container(
                    key: const ValueKey('caret'),
                    width: 2,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      color: BrandPalette.goldDeep,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}

class _ContactPill extends StatelessWidget {
  const _ContactPill({
    required this.contact,
    required this.isEmail,
    required this.highlighted,
  });

  final String contact;
  final bool isEmail;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted ? BrandPalette.successMist : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted ? BrandPalette.success : BrandPalette.goldSoft,
        ),
        boxShadow: [
          BoxShadow(
            color: BrandPalette.navy.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEmail
                  ? Icons.alternate_email_rounded
                  : Icons.smartphone_rounded,
              size: 16,
              color: highlighted
                  ? BrandPalette.success
                  : BrandPalette.goldDeep,
            ),
            const SizedBox(width: 8),
            Text(
              contact,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: BrandPalette.navy,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
