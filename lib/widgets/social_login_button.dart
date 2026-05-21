import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';

/// Social login button (Google/Apple) with icon and modern card style.
class SocialLoginButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    this.iconColor = AppColors.textPrimary,
    this.onPressed,
  });

  /// Convenience constructor for Google login.
  factory SocialLoginButton.google({Key? key, VoidCallback? onPressed}) {
    return SocialLoginButton(
      key: key,
      text: 'Google',
      icon: Icons.g_mobiledata_rounded,
      iconColor: AppColors.google,
      onPressed: onPressed,
    );
  }

  /// Convenience constructor for Apple login.
  factory SocialLoginButton.apple({Key? key, VoidCallback? onPressed}) {
    return SocialLoginButton(
      key: key,
      text: 'Apple',
      icon: Icons.apple_rounded,
      iconColor: AppColors.apple,
      onPressed: onPressed,
    );
  }

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 26),
              const SizedBox(width: 10),
              Text(
                widget.text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
