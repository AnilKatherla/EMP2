import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'reset_password_screen.dart';

// ── LOCAL COLORS ──────────────────────────────────────────────────────────────
abstract class _C {
  static const Color scaffoldBg    = Color(0xFFF4F6FA);
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color primary       = Color(0xFF0070F3);
  static const Color primaryLight  = Color(0xFF3B9EFF);
  static const Color primaryGlow   = Color(0xFFD0E8FF);
  static const Color textPrimary   = Color(0xFF0F1629);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted     = Color(0xFF94A3B8);
  static const Color borderDefault = Color(0xFFE2E8F0);
  static const Color borderFocus   = Color(0xFF0070F3);
  static const Color error         = Color(0xFFEF4444);
  static const Color success       = Color(0xFF22C55E);
  static const Color shadowSoft    = Color(0x14000000);
  static const Color shadowMedium  = Color(0x1F000000);
}

// ── OTP SCREEN ────────────────────────────────────────────────────────────────
class OtpScreen extends StatefulWidget {
  /// The email or phone passed from ForgotPasswordScreen.
  final String identifier;

  const OtpScreen({super.key, required this.identifier});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  // 4-box OTP
  final List<TextEditingController> _ctrls =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  // Countdown timer
  int  _secondsLeft = 60;
  bool _canResend   = false;

  // Pulsing halo animation for the badge
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  // Static OTP for demo
  static const _staticOtp = '1234';

  @override
  void initState() {
    super.initState();
    _startCountdown();
    for (final c in _ctrls) {
      c.addListener(() => setState(() {}));
    }
  }

  void _startCountdown() {
    setState(() { _secondsLeft = 60; _canResend = false; });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) _canResend = true;
      });
      return _secondsLeft > 0;
    });
  }

  String get _otpValue => _ctrls.map((c) => c.text).join();
  bool   get _isFilled => _otpValue.length == 4;

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> _onVerify() async {
    if (!_isFilled) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_otpValue == _staticOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            identifier: widget.identifier,
          ),
        ),
      );
    } else {
      _showSnack('Incorrect OTP. Hint: use 1234');
      for (final c in _ctrls) c.clear();
      _nodes[0].requestFocus();
    }
  }

  void _onResend() {
    for (final c in _ctrls) c.clear();
    _nodes[0].requestFocus();
    _startCountdown();
    _showSnack('OTP resent! (static: 1234)', isError: false);
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? _C.error : _C.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq    = MediaQuery.of(context);
    final width = mq.size.width;
    final hPad  = (width * 0.05).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: _C.scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background blobs ─────────────────────────────────────────
          _BackgroundDecoration(pulseCtrl: _pulseCtrl),

          // ── Scrollable card ─────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical:   AppSpacing.xl5,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                decoration: BoxDecoration(
                  color:        _C.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border:       Border.all(color: _C.borderDefault),
                  boxShadow: const [
                    BoxShadow(color: _C.shadowSoft,   blurRadius: 24, offset: Offset(0, 8)),
                    BoxShadow(color: _C.shadowMedium, blurRadius: 48, offset: Offset(0, 24)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    (width * 0.10).clamp(24.0, 36.0),
                    AppSpacing.xl4,
                    (width * 0.10).clamp(24.0, 36.0),
                    AppSpacing.xl3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Logo badge (envelope icon) ─────────────
                      _OtpLogoBadge(pulseCtrl: _pulseCtrl),
                      const SizedBox(height: 12),

                      // ── Brand ──────────────────────────────────
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Track',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: _C.textPrimary, letterSpacing: 0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Force',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: _C.primary, letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ── Subtitle ───────────────────────────────
                      Text(
                        'OTP Verification',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _C.textSecondary, letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Code sent to ${widget.identifier}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _C.primary, fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Section divider ────────────────────────
                      const _SectionDivider(label: 'ENTER CODE'),
                      const SizedBox(height: 28),

                      // ── OTP boxes ──────────────────────────────
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final boxSize =
                              ((constraints.maxWidth - 48) / 4).clamp(52.0, 68.0);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (i) {
                              return _OtpBox(
                                controller: _ctrls[i],
                                focusNode:  _nodes[i],
                                size:       boxSize,
                                onChanged:  (val) {
                                  if (val.isNotEmpty && i < 3) {
                                    _nodes[i + 1].requestFocus();
                                  } else if (val.isEmpty && i > 0) {
                                    _nodes[i - 1].requestFocus();
                                  }
                                },
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: 10),

                      // ── Hint text ──────────────────────────────
                      Text(
                        'Demo OTP: 1 2 3 4',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _C.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Verify button ──────────────────────────
                      _PrimaryButton(
                        label:     'Verify Code',
                        icon:      Icons.verified_outlined,
                        isLoading: _isLoading,
                        disabled:  !_isFilled || _isLoading,
                        onTap:     _onVerify,
                      ),
                      const SizedBox(height: 24),

                      // ── Resend / countdown ─────────────────────
                      _canResend
                          ? GestureDetector(
                              onTap: _onResend,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  color:        _C.primaryGlow,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _C.primary.withOpacity(0.30),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.refresh_rounded, size: 15, color: _C.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Resend OTP',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color:      _C.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: _C.textMuted),
                                const SizedBox(width: 5),
                                Text(
                                  'Resend code in ',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _C.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${_secondsLeft}s',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color:      _C.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),

                      // ── Back link ──────────────────────────────
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back_rounded, size: 15, color: _C.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Back',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color:      _C.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
  }
}

// ── BACKGROUND DECORATION (pulsing) ──────────────────────────────────────────
class _BackgroundDecoration extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _BackgroundDecoration({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _C.primary.withOpacity(0.05 + pulseCtrl.value * 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60, left: -60,
            child: Container(
              width: 240, height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _C.primaryLight.withOpacity(0.05 + pulseCtrl.value * 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── OTP LOGO BADGE (pulsing halo + envelope icon) ─────────────────────────────
class _OtpLogoBadge extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _OtpLogoBadge({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing halo
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _C.primary.withOpacity(0.06 + pulseCtrl.value * 0.04),
            ),
          ),
          // Depth layer
          Transform.translate(
            offset: const Offset(0, 4),
            child: Container(
              width: 68, height: 68,
              decoration: BoxDecoration(
                color:        const Color(0xFF1A3DBF),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Main face
          Container(
            width: 68, height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF4B6EF5), Color(0xFF2A4FE8)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:      _C.primary.withOpacity(0.30 + pulseCtrl.value * 0.15),
                  blurRadius: 16,
                  offset:     const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.mark_email_read_outlined, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

// ── OTP SINGLE BOX ────────────────────────────────────────────────────────────
class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode             focusNode;
  final ValueChanged<String>  onChanged;
  final double                size;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.size,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(
      () => setState(() => _focused = widget.focusNode.hasFocus),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: widget.size, height: widget.size,
      decoration: BoxDecoration(
        color:        _focused ? _C.primaryGlow.withOpacity(0.4) : _C.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focused
              ? _C.borderFocus
              : filled
                  ? _C.primary.withOpacity(0.45)
                  : _C.borderDefault,
          width: _focused ? 1.8 : 1.2,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color:        _C.primary.withOpacity(0.12),
                  blurRadius:   0,
                  spreadRadius: 3,
                ),
                const BoxShadow(color: _C.shadowSoft, blurRadius: 4, offset: Offset(0, 1)),
              ]
            : [const BoxShadow(color: _C.shadowSoft, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: TextField(
        controller:      widget.controller,
        focusNode:       widget.focusNode,
        textAlign:       TextAlign.center,
        keyboardType:    TextInputType.number,
        maxLength:       1,
        style: TextStyle(
          color:      _C.textPrimary,
          fontSize:   widget.size * 0.36,
          fontWeight: FontWeight.w700,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText:    '',
          border:         InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

// ── SECTION DIVIDER ───────────────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: _C.borderDefault, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _C.textMuted, letterSpacing: 1.6, fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: _C.borderDefault, thickness: 1)),
      ],
    );
  }
}

// ── PRIMARY BUTTON ────────────────────────────────────────────────────────────
class _PrimaryButton extends StatefulWidget {
  final String       label;
  final IconData     icon;
  final bool         isLoading;
  final bool         disabled;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.disabled,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.975)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   widget.disabled ? null : (_) => _ctrl.forward(),
      onTapUp:     widget.disabled ? null : (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: widget.disabled ? null : ()  => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity, height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: widget.disabled
                ? const LinearGradient(
                    colors: [Color(0xFFB0C4D8), Color(0xFF9DB3C6)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [_C.primary, _C.primaryLight],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
            boxShadow: widget.disabled ? [] : [
              BoxShadow(
                color:      _C.primary.withOpacity(0.28),
                blurRadius: 16,
                offset:     const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(widget.icon, color: Colors.white, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}