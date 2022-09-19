import 'package:flutter/material.dart';

class TextSubmitButton extends StatelessWidget {
  final String textButton;
  final Color cor;
  const TextSubmitButton({Key? key, required this.textButton, required this.cor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textButton,
      style: TextStyle(
        color: cor,
        letterSpacing: 1.5,
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'OpenSans',
      ),
    );
  }
}
