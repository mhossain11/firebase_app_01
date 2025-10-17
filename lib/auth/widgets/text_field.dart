import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText = "", this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength:maxLength,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        border: OutlineInputBorder(),
      ),
    );
  }
}


class CustomTextFieldPassword extends StatefulWidget {
  const CustomTextFieldPassword({
    super.key,
    required this.controller,
    this.labelText = "",
  });

  final TextEditingController controller;
  final String labelText;

  @override
  State<CustomTextFieldPassword> createState() => _CustomTextFieldPasswordState();
}

class _CustomTextFieldPasswordState extends State<CustomTextFieldPassword> {
  bool isObscure = true;
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        border: OutlineInputBorder(),
        suffixIcon: IconButton(onPressed: (){
          setState(() {
            isObscure = !isObscure;
            isObscureText = !isObscureText;
          });
        },
            icon:Icon(isObscure? Icons.visibility_off: Icons.visibility)
      ),
    ),
      obscureText: isObscureText,
    );
  }
}

