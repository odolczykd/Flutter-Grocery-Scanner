import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class FormTextField extends StatefulWidget {
  final String labelText;
  final Color color;
  final bool obscureText;
  final String? Function(String?) validator;
  final Function? callback;
  bool? multiline = false;
  String value;

  FormTextField(
      {super.key,
      this.callback,
      required this.labelText,
      required this.color,
      required this.obscureText,
      required this.validator,
      this.multiline,
      this.value = ""});

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant FormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller = TextEditingController(text: widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: widget.validator,
      cursorColor: black,
      obscureText: widget.obscureText,
      keyboardType: widget.multiline != null && widget.multiline == true
          ? TextInputType.multiline
          : null,
      maxLines: widget.multiline != null && widget.multiline == true ? null : 1,
      decoration: InputDecoration(
        fillColor: white,
        filled: true,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.all(15),
        labelStyle: const TextStyle(color: grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color, width: 2),
            borderRadius: BorderRadius.circular(10)),
        focusColor: widget.color,
      ),
      onChanged: (val) =>
          widget.callback != null ? widget.callback!(val) : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
