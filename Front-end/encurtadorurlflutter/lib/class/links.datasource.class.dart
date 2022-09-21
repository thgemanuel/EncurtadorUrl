import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'data.table.class.dart';

class LinkDataSource extends DataGridSource {
  

  LinkDataSource(List<DataTableLinks> data) {
    dataGridRows = data
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(
                  columnName: 'urlOriginal', value: dataGridRow.urlOriginal),
              DataGridCell<String>(
                  columnName: 'urlEncurtada', value: dataGridRow.urlEncurtada),
              DataGridCell<DateTime>(
                  columnName: 'data', value: dataGridRow.data),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'data')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
