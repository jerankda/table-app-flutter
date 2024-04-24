import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding and decoding JSON

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabellenapp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> tableRows = [];
  Set<int> selectedRows = Set<int>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('tableData');
    if (data != null) {
      setState(() {
        tableRows = List<List<String>>.from(json.decode(data).map((row) => List<String>.from(row)));
      });
    } else {
      tableRows = List.generate(10, (index) => List.filled(3, 'Initial Data $index'));
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tableData', json.encode(tableRows));
  }

  void _addRow() {
    setState(() {
      tableRows.add(List.filled(3, 'add data'));
      _saveData();
    });
  }

  void _confirmDelete() {
    if (selectedRows.isEmpty) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the selected rows?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteSelectedRows();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedRows() {
    setState(() {
      List<List<String>> updatedRows = [];
      for (int i = 0; i < tableRows.length; i++) {
        if (!selectedRows.contains(i)) {
          updatedRows.add(tableRows[i]);
        }
      }
      tableRows = updatedRows;
      _saveData();
      selectedRows.clear();
    });
  }

  void _editSelectedRow() {
    if (selectedRows.isEmpty || selectedRows.length > 1) return; // Edit only if exactly one row is selected
    int rowToEdit = selectedRows.first;
    List<TextEditingController> controllers = List.generate(3, (i) => TextEditingController(text: tableRows[rowToEdit][i]));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Row'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) => TextField(
              controller: controllers[index],
              decoration: InputDecoration(labelText: 'Column ${index + 1}'),
            )),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 3; i++) {
                    tableRows[rowToEdit][i] = controllers[i].text;
                  }
                  _saveData();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selectable and Editable Table'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: List.generate(3, (index) => DataColumn(label: Text('Column ${index + 1}'))),
          rows: tableRows.asMap().map((rowIndex, list) {
            return MapEntry(
              rowIndex,
              DataRow(
                selected: selectedRows.contains(rowIndex),
                onSelectChanged: (isSelected) {
                  setState(() {
                    if (isSelected != null) {
                      if (isSelected) {
                        selectedRows.add(rowIndex);
                      } else {
                        selectedRows.remove(rowIndex);
                      }
                    }
                  });
                },
                cells: list.asMap().map((colIndex, cell) {
                  return MapEntry(
                    colIndex,
                    DataCell(
                      Text(cell),
                    ),
                  );
                }).values.toList(),
              ),
            );
          }).values.toList(),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _addRow,
            tooltip: 'Add Row',
            heroTag: null,
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: selectedRows.isNotEmpty ? _confirmDelete : null,
            tooltip: 'Delete Selected Rows',
            heroTag: null,
            backgroundColor: selectedRows.isNotEmpty ? Colors.red : Colors.grey,
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: selectedRows.length == 1 ? _editSelectedRow : null,
            tooltip: 'Edit Selected Row',
            heroTag: null,
            backgroundColor: selectedRows.length == 1 ? Colors.green : Colors.grey,
            child: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
