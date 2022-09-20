import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_data_grid/responsive_data_grid.dart';

import '../../../class/data.table.class.dart';

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
  // var dataTableLinks = List<DataTableLinks>.from(<DataTableLinks>[
  //   DataTableLinks(1, "John Doe", "John Doe", DateTime(1977, 6, 17)),
  //   DataTableLinks(2, "Jane Doe", "John Doe", DateTime(1977, 6, 17)),
  //   DataTableLinks(3, "John Doe", "John Doe", DateTime(1977, 6, 17)),
  //   DataTableLinks(4, "Jane Doe", "John Doe", DateTime(1977, 6, 17)),
  // ]);

  List<DataTableLinks> dataTableLinks = [];

  preencheDadosParaTabela(final list) {
    int idIncrement = 1;
    for (var url in list) {
      dataTableLinks.add(
        new DataTableLinks(
            idIncrement,
            url['url_original'],
            url['url_encurtada'],
            new DateTime.fromMillisecondsSinceEpoch(url['timestamp'])),
      );

      idIncrement += 1;
      print(url);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.listLinks,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> listLinksSnapshot) {
          if (listLinksSnapshot.hasData) {
            preencheDadosParaTabela(listLinksSnapshot.data!['urls']);
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: const Color.fromARGB(255, 167, 167, 167),
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
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
                                      ResponsiveDataGrid<
                                          DataTableLinks>.clientSide(
                                        title: const TitleDefinition(
                                          backgroundColor: Colors.white,
                                          title: "Links já encurtados",
                                          icon: Icon(Icons.link_rounded),
                                        ),
                                        items: dataTableLinks,
                                        itemTapped: (row) =>
                                            print(row.urlEncurtada),
                                        pageSize: 10,
                                        pagingMode: PagingMode.auto,
                                        columns: [
                                          IntColumn(
                                            smallCols: 1,
                                            xsCols: 5,
                                            mediumCols: 2,
                                            fieldName: "id",
                                            header: const ColumnHeader(
                                              backgroundColor: Color.fromARGB(
                                                  255, 118, 177, 255),
                                              text: "Id",
                                              // showFilter: true,
                                              showOrderBy: true,
                                            ),
                                            value: (row) => row.id,
                                          ),
                                          StringColumn(
                                            xsCols: 5,
                                            mediumCols: 2,
                                            fieldName: "urlO",
                                            filterRules: StringFilterRules(
                                              hintText: "Url Original",
                                            ),
                                            header: const ColumnHeader(
                                              text: "Url Original",
                                              // showFilter: true,
                                              showOrderBy: true,
                                            ),
                                            value: (row) => row.urlOriginal,
                                          ),
                                          StringColumn(
                                            xsCols: 5,
                                            mediumCols: 2,
                                            fieldName: "urlE",
                                            filterRules: StringFilterRules(
                                              hintText: "Url Encurtada",
                                            ),
                                            header: const ColumnHeader(
                                              text: "Url Encurtada",
                                              // showFilter: true,
                                              showOrderBy: true,
                                            ),
                                            value: (row) => row.urlEncurtada,
                                          ),
                                          DateTimeColumn(
                                            xsCols: 4,
                                            mediumCols: 3,
                                            fieldName: "data",
                                            filterRules: DateTimeFilterRules(
                                              filterType:
                                                  DateTimeFilterTypes.DateOnly,
                                            ),
                                            header: const ColumnHeader(
                                              text: "Data criação",
                                              // showFilter: true,
                                              showOrderBy: true,
                                            ),
                                            value: (row) => row.data,
                                            format: DateFormat.YEAR_MONTH_DAY,
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
                    ),
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
