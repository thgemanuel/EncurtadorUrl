// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:test_encurtar_link/class/links.datasource.class.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../class/data.table.class.dart';

class CardTable extends StatefulWidget {
  final list;
  const CardTable({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  List<DataTableLinks> dataTableLinks = [];

  preencheDadosParaTabela() {
    int idIncrement = 1;
    for (var url in widget.list) {
      dataTableLinks.add(
        new DataTableLinks(
            idIncrement,
            url['url_original'],
            url['url_encurtada'],
            new DateTime.fromMillisecondsSinceEpoch(url['timestamp'] * 1000)),
      );

      idIncrement += 1;
    }
  }

  late LinkDataSource _linkDataSource;

  @override
  void initState() {
    super.initState();
    preencheDadosParaTabela();
    _linkDataSource = LinkDataSource(dataTableLinks);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.link_rounded, size: MediaQuery.of(context).size.width >500? 35 : 15),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Links já encurtados",
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                    fontSize: MediaQuery.of(context).size.width > 500
                                            ? 35
                                            : 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SfDataGrid(
                            selectionMode: SelectionMode.none,
                            source: _linkDataSource,
                            onCellTap: ((detalhes) {
                              if (detalhes.rowColumnIndex.rowIndex != 0) {
                                int selectedRowIndex =
                                    detalhes.rowColumnIndex.rowIndex - 1;
                                var row = _linkDataSource.effectiveRows
                                    .elementAt(selectedRowIndex);

                                // obtendo a url original e redirecionando
                                launchUrlString(
                                    row.getCells()[1].value.toString());
                              }
                            }),
                            columns: [
                              GridTextColumn(
                                columnName: 'id',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'ID',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridTextColumn(
                                columnName: 'url_original',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Url Original',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridTextColumn(
                                columnName: 'url_encurtada',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Url Encurtada',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridTextColumn(
                                columnName: 'data',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Data',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
