import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo image with a drop shadow that follows the logo shape (PNG alpha).
/// Used in header and drawer for consistent branding.
class LogoWithShapeShadow extends StatelessWidget {
  const LogoWithShapeShadow({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.errorBuilder,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) => Container(
                width: width,
                height: height,
                color: AppColors.accent.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.accent,
                  size: 32,
                ),
              ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Shadow layer: same image, dark tint using alpha, blurred and offset
        Transform.translate(
          offset: const Offset(0, 4),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.35),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                assetPath,
                width: width,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        image,
      ],
    );
  }
}
