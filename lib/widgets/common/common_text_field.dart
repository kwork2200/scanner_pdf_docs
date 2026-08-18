import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';

class CommonTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool filled;
  final String? counterText;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autoValidateMode;
  final InputBorder? focusedErrorBorder;
  final TextStyle? errorStyle;

  const CommonTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSubmitted,
    this.focusNode,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.filled = false,
    this.counterText,
    this.inputFormatters,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.focusedErrorBorder,
    this.errorStyle,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _isControllerDisposed = false;
  }

  @override
  void didUpdateWidget(CommonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _isControllerDisposed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isControllerValid =
        widget.controller != null && !_isControllerDisposed;

    return TextFormField(
      autovalidateMode: widget.autoValidateMode,
      controller: isControllerValid ? widget.controller : null,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      cursorColor: AppColors.infoBlue,
      style: widget.textStyle ??
          TextStyle(fontSize: AppFontSizes.font14, color: AppColors.blackColor),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
        filled: widget.filled ?? true,
        fillColor: widget.fillColor ?? AppColors.infoBlue.withOpacity(0.05),
        counterText: widget.counterText,
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: BorderSide(color: AppColors.grey),
            ),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: BorderSide(
                color: AppColors.infoBlue,
                width: 1.5.w,
              ),
            ),
        errorBorder: widget.errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: BorderSide(
                color: AppColors.errorColor,
                width: 2.w,
              ),
            ),
        focusedErrorBorder: widget.focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 2,
              ),
            ),
        hintStyle: widget.hintStyle ??
            TextStyle(
              color: AppColors.grey600,
              fontSize: AppFontSizes.font14,
              fontWeight: AppFontWeights.normal,
            ),
        labelStyle: TextStyle(
          color: AppColors.infoBlue,
          fontSize: AppFontSizes.fontSmall,
        ),
        errorStyle: widget.errorStyle ??
            TextStyle(
              color: AppColors.errorColor,
              fontWeight: AppFontWeights.bold,
              fontSize: AppFontSizes.fontNeNoSmall,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _isControllerDisposed = true;
    super.dispose();
  }
}
