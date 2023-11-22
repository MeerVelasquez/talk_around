import 'package:flutter/material.dart';

class ButtonPrimaryWidget extends StatelessWidget {
  final double fontSize;
  final String text;
  final VoidCallback onPressed;

  const ButtonPrimaryWidget({
    Key? key,
    this.fontSize = 18,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF013E6A))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFE7FCFD)),
      ));
}
