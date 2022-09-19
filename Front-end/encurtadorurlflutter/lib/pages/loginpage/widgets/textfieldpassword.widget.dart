import 'package:flutter/material.dart';

class TxtFieldPassword extends StatefulWidget {
  final TextEditingController controller;
  final callback;

  const TxtFieldPassword(
      {Key? key, required this.controller, required this.callback})
      : super(key: key);

  @override
  _TxtFieldPasswordState createState() => _TxtFieldPasswordState();
}

class _TxtFieldPasswordState extends State<TxtFieldPassword> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        onFieldSubmitted: (value) {
          widget.callback();
        },
        controller: widget.controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Senha',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
                isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() => isHidden = !isHidden);
            },
          ),
        ),
        validator: (password) => password != null && password.length < 5
            ? 'Informe no mínimo 5 caracteres!'
            : null,
      );
}
