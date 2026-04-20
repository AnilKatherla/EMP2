import 'package:flutter/material.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';

// ── LOCAL COLORS ──────────────────────────────────────────────────────────────
abstract class _C {
  static const Color scaffoldBg    = Color(0xFFF4F6FA);
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color primary       = AppColors.primary;
  static const Color primaryLight  = AppColors.primaryLight;
  static const Color textPrimary   = Color(0xFF0F1629);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted     = Color(0xFF94A3B8);
  static const Color borderDefault = Color(0xFFE2E8F0);
  static const Color borderFocus   = Color(0xFF0070F3);
  static const Color error         = Color(0xFFEF4444);
  static const Color success       = Color(0xFF22C55E);
  static const Color shadowSoft    = Color(0x14000000);
  static const Color shadowMedium  = Color(0x1F000000);

  // Strength-meter colours
  static const Color strengthWeak   = Color(0xFFEF4444);
  static const Color strengthFair   = Color(0xFFF59E0B);
  static const Color strengthGood   = Color(0xFF0070F3);
  static const Color strengthStrong = Color(0xFF22C55E);
}

// ── RESET PASSWORD SCREEN ─────────────────────────────────────────────────────
class ResetPasswordScreen extends StatefulWidget {
  /// Email or phone passed from the OTP screen.
  final String identifier;

  const ResetPasswordScreen({super.key, required this.identifier});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey        = GlobalKey<FormState>();
  final _pwCtrl         = TextEditingController();
  final _confirmPwCtrl  = TextEditingController();
  bool _isLoading       = false;

  // Pulsing animation for the badge
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  // Password strength
  int    _strengthLevel = 0;
  String _strengthLabel = '';
  Color  _strengthColor = Colors.transparent;

  @override
  void dispose() {
    _pwCtrl.dispose();
    _confirmPwCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Strength evaluation ───────────────────────────────────────────────────

  void _evalStrength(String val) {
    int score = 0;
    if (val.length >= 8)                             score++;
    if (val.contains(RegExp(r'[A-Z]')))              score++;
    if (val.contains(RegExp(r'[0-9]')))              score++;
    if (val.contains(RegExp(r'[!@#\$%^&*]')))       score++;

    setState(() {
      _strengthLevel = score;
      switch (score) {
        case 1: _strengthLabel = 'Weak';   _strengthColor = _C.strengthWeak;   break;
        case 2: _strengthLabel = 'Fair';   _strengthColor = _C.strengthFair;   break;
        case 3: _strengthLabel = 'Good';   _strengthColor = _C.strengthGood;   break;
        case 4: _strengthLabel = 'Strong'; _strengthColor = _C.strengthStrong; break;
        default: _strengthLabel = ''; _strengthColor = Colors.transparent;
      }
    });
  }

  // ── Validation ───────────────────────────────────────────────────────────

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _pwCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> _onReset() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Success — pop all the auth screens and go back to login
    _showSnack('Password reset successfully!', isError: false);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
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

  // ── Build ────────────────────────────────────────────────────────────────

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Logo badge (lock-reset icon) ───────────
                        _ResetLogoBadge(pulseCtrl: _pulseCtrl),
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
                          'Set a new password',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _C.textSecondary, letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'For ${widget.identifier}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _C.primary, fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Divider ────────────────────────────────
                        const _SectionDivider(label: 'NEW PASSWORD'),
                        const SizedBox(height: 24),

                        // ── New password ───────────────────────────
                        const _FieldLabel(text: 'New Password'),
                        const SizedBox(height: 6),
                        _LightGlowField(
                          controller: _pwCtrl,
                          hint:       'Min. 8 characters',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscure:    true,
                          validator:  _validatePassword,
                          onChanged:  _evalStrength,
                        ),

                        // ── Strength meter ─────────────────────────
                        if (_strengthLevel > 0) ...[
                          const SizedBox(height: 10),
                          _StrengthMeter(
                            level: _strengthLevel,
                            label: _strengthLabel,
                            color: _strengthColor,
                          ),
                        ],
                        const SizedBox(height: 18),

                        // ── Confirm password ───────────────────────
                        const _FieldLabel(text: 'Confirm Password'),
                        const SizedBox(height: 6),
                        _LightGlowField(
                          controller: _confirmPwCtrl,
                          hint:       'Re-enter password',
                          prefixIcon: Icons.lock_reset_outlined,
                          obscure:    true,
                          validator:  _validateConfirm,
                          onChanged:  (_) => setState(() {}),
                        ),
                        const SizedBox(height: 28),

                        // ── Reset button ───────────────────────────
                        _PrimaryButton(
                          label:     'Reset Password',
                          icon:      Icons.lock_open_outlined,
                          isLoading: _isLoading,
                          disabled:  _pwCtrl.text.isEmpty ||
                                     _confirmPwCtrl.text.isEmpty ||
                                     _isLoading,
                          onTap:     _onReset,
                        ),
                        const SizedBox(height: 24),

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

// ── RESET LOGO BADGE (pulsing halo + lock icon) ───────────────────────────────
class _ResetLogoBadge extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _ResetLogoBadge({required this.pulseCtrl});

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
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color:      _C.primary.withOpacity(0.30 + pulseCtrl.value * 0.15),
                  blurRadius: 16,
                  offset:     const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.lock_reset_outlined, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PASSWORD STRENGTH METER ───────────────────────────────────────────────────
class _StrengthMeter extends StatelessWidget {
  final int    level;
  final String label;
  final Color  color;

  const _StrengthMeter({
    required this.level,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                decoration: BoxDecoration(
                  color:        i < level ? color : _C.borderDefault,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 7, height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              'Password strength: ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: _C.textMuted),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color, fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
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
          color: _C.textPrimary, fontWeight: FontWeight.w500, letterSpacing: 0.2,
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
  final bool                       obscure;
  final String? Function(String?)? validator;
  final ValueChanged<String>?      onChanged;

  const _LightGlowField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscure  = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<_LightGlowField> createState() => _LightGlowFieldState();
}

class _LightGlowFieldState extends State<_LightGlowField> {
  bool _focused  = false;
  bool _showText = false;

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
          controller:  widget.controller,
          obscureText: widget.obscure && !_showText,
          validator:   widget.validator,
          onChanged:   widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _C.textPrimary, fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText:           widget.hint,
            hintStyle:          Theme.of(context).textTheme.bodyMedium?.copyWith(color: _C.textMuted),
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
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _showText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: _C.textSecondary, size: 18,
                    ),
                    onPressed: () => setState(() => _showText = !_showText),
                  )
                : null,
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
          width: double.infinity, height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.disabled
                ? const Color(0xFFCBD5E1)
                : AppColors.primary,
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