import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String buttonText;

  final double screenWidth;
  final double screenHeight;
  final double height;
  final double width;
  final double buttonRaduis;
  final void Function()? onPressed;
  final TextStyle textStyle;

  const DefaultButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.screenHeight,
    required this.screenWidth,
    required this.height,
    required this.width,
    required this.buttonRaduis,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: screenWidth * width,
            vertical: screenHeight * height,
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * buttonRaduis),
          ),
        ),
        textStyle: MaterialStateProperty.all(textStyle),
      ),
      child: Text(buttonText),
    );
  }
}
