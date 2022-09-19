import 'package:flutter/material.dart';

class BackHomeButton extends StatefulWidget {
  const BackHomeButton({Key? key}) : super(key: key);

  @override
  State<BackHomeButton> createState() => _BackHomeButtonState();
}

class _BackHomeButtonState extends State<BackHomeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape:
                MaterialStateProperty.all<CircleBorder>(const CircleBorder())),
        onPressed: () {
          setState(() {
            Navigator.of(context).pushNamed('/');
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
