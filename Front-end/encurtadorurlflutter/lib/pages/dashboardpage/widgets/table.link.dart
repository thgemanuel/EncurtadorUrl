import 'package:flutter/material.dart';
import 'card.table.dart';

class TableLinks extends StatefulWidget {
  final listLinks;
  const TableLinks({
    Key? key,
    required this.listLinks,
  }) : super(key: key);

  @override
  State<TableLinks> createState() => _TableLinksState();
}

class _TableLinksState extends State<TableLinks> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.listLinks,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> listLinksSnapshot) {
          if (listLinksSnapshot.hasData) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: const Color.fromARGB(255, 167, 167, 167),
                    body: CardTable(list: listLinksSnapshot.data!['urls']),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }
        });
  }
}
