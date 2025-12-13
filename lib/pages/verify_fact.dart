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

class _VerifyFactState extends State<VerifyFact> {
  final TextEditingController controller = TextEditingController();
  final int maxAllowedLines = 5;
  int maxLines = 1;
  bool filled = false;

  @override
  void initState() {
    super.initState();

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
      MediaQuery.of(context).size.width - 70, // Account for padding
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getTimeOfDay(),
                style: AppTextStyles.bold.copyWith(
                  fontSize: FontSizes.h1(context),
                ),
              ),
              SizedBox(height: Spacings.xxl(context)),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131313),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
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
                    Positioned(
                      bottom: -60,
                      right: 10,
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: !filled
                                ? AppColors.primaryDisabled
                                : AppColors.primary,
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            color: !filled ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
