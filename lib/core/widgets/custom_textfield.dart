import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifacts/core/ui/ui.dart';

class CustomTextField extends StatefulWidget {
  final Widget? prefix;
  final Widget? suffix;
  final double? prefixWidth;
  final double? suffixWidth;
  final String? hint;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final bool obscure;
  final bool autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final Function? onChange;
  final Function? onActionPressed;
  final Function? onValidate;
  final Function? onSave;
  final BorderRadius? radius;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final TextStyle? hintStyle;
  final bool readOnly;
  final bool disableFocusedBorder;
  final Color? disabledFocusedBorderColor;
  final int maxLines;
  final int? maxCharacters;
  final double? width;
  final List<TextInputFormatter> formatters;
  final String? label;
  final TextStyle? style;
  final FontWeight? hintFontWeight;
  final FontWeight? styleFontWeight;

  const CustomTextField({
    super.key,
    required this.controller,
    this.formatters = const [],
    this.style,
    this.width,
    this.fillColor,
    this.borderColor,
    this.padding,
    this.hintStyle,
    this.disableFocusedBorder = false,
    this.disabledFocusedBorderColor,
    this.focus,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscure = false,
    this.autoValidate = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.onActionPressed,
    this.onChange,
    this.onValidate,
    this.onSave,
    this.radius,
    this.hint,
    this.prefix,
    this.suffix,
    this.label,
    this.hintFontWeight,
    this.styleFontWeight,
    this.prefixWidth,
    this.suffixWidth,
    this.maxLines = 1,
    this.maxCharacters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int count = 0, limit = 0;

  @override
  void initState() {
    super.initState();
    if (widget.maxCharacters != null) {
      limit = widget.maxCharacters!;
    }

    widget.controller.addListener(onType);
  }

  void onType() {
    if (limit != 0) {
      count = widget.controller.text.length;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacings.sm(context),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: AppTextStyles.medium.copyWith(
              color: AppColors.label,
              fontSize: FontSizes.bodyMedium(context),
            ),
          ),
        SizedBox(
          width: widget.width,
          child: TextFormField(
            autovalidateMode: widget.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            maxLines: widget.maxLines,
            inputFormatters: [
              ...widget.formatters,
              if (widget.maxCharacters != null)
                LengthLimitingTextInputFormatter(widget.maxCharacters),
            ],
            focusNode: widget.focus,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            obscureText: widget.obscure,
            keyboardType: widget.type,
            textInputAction: widget.action,
            readOnly: widget.readOnly,
            onEditingComplete: () {
              if (widget.onActionPressed != null) {
                widget.onActionPressed!(widget.controller.text);
              } else {
                FocusScope.of(context).nextFocus();
              }
            },
            cursorColor: AppColors.primary,
            style:
                widget.style ??
                AppTextStyles.medium.copyWith(
                  // color: AppColors.dark,
                  fontSize: FontSizes.bodyLarge(context),
                  fontWeight: widget.styleFontWeight,
                ),
            decoration: InputDecoration(
              errorMaxLines: 1,
              errorStyle: AppTextStyles.medium.copyWith(color: AppColors.error),
              fillColor: const Color(0xFF131313),
              hoverColor: const Color(0xFF131313),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 5,
              ),
              prefixIcon: widget.prefix != null
                  ? SizedBox(
                      height: kMinInteractiveDimension,
                      width: widget.prefixWidth ?? kMinInteractiveDimension,
                      child: Center(child: widget.prefix),
                    )
                  : null,
              suffixIcon: widget.suffix != null
                  ? SizedBox(
                      height: kMinInteractiveDimension,
                      width: widget.suffixWidth ?? kMinInteractiveDimension,
                      child: Center(child: widget.suffix),
                    )
                  : null,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: widget.hint,
              hintStyle:
                  widget.hintStyle ??
                  AppTextStyles.regular.copyWith(
                    color: const Color(0xFFB1B2B9),
                    fontSize: FontSizes.bodyLarge(context),
                    fontWeight: widget.hintFontWeight,
                  ),
            ),
            onChanged: (value) {
              if (widget.onChange == null) return;
              widget.onChange!(value);
            },
            validator: (value) {
              if (widget.onValidate == null) return null;
              return widget.onValidate!(value);
            },
            onSaved: (value) {
              if (widget.onSave == null) return;
              widget.onSave!(value);
            },
          ),
        ),
        if (widget.maxCharacters != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$count/$limit",
              style: AppTextStyles.regular.copyWith(
                color: const Color(0xFFB1B2B9),
                fontSize: FontSizes.bodySmall(context),
              ),
            ),
          ),
      ],
    );
  }
}
