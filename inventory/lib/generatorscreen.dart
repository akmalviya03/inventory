import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:save_in_gallery/save_in_gallery.dart';

/*To show QR and save in to device locally*/
class GeneratorScreen extends StatefulWidget {
  final String data;
  GeneratorScreen({this.data});
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  GlobalKey _globalKey = new GlobalKey();
  final _imageSaver = ImageSaver();
  Future<void> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      await _imageSaver.saveImage(
          imageBytes: pngBytes,
          directoryName: "QRCodes",
          imageName: widget.data);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RepaintBoundary(
                key: _globalKey,
                child: QrImage(
                  backgroundColor: Colors.white,
                  data: widget.data,
                  version: 5,
                  size: 300.0,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                color: Colors.deepOrange,
                child: Text(
                  'Save To Gallery',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: _capturePng,
              )
            ],
          ),
        ),
      ),
    );
  }
}
