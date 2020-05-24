import 'package:flutter/material.dart';
import 'scan.dart';
import 'generator_data.dart';
import 'package:flutter_icons/flutter_icons.dart';

void main() => runApp(Inventory());

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Center(
      child: GeneratorDataScreen(),
    ),
    Center(
      child: Scan(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 50,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.qrcode),
              title: Text('Gnerate'),
            ),
            BottomNavigationBarItem(
              icon: Icon(AntDesign.scan1),
              title: Text('Scan'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
