import 'package:flutter/material.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'forgot_password_screen.dart';

// ── LOCAL COLOR PALETTE ──────────────────────────────────────────────────────
// Self-contained tokens for this screen.
// Using the same palette values as the rest of the SaaS design system.
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
  static const Color shadowSoft    = Color(0x14000000); // 8 % black
  static const Color shadowMedium  = Color(0x1F000000); // 12 % black
  // Google button
  static const Color googleBg      = Color(0xFFFFFFFF);
  static const Color googleBorder  = Color(0xFFE2E8F0);
  static const Color googleText    = Color(0xFF1F1F1F);
}

// ── LOGIN SCREEN ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool  _isLoading    = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────────────────────────────────────

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  // Static demo credentials
  static const _demoEmail    = 'admin@trackforce.com';
  static const _demoPassword = 'admin123';

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // Show loading for half a second for realistic feel
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_emailCtrl.text.trim() == _demoEmail &&
        _passwordCtrl.text == _demoPassword) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showSnack('Invalid email or password. Try admin@trackforce.com / admin123');
    }
  }

  void _onGoogleSignIn() {
    _showSnack('Google Sign-In coming soon!', isError: false);
  }

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? _C.error : _C.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Read screen dimensions once for responsive sizing
    final mq     = MediaQuery.of(context);
    final width  = mq.size.width;

    // Responsive horizontal padding: 5% of screen, bounded between 16–32 px
    final hPad   = (width * 0.05).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: _C.scaffoldBg,
      // Prevent keyboard from pushing content into overflow
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Subtle background blobs ──────────────────────────────────
          const _BackgroundDecoration(),

          // ── Scrollable form card ─────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: AppSpacing.xl5, // 48 px
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                decoration: BoxDecoration(
                  color:        _C.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border:       Border.all(color: _C.borderDefault),
                  boxShadow: const [
                    BoxShadow(
                      color:      _C.shadowSoft,
                      blurRadius: 24,
                      offset:     Offset(0, 8),
                    ),
                    BoxShadow(
                      color:      _C.shadowMedium,
                      blurRadius: 48,
                      offset:     Offset(0, 24),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    // Inner card horizontal padding: 10% of card width, min 24
                    (width * 0.10).clamp(24.0, 36.0),
                    AppSpacing.xl4, // top 40
                    (width * 0.10).clamp(24.0, 36.0),
                    AppSpacing.xl3, // bottom 32
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Logo badge ─────────────────────────────
                        const _LogoBadge(),
                        const SizedBox(height: 12),

                        // ── Brand name ─────────────────────────────
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Track',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight:    FontWeight.w300,
                                      color:         _C.textPrimary,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              TextSpan(
                                text: 'Force',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight:    FontWeight.w800,
                                      color:         _C.primary,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // ── Subtitle ───────────────────────────────
                        Text(
                          'Sign in to your workspace',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:         _C.textSecondary,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── "ACCOUNT LOGIN" divider ────────────────
                        const _SectionDivider(label: 'ACCOUNT LOGIN'),
                        const SizedBox(height: 24),

                        // ── Email field ────────────────────────────
                        const _FieldLabel(text: 'Email Address'),
                        const SizedBox(height: 6),
                        _LightGlowField(
                          controller: _emailCtrl,
                          hint:       'you@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator:  _validateEmail,
                          onChanged:  (_) => setState(() {}),
                        ),
                        const SizedBox(height: 18),

                        // ── Password field ─────────────────────────
                        const _FieldLabel(text: 'Password'),
                        const SizedBox(height: 6),
                        _LightGlowField(
                          controller: _passwordCtrl,
                          hint:       '••••••••••',
                          obscure:    true,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator:  _validatePassword,
                          onChanged:  (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),

                        // ── Forgot password link ───────────────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding:          EdgeInsets.zero,
                              minimumSize:      Size.zero,
                              tapTargetSize:    MaterialTapTargetSize.shrinkWrap,
                              foregroundColor:  _C.primary,
                            ),
                            onPressed: _onForgotPassword,
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color:      _C.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // ── Sign In button ─────────────────────────
                        _buildLoginButton(context),
                        const SizedBox(height: 20),

                        // ── OR divider ─────────────────────────────
                        const _SectionDivider(label: 'OR'),
                        const SizedBox(height: 20),

                        // ── Continue with Google ───────────────────
                        _GoogleButton(onTap: _onGoogleSignIn),
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

  // ── Sign In button (with loading + disabled states) ──────────────────────────

  Widget _buildLoginButton(BuildContext context) {
    final isEmpty  = _emailCtrl.text.trim().isEmpty ||
                     _passwordCtrl.text.isEmpty;
    final disabled = isEmpty || _isLoading;

    return _PrimaryButton(
      label:     'Sign In',
      icon:      Icons.arrow_forward_rounded,
      isLoading: _isLoading,
      disabled:  disabled,
      onTap:     _onLogin,
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
          top:   -80,
          right: -80,
          child: Container(
            width: 320, height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _C.primary.withOpacity(0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left:   -60,
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _C.primaryLight.withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── LOGO BADGE ────────────────────────────────────────────────────────────────
class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 3-D depth face
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
        // Main face
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
          child: const Center(child: _ShieldCheckIcon(size: 40)),
        ),
      ],
    );
  }
}

// ── SHIELD + CHECK PAINTER ────────────────────────────────────────────────────
class _ShieldCheckIcon extends StatelessWidget {
  final double size;
  const _ShieldCheckIcon({required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _ShieldCheckPainter());
}

class _ShieldCheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shieldPaint = Paint()
      ..color       = Colors.white
      ..style       = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    final shield = Path()
      ..moveTo(w * .50, h * .04)
      ..lineTo(w * .93, h * .22)
      ..cubicTo(w * .93, h * .60, w * .72, h * .86, w * .50, h * .97)
      ..cubicTo(w * .28, h * .86, w * .07, h * .60, w * .07, h * .22)
      ..close();
    canvas.drawPath(shield, shieldPaint);

    final checkPaint = Paint()
      ..color       = Colors.white
      ..style       = PaintingStyle.stroke
      ..strokeWidth = w * 0.115
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    final check = Path()
      ..moveTo(w * .28, h * .53)
      ..lineTo(w * .44, h * .68)
      ..lineTo(w * .72, h * .38);
    canvas.drawPath(check, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
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
  final TextEditingController  controller;
  final String                 hint;
  final bool                   obscure;
  final IconData               prefixIcon;
  final TextInputType?         keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>?  onChanged;

  const _LightGlowField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscure     = false,
    this.keyboardType,
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
                  const BoxShadow(
                    color:      _C.shadowSoft,
                    blurRadius: 4,
                    offset:     Offset(0, 1),
                  ),
                ]
              : [
                  const BoxShadow(
                    color:      _C.shadowSoft,
                    blurRadius: 4,
                    offset:     Offset(0, 1),
                  ),
                ],
        ),
        child: TextFormField(
          controller:   widget.controller,
          obscureText:  widget.obscure && !_showText,
          keyboardType: widget.keyboardType,
          validator:    widget.validator,
          onChanged:    widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:      _C.textPrimary,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText:  widget.hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _C.textMuted,
            ),
            border:         InputBorder.none,
            errorBorder:    InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical:   15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                widget.prefixIcon,
                size:  18,
                color: _focused ? _C.primary : _C.textMuted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth:  44,
              minHeight: 0,
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _showText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _C.textSecondary,
                      size:  18,
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

// ── PRIMARY BUTTON (Login) ────────────────────────────────────────────────────
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
    vsync:    this,
    duration: const Duration(milliseconds: 100),
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
                    begin:  Alignment.topLeft,
                    end:    Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [_C.primary, _C.primaryLight],
                    begin:  Alignment.topLeft,
                    end:    Alignment.bottomRight,
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
                  width:  20,
                  height: 20,
                  child:  CircularProgressIndicator(
                    color:       Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color:         Colors.white,
                        fontWeight:    FontWeight.w700,
                        letterSpacing: 0.6,
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

// ── CONTINUE WITH GOOGLE BUTTON ───────────────────────────────────────────────
class _GoogleButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GoogleButton({required this.onTap});

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync:    this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.975)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _ctrl.forward(),
      onTapUp:     (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: ()  => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width:  double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color:        _C.googleBg,
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(color: _C.googleBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color:      _C.shadowSoft,
                blurRadius: 8,
                offset:     const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google "G" logo — drawn with CustomPaint to avoid assets
              SizedBox(
                width:  20,
                height: 20,
                child: CustomPaint(painter: _GoogleLogoPainter()),
              ),
              const SizedBox(width: 12),
              Text(
                'Continue with Google',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:      _C.googleText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── GOOGLE "G" LOGO PAINTER ───────────────────────────────────────────────────
// Renders a simplified Google G using the official brand colors,
// avoiding any network or asset dependency.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size sz) {
    final cx = sz.width / 2;
    final cy = sz.height / 2;
    final r  = sz.width / 2;

    // Blue arc (top + left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.57, 3.14, false,
      Paint()
        ..color       = const Color(0xFF4285F4)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = r * 0.36,
    );
    // Green arc (bottom-right)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.57, 0.79, false,
      Paint()
        ..color       = const Color(0xFF34A853)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = r * 0.36,
    );
    // Yellow arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.36, 0.79, false,
      Paint()
        ..color       = const Color(0xFFFBBC05)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = r * 0.36,
    );
    // Red arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      3.14, 0.42, false,
      Paint()
        ..color       = const Color(0xFFEA4335)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = r * 0.36,
    );

    // Horizontal bar of the G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = r * 0.36
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.85, cy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}