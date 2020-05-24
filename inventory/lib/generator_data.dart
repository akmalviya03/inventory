import 'package:flutter/material.dart';
import 'generatorscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratorDataScreen extends StatefulWidget {
  @override
  _GeneratorDataScreenState createState() => _GeneratorDataScreenState();
}

class _GeneratorDataScreenState extends State<GeneratorDataScreen> {
  final _serialNumberController = TextEditingController();
  final _installationController = TextEditingController();
  String _msg = "";
  String dateInstall;
  DateTime _dateTime;
  final databaseReference = Firestore.instance;

  void createRecordProduct(String id, String date) async {
    print('inside enter');
    await databaseReference
        .collection("ProductTable")
        .document(id)
        .setData({'productInstallDate': date, 'productSerialNumber': id});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: _serialNumberController,
            decoration:
                InputDecoration(hintText: 'Enter Serial Number Of Product'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: _installationController,
            decoration: InputDecoration(
                hintText: 'Select Installation Date Of Product'),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1945),
                lastDate: DateTime(3000),
              ).then((date) {
                setState(() {
                  _dateTime = date;
                  dateInstall =
                      "${_dateTime.day}-${_dateTime.month}-${_dateTime.year}";
                  _installationController.text = dateInstall.toString();
                });
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: RaisedButton(
            child: Text(
              'Generate QR Code',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.deepOrange,
            onPressed: () {
              _msg = _serialNumberController.text;
              createRecordProduct(_msg, _installationController.text);
              _serialNumberController.clear();
              _installationController.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneratorScreen(
                    data: _msg.toString(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
