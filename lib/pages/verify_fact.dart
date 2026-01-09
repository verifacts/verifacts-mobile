import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:verifacts/core/ui/ui.dart';
import 'package:verifacts/core/utils/functions.dart';
import 'package:verifacts/core/widgets/custom_textfield.dart';
import 'package:verifacts/core/widgets/history_drawer.dart';
import 'package:verifacts/pages/results.dart';

class VerifyFact extends StatefulWidget {
  const VerifyFact({super.key});

  @override
  State<VerifyFact> createState() => _VerifyFactState();
}

class _VerifyFactState extends State<VerifyFact>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode focusNode = FocusNode();
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

    focusNode.requestFocus();

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

  String getGreeting() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour <= 16) {
      return "Good Afternoon";
    }
    return "Good Evening";
  }

  void onSearch(String input) {
    if (input.isEmpty) return;

    String? url = extractUrl(input);
    String cleanText = removeUrl(input);

    controller.clear();
    setState(() {});

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Results(text: cleanText, url: url);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF0D1421),
        drawer: const HistoryDrawer(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                      focusNode.unfocus();
                    },
                    icon: const Icon(
                      IconsaxPlusBroken.menu_1,
                      color: Colors.white,
                      size: 26,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                ),
              ),
              const Spacer(flex: 3),
              Image.asset(
                "assets/images/logo_transparent.png",
                width: 100,
              ),
              Text(
                    getGreeting(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: FontSizes.h1(context),
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2),
              SizedBox(height: Spacings.sm(context)),
              Text(
                    "What fact would you like to verify?",
                    style: AppTextStyles.regular.copyWith(
                      fontSize: FontSizes.bodyLarge(context),
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2),
              const Spacer(flex: 7),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: controller,
                        hint: "Paste text, URL, or claim...",
                        style: AppTextStyles.medium.copyWith(
                          fontSize: FontSizes.bodyLarge(context),
                          height: 1.5,
                          color: Colors.white,
                        ),
                        focus: focusNode,
                        maxLines: maxLines,
                        action: TextInputAction.go,
                        onActionPressed: onSearch,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        String input = controller.text.trim();
                        onSearch(input);
                      },
                      icon: Icon(
                        IconsaxPlusBold.send_2,
                        color: Color(0xFF9FD053).withValues(alpha: filled ? 1 : 0.3),
                        size: 26,
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
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
