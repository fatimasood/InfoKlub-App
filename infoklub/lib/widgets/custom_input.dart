import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Function()? onRightIconPressed;
  final bool obscureText;
  final double? height;
  final double? width;
  final TextAlign textAlign;
  final Color backgroundColor;
  final Color textColor;
  final Color hintTextColor;
  final List<Map<String, String>>? countryDropdownData;
  final Function(String)? onCountrySelected;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? validator;

  const CustomInput({
    super.key,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.leftWidget,
    this.rightWidget,
    this.onRightIconPressed,
    this.height,
    this.width,
    this.obscureText = false,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.hintTextColor = Colors.grey,
    this.countryDropdownData,
    this.onCountrySelected,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _internalController.text) {
      _internalController.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.leftWidget != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10),
              child: widget.leftWidget!,
            ),
          Expanded(
            child: TextFormField(
              controller: _internalController,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(color: widget.textColor),
              textAlign: widget.textAlign,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: widget.hintTextColor),
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
              validator: (value) {
                if (widget.validator != null) {
                  return widget.validator!(value ?? '');
                }
                return null;
              },
            ),
          ),
          if (widget.rightWidget != null) widget.rightWidget!,
        ],
      ),
    );
  }
}
