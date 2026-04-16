import 'package:flutter/material.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'otp_screen.dart';

// ── LOCAL COLORS (same palette as login_screen.dart) ─────────────────────────
abstract class _C {
  static const Color scaffoldBg    = Color(0xFFF4F6FA);
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color primary       = Color(0xFF0070F3);
  static const Color primaryLight  = Color(0xFF3B9EFF);
  static const Color textPrimary   = Color(0xFF0F1629);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted     = Color(0xFF94A3B8);
  static const Color borderDefault = Color(0xFFE2E8F0);
  static const Color borderFocus   = Color(0xFF0070F3);
  static const Color error         = Color(0xFFEF4444);
  static const Color shadowSoft    = Color(0x14000000);
  static const Color shadowMedium  = Color(0x1F000000);
}

// ── FORGOT PASSWORD SCREEN ────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _inputCtrl = TextEditingController();
  bool  _isLoading = false;

  // Toggle: email or phone
  bool _usePhone = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────────────────────

  String? _validate(String? v) {
    if (v == null || v.trim().isEmpty) {
      return _usePhone ? 'Phone number is required' : 'Email is required';
    }
    if (_usePhone) {
      if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(v.trim())) {
        return 'Enter a valid phone number';
      }
    } else {
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(v.trim())) {
        return 'Enter a valid email address';
      }
    }
    return null;
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> _onSendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(identifier: _inputCtrl.text.trim()),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _usePhone = !_usePhone;
      _inputCtrl.clear();
    });
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
          const _BackgroundDecoration(),

          // ── Scrollable card ─────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: AppSpacing.xl5,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Logo badge (key icon theme) ────────────
                        const _ForgotLogoBadge(),
                        const SizedBox(height: 12),

                        // ── Brand ──────────────────────────────────
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Track',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: _C.textPrimary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'Force',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: _C.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // ── Subtitle ───────────────────────────────
                        Text(
                          'Forgot your password?',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _C.textSecondary,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We\'ll send a verification code to reset it.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _C.textMuted,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Section divider ────────────────────────
                        const _SectionDivider(label: 'ACCOUNT RECOVERY'),
                        const SizedBox(height: 24),

                        // ── Mode toggle chip ───────────────────────
                        _ModeToggle(
                          usePhone:  _usePhone,
                          onToggle:  _toggleMode,
                        ),
                        const SizedBox(height: 20),

                        // ── Input field ────────────────────────────
                        _FieldLabel(
                          text: _usePhone ? 'Mobile Number' : 'Email Address',
                        ),
                        const SizedBox(height: 6),
                        _LightGlowField(
                          controller:   _inputCtrl,
                          hint:         _usePhone
                              ? '+91 98765 43210'
                              : 'you@company.com',
                          prefixIcon:   _usePhone
                              ? Icons.phone_outlined
                              : Icons.mail_outline_rounded,
                          keyboardType: _usePhone
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                          validator: _validate,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 28),

                        // ── Send OTP button ────────────────────────
                        _PrimaryButton(
                          label:     'Send OTP',
                          icon:      Icons.send_rounded,
                          isLoading: _isLoading,
                          disabled:  _inputCtrl.text.trim().isEmpty || _isLoading,
                          onTap:     _onSendOtp,
                        ),
                        const SizedBox(height: 24),

                        // ── Back to login ──────────────────────────
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back_rounded,
                                size: 15,
                                color: _C.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Back to Login',
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
          ),
        ],
      ),
    );
  }
}

// ── BACKGROUND DECORATION ─────────────────────────────────────────────────────
class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80, right: -80,
          child: Container(
            width: 320, height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_C.primary.withOpacity(0.07), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60, left: -60,
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_C.primaryLight.withOpacity(0.06), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── FORGOT PASSWORD LOGO BADGE ────────────────────────────────────────────────
// Same 3-D card style as login, but with a key icon to signify password recovery.
class _ForgotLogoBadge extends StatelessWidget {
  const _ForgotLogoBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 3-D depth layer
        Transform.translate(
          offset: const Offset(0, 5),
          child: Container(
            width: 76, height: 76,
            decoration: BoxDecoration(
              color:        const Color(0xFF1A3DBF),
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        // Main face with gradient
        Container(
          width: 76, height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF4B6EF5), Color(0xFF2A4FE8)],
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color:      const Color(0xFF2A4FE8).withOpacity(0.45),
                blurRadius: 18,
                offset:     const Offset(0, 8),
              ),
              BoxShadow(
                color:      Colors.white.withOpacity(0.18),
                blurRadius: 1,
                offset:     const Offset(0, -1),
              ),
            ],
          ),
          // Key + envelope custom painter
          child: const Center(child: _KeyMailIcon(size: 40)),
        ),
      ],
    );
  }
}

// ── KEY + MAIL CUSTOM PAINTER ─────────────────────────────────────────────────
// Draws a white key outline — recognisably "forgot password" without any asset.
class _KeyMailIcon extends StatelessWidget {
  final double size;
  const _KeyMailIcon({required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _KeyPainter());
}

class _KeyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;

    final p = Paint()
      ..color       = Colors.white
      ..style       = PaintingStyle.stroke
      ..strokeWidth = w * 0.105
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    // ── Key circle (top-left) ──────────────────────────────────────────
    final circleCenter = Offset(w * 0.32, h * 0.34);
    final circleR      = w * 0.175;
    canvas.drawCircle(circleCenter, circleR, p);

    // ── Key shank (diagonal line bottom-right) ────────────────────────
    final shankStart = Offset(w * 0.46, h * 0.50);
    final shankEnd   = Offset(w * 0.88, h * 0.92);
    canvas.drawLine(shankStart, shankEnd, p);

    // ── Key teeth ─────────────────────────────────────────────────────
    // tooth 1
    canvas.drawLine(
      Offset(w * 0.69, h * 0.71),
      Offset(w * 0.80, h * 0.68),
      p,
    );
    // tooth 2
    canvas.drawLine(
      Offset(w * 0.80, h * 0.82),
      Offset(w * 0.91, h * 0.78),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── MODE TOGGLE CHIP ──────────────────────────────────────────────────────────
// Lets user switch between Email and Phone input.
class _ModeToggle extends StatelessWidget {
  final bool         usePhone;
  final VoidCallback onToggle;
  const _ModeToggle({required this.usePhone, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color:        _C.borderDefault.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _Chip(
            label:    'Email',
            icon:     Icons.mail_outline_rounded,
            selected: !usePhone,
            onTap:    usePhone ? onToggle : null,
          ),
          _Chip(
            label:    'Phone',
            icon:     Icons.phone_outlined,
            selected: usePhone,
            onTap:    !usePhone ? onToggle : null,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String    label;
  final IconData  icon;
  final bool      selected;
  final VoidCallback? onTap;
  const _Chip({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color:        selected ? _C.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [BoxShadow(color: _C.shadowSoft, blurRadius: 6, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size:  14,
                color: selected ? _C.primary : _C.textMuted,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color:      selected ? _C.textPrimary : _C.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
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
              color:         _C.textMuted,
              letterSpacing: 1.6,
              fontWeight:    FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: _C.borderDefault, thickness: 1)),
      ],
    );
  }
}

// ── FIELD LABEL ───────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color:         _C.textPrimary,
          fontWeight:    FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ── LIGHT GLOW TEXT FIELD ─────────────────────────────────────────────────────
class _LightGlowField extends StatefulWidget {
  final TextEditingController      controller;
  final String                     hint;
  final IconData                   prefixIcon;
  final TextInputType?             keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>?      onChanged;

  const _LightGlowField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  State<_LightGlowField> createState() => _LightGlowFieldState();
}

class _LightGlowFieldState extends State<_LightGlowField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color:        _C.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? _C.borderFocus : _C.borderDefault,
            width: _focused ? 1.5 : 1.0,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color:        _C.primary.withOpacity(0.10),
                    blurRadius:   0,
                    spreadRadius: 3,
                  ),
                  const BoxShadow(color: _C.shadowSoft, blurRadius: 4, offset: Offset(0, 1)),
                ]
              : [const BoxShadow(color: _C.shadowSoft, blurRadius: 4, offset: Offset(0, 1))],
        ),
        child: TextFormField(
          controller:   widget.controller,
          keyboardType: widget.keyboardType,
          validator:    widget.validator,
          onChanged:    widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _C.textPrimary, fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText:  widget.hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _C.textMuted),
            border:             InputBorder.none,
            errorBorder:        InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                widget.prefixIcon,
                size: 18,
                color: _focused ? _C.primary : _C.textMuted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 0),
          ),
        ),
      ),
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
          width:  double.infinity,
          height: 50,
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