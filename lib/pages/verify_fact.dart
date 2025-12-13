import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:verifacts/core/ui/ui.dart';
import 'package:verifacts/core/utils/functions.dart';
import 'package:verifacts/core/widgets/custom_textfield.dart';
import 'package:verifacts/pages/results.dart';

class VerifyFact extends StatefulWidget {
  const VerifyFact({super.key});

  @override
  State<VerifyFact> createState() => _VerifyFactState();
}

class _VerifyFactState extends State<VerifyFact>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final int maxAllowedLines = 5;
  int maxLines = 1;
  bool filled = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    controller.addListener(() {
      String input = controller.text.trim();
      if (input.isEmpty && filled) {
        setState(() => filled = false);
      } else if (input.isNotEmpty && !filled) {
        setState(() => filled = true);
      }

      _updateMaxLines();
    });
  }

  void _updateMaxLines() {
    if (controller.text.isEmpty) {
      if (maxLines != 1) {
        setState(() => maxLines = 1);
      }
      return;
    }

    final int calculatedLines = _calculateTextLines(
      controller.text,
      MediaQuery.of(context).size.width - 70,
      AppTextStyles.medium.copyWith(
        fontSize: FontSizes.bodyLarge(context),
        height: 1.5,
      ),
    );

    final int newMaxLines = calculatedLines.clamp(1, maxAllowedLines);

    if (maxLines != newMaxLines) {
      setState(() => maxLines = newMaxLines);
    }
  }

  int _calculateTextLines(String text, double maxWidth, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  String getTimeOfDay() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour < 12) {
      return "Good Morning 🥳";
    } else if (hour >= 12 && hour <= 16) {
      return "Good Afternoon 🙃";
    }
    return "Good Evening 😎";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0A0A0A),
                      Color.lerp(
                        const Color(0xFF1A1A2E),
                        const Color(0xFF16213E),
                        (_animationController.value * 2) % 1,
                      )!,
                      const Color(0xFF0A0A0A),
                    ],
                    stops: [
                      0.0,
                      0.5 +
                          math.sin(_animationController.value * 2 * math.pi) *
                              0.2,
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating particles
          ...List.generate(15, (index) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final offset = (_animationController.value + index * 0.1) % 1;
                final size = 3.0 + (index % 3) * 2;
                return Positioned(
                  left: (index * 50.0) % MediaQuery.of(context).size.width,
                  top: offset * MediaQuery.of(context).size.height,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gradient text greeting
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                        Colors.white,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      getTimeOfDay(),
                      style: AppTextStyles.bold.copyWith(
                        fontSize: FontSizes.h1(context),
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    "Let's verify some facts today",
                    style: AppTextStyles.medium.copyWith(
                      fontSize: FontSizes.bodyMedium(context),
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),

                  SizedBox(height: Spacings.xxl(context)),

                  // Input container with glassmorphism
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 85),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomTextField(
                          controller: controller,
                          hint: "What would you like to verify today?",
                          style: AppTextStyles.medium.copyWith(
                            fontSize: FontSizes.bodyLarge(context),
                            height: 1.5,
                            color: Colors.white,
                          ),
                          maxLines: maxLines,
                        ),

                        // Animated submit button
                        Positioned(
                          bottom: -65,
                          right: 15,
                          child: AnimatedScale(
                            scale: filled ? 1.0 : 0.9,
                            duration: const Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () {
                                String input = controller.text.trim();
                                if (input.isEmpty) return;

                                String? url = extractUrl(input);
                                String cleanText = removeUrl(input);

                                controller.clear();
                                setState(() {});

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return Results(text: cleanText, url: url);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: filled
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primary.withValues(alpha: 0.7),
                                          ],
                                        )
                                      : null,
                                  color: !filled
                                      ? AppColors.primaryDisabled
                                      : null,
                                  boxShadow: filled
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.5),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: !filled
                                      ? Colors.black54
                                      : Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Spacings.xxl(context)),

                  // Quick tips
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: AppColors.primary.withValues(alpha: 0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Paste text or include URLs for verification",
                          style: AppTextStyles.medium.copyWith(
                            fontSize: FontSizes.bodySmall(context),
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
