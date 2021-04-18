import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrscanner_app/buttonwidget.dart';
import 'package:qrscanner_app/main.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();
}

Data newData = new Data();

class Data {
  String membID = "";
  String barc = "";
  String time = "";

  Data({this.membID, this.barc, this.time});
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  TextEditingController c = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  void submit() {
    _formKey.currentState.save();
  }

  String barcode = '';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scan Result',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$barcode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 72),
              Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      initialValue: '',
                      decoration: new InputDecoration(
                        icon: new Icon(Icons.info),
                        hintText: "ID",
                      ),
                      validator: (val) => val.isEmpty ? null : 'Not a valid ID',
                      onSaved: (val) => newData.membID = val,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      initialValue: '',
                      decoration: new InputDecoration(
                        icon: new Icon(Icons.info),
                        hintText: "Barcode",
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Barcode is required' : null,
                      onSaved: (val) => newData.barc = val,
                    ),
                    trailing: new Icon(Icons.search),
                    onTap: () {
                      {
                        scanBarcode().then((String) => setState(() {
                              c.text = barcode;
                            }));
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(_getDateNow()),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: new Text('Create'),
                    onPressed: () {
                      submit();
                      createItem();
                      Navigator.pop(context, true);
                    },
                  ),
                  // ButtonWidget(
                  //   text: 'Start Barcode scan',
                  //   onClicked: scanBarcode,
                  // ),
                ],
              ),
            ]),
      ));

  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      // String userId = (await FirebaseAuth.instance.currentUser()).uid;
      // final CollectionReference userCollection = Firestore.instance.collection("user");
      // await userCollection.document(userId).collection('points').document(userId)
      //     .updateData({
      //   "points": FieldValue.increment(1),
      //   "transactions": FieldValue.increment(-1)
      // });

      if (!mounted) return;

      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything.)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

Future createItem() async {
  Firestore.instance.runTransaction((Transaction transaction) async {
    CollectionReference reference = Firestore.instance.collection("checkIn");
    await reference.add({
      "memberId": newData.membID,
      "time": _getDateNow(),
      "barcode": newData.barc,
    });
  });
}

_getDateNow() {
  var now = new DateTime.now();
  var formatter = new DateFormat('MM-dd-yyyy H:mm');
  return formatter.format(now);
}
