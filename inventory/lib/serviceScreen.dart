import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listfile.dart';

class ServiceScreen extends StatefulWidget {
  final String data;
  ServiceScreen({@required this.data});
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _productServiceDateController = TextEditingController();
  final _productServiceByController = TextEditingController();
  DateTime _dateTime;
  final databaseReference = Firestore.instance;

  /*Function to add record to ServiceTable */
  void createRecordProduct(String id, String date, String name) async {
    await databaseReference.collection("ServiceTable").document(date).setData({
      'productServiceDate': date,
      'productSerialNumber': id,
      'productServicedBy': name
    });
  }

  /*Function to get documents from service Table*/
  Future getPosts() async {
    QuerySnapshot qn =
        await databaseReference.collection("ServiceTable").getDocuments();
    return qn.documents;
  }

  lists listsHolder = new lists();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: FutureBuilder(
                    future: getPosts(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      } else {
                        for (int i = 0; i < snapshot.data.length; i++) {
                          print(snapshot.data[i].data);
                          if (widget.data ==
                              snapshot.data[i].data["productSerialNumber"]) {
                            listsHolder.serviceDate.add(
                                snapshot.data[i].data["productServiceDate"]);
                            listsHolder.serialNumber.add(
                                snapshot.data[i].data["productSerialNumber"]);
                            listsHolder.serviceBy.add(
                                snapshot.data[i].data["productServicedBy"]);
                          }
                        }
                        return ListView.builder(
                            itemCount: listsHolder.serviceDate.length,
                            // ignore: missing_return
                            itemBuilder: (_, index) {
                              return Center(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(listsHolder.serviceDate[index]),
                                      Text(listsHolder.serialNumber[index]),
                                      Text(listsHolder.serviceBy[index])
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _productServiceDateController,
                        decoration: InputDecoration(
                            hintText: 'Select Service Date Of Product'),
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1945),
                            lastDate: DateTime(3000),
                          ).then((date) {
                            setState(() {
                              _dateTime = date;
                              _productServiceDateController.text =
                                  "${_dateTime.day}-${_dateTime.month}-${_dateTime.year}";
                              listsHolder.clearList();
                            });
                          });
                        },
                      ),
                      TextField(
                        controller: _productServiceByController,
                        decoration: InputDecoration(
                            hintText: 'Enter Product Serviced by'),
                      ),
                      RaisedButton(
                        child: Text('Add Service Record'),
                        onPressed: () {
                          setState(() {
                            createRecordProduct(
                                widget.data,
                                _productServiceDateController.text,
                                _productServiceByController.text);
                            _productServiceByController.clear();
                            _productServiceDateController.clear();
                            listsHolder.clearList();
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
