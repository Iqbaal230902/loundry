import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../utils/validators.dart';

/// Animated password strength indicator with colored bars and label.
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  Color _getColor(int strength, int index) {
    if (index >= strength) return AppColors.border;
    switch (strength) {
      case 1:
        return AppColors.strengthWeak;
      case 2:
        return AppColors.strengthMedium;
      case 3:
        return AppColors.strengthMedium;
      case 4:
        return AppColors.strengthStrong;
      default:
        return AppColors.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = Validators.getPasswordStrength(password);
    final label = Validators.getPasswordStrengthLabel(strength);

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: _getColor(strength, index),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              'Kekuatan: $label',
              key: ValueKey(label),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getColor(strength, 0),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
