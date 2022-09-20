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
  var exampleData = List<DataTableLinks>.from(<DataTableLinks>[
    DataTableLinks(1, "John Doe", "John Doe", DateTime(1977, 6, 17)),
    DataTableLinks(2, "Jane Doe", "John Doe", DateTime(1977, 6, 17)),
    DataTableLinks(3, "John Doe", "John Doe", DateTime(1977, 6, 17)),
    DataTableLinks(4, "Jane Doe", "John Doe", DateTime(1977, 6, 17)),
  ]);

  List<DataTableLinks> dataTableLinks = [];

  preencheDadosParaTabela() {
    for (var url in widget.listLinks) {
      print(url);
      // this.dataTableLinks.add(new DataTableLinks(id, urlOriginal, urlEncurtada, data))
    }
  }

  @override
  void initState() {
    super.initState();
    preencheDadosParaTabela();
  }

  @override
  Widget build(BuildContext context) {
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
                              ResponsiveDataGrid<DataTableLinks>.clientSide(
                                title: const TitleDefinition(
                                  backgroundColor: Colors.white,
                                  title: "Links já encurtados",
                                  icon: Icon(Icons.link_rounded),
                                ),
                                items: exampleData,
                                itemTapped: (row) => print(row.urlEncurtada),
                                pageSize: 10,
                                pagingMode: PagingMode.auto,
                                columns: [
                                  IntColumn(
                                    smallCols: 1,
                                    fieldName: "id",
                                    header: const ColumnHeader(
                                      text: "Id",
                                      showFilter: true,
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
                                      showFilter: true,
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
                                      showFilter: true,
                                      showOrderBy: true,
                                    ),
                                    value: (row) => row.urlEncurtada,
                                  ),
                                  DateTimeColumn(
                                    xsCols: 4,
                                    mediumCols: 3,
                                    fieldName: "data",
                                    filterRules: DateTimeFilterRules(
                                      filterType: DateTimeFilterTypes.DateOnly,
                                    ),
                                    header: const ColumnHeader(
                                      text: "Data criação",
                                      showFilter: true,
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
  }
}
