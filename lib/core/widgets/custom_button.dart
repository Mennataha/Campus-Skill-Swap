import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum CustomButtonVariant { primary, secondary }

/// Button used across the app.
///
/// primary:   filled teal button, white text (example: "Log In ->")
/// secondary: soft light button, dark text (example: "Continue with Google")
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final bool isLoading;

  /// Small icon after the label, for example Icons.arrow_forward.
  final IconData? trailingIcon;

  /// Any widget before the label, for example the Google logo image.
  final Widget? leading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.isLoading = false,
    this.trailingIcon,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == CustomButtonVariant.primary;
    final Color background =
    isPrimary ? AppColors.primary : AppColors.surfaceLight;
    final Color foreground = isPrimary ? Colors.white : AppColors.textPrimary;

    return ElevatedButton(
      // Tapping is disabled while loading, so the user cannot press twice.
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        // While loading, keep the normal colors instead of the grey
        // disabled look. Only a button with no action looks disabled.
        disabledBackgroundColor: isLoading ? background : AppColors.border,
        disabledForegroundColor: isLoading ? foreground : AppColors.textHint,
      ),
      child: isLoading
          ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: foreground,
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 10),
          ],
          Text(label),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, size: 18),
          ],
        ],
      ),
    );
  }
}