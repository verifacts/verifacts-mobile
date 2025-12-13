import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:verifacts/core/ui/ui.dart';


class PrimaryButton extends StatefulWidget {
  final bool active;
  final bool loading;
  final String? text;
  final VoidCallback onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor, textColor;

  const PrimaryButton({
    super.key,
    this.text,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.child,
    this.active = true,
    this.loading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> transition;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    transition = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));

    animate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PrimaryButton oldWidget) {
    animate();
    super.didUpdateWidget(oldWidget);
  }

  void animate() {
    if (widget.active) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.loading || !widget.active,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          return FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  widget.backgroundColor ??
                  Color.lerp(
                    AppColors.primaryDisabled,
                    AppColors.primary,
                    transition.value,
                  ),
              fixedSize: Size(
                widget.width ?? double.infinity,
                widget.height ?? 45,
              ),
              minimumSize: Size(
                widget.width ?? double.infinity,
                widget.height ?? 45,
              ),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: widget.onPressed,
            child: child,
          );
        },
        child: !widget.loading
            ? (widget.child == null
                  ? Text(
                          widget.text ?? "",
                          style: AppTextStyles.semiBold.copyWith(
                            fontSize: FontSizes.h5(context),
                            color: widget.textColor ?? Colors.white,
                          ),
                        )
                        .animate()
                        .fadeIn(
                          duration: const Duration(milliseconds: 300),
                          delay: const Duration(milliseconds: 50),
                        )
                        .moveY(
                          duration: const Duration(milliseconds: 300),
                          begin: -10.0,
                          end: 0.0,
                        )
                  : widget.child!)
            : null,
      ),
    );
  }
}