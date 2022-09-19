import 'package:flutter/material.dart';

class TxtFieldEmail extends StatefulWidget {
  final TextEditingController controller;

  const TxtFieldEmail({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _TxtFieldEmailState createState() => _TxtFieldEmailState();
}

class _TxtFieldEmailState extends State<TxtFieldEmail> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Nome de usuário',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(Icons.person),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => widget.controller.clear(),
                ),
        ),
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
      );
}
