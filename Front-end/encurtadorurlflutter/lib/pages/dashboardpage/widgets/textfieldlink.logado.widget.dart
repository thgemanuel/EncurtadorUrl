import 'package:flutter/material.dart';

class TxtFieldLinkLogado extends StatefulWidget {
  final TextEditingController controller;
  final callback;

  const TxtFieldLinkLogado(
      {Key? key, required this.controller, required this.callback})
      : super(key: key);

  @override
  _TxtFieldLinkLogadoState createState() => _TxtFieldLinkLogadoState();
}

class _TxtFieldLinkLogadoState extends State<TxtFieldLinkLogado> {
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
        onFieldSubmitted: (value) {
          widget.callback();
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Link',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: const Icon(Icons.link),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => widget.controller.clear(),
                ),
        ),
        keyboardType: TextInputType.url,
        autofocus: true,
      );
}
