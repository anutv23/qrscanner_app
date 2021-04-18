// import 'dart:convert';

// import 'package:AdminDemo01/CheckList/confirmation_dialog.dart';
// import 'package:AdminDemo01/CheckList/edit_task_dialog.dart';
// import 'package:AdminDemo01/CheckList/item.model.dart';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';


// class Date20201203 extends StatefulWidget {
//   static const String routeName = '/Date20201203';
//   Date20201203({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _Date20201203State createState() => _Date20201203State();
// }

// class _Date20201203State extends State<Date20201203> {
//   var uuid = Uuid();
//   var itemList = List<Item>();

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   //String name = "";
//   ScanResult scanResult;
//   //var textController = new TextEditingController();

//   final _flashOnController = TextEditingController(text: "Flash on");
//   final _flashOffController = TextEditingController(text: "Flash off");
//   final _cancelController = TextEditingController(text: "Cancel");

//   var _aspectTolerance = 0.00;
//   var _selectedCamera = -1;
//   var _useAutoFocus = true;
//   var _autoEnableFlash = false;
//   static final _possibleFormats = BarcodeFormat.values.toList()
//     ..removeWhere((e) => e == BarcodeFormat.unknown);

//   List<BarcodeFormat> selectedFormats = [..._possibleFormats];
//   TextEditingController controllerScanResult;
//   String firstName = "";

//   @override
//   Widget build(BuildContext context) {
//     if (scanResult == null) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Card(
//             child: TextField(
//               decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search), hintText: 'Search...'),
//               onChanged: (val) {
//                 setState(() {
//                   firstName = val;
//                 });
//               },
//             ),
//           ),
//         ),
//         body: ReorderableListView(
//           onReorder: _onReorder,
//           children: List.generate(itemList.length, (index) {
//             return Card(
//               key: ValueKey(itemList[index].id),
//               child: Dismissible(
//                 key: Key(itemList[index].id),
//                 child: CheckboxListTile(
//                   title: Text(
//                     itemList[index].title,
//                     style: TextStyle(
//                       decoration: itemList[index].done
//                           ? TextDecoration.lineThrough
//                           : null,
//                     ),
//                   ),
//                   subtitle: Text(itemList[index].id),
//                   value: itemList[index].done,
//                   onChanged: (bool value) {
//                     setState(() {
//                       itemList[index].done = !itemList[index].done;
//                     });
//                     save();
//                   },
//                 ),
//                 background: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0.0),
//                   alignment: Alignment.centerLeft,
//                   color: Colors.blueAccent,
//                   child: Icon(Icons.edit),
//                 ),
//                 secondaryBackground: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0.0),
//                   alignment: Alignment.centerRight,
//                   color: Colors.redAccent,
//                   child: Icon(Icons.delete),
//                 ),
//                 confirmDismiss: (direction) async {
//                   if (direction == DismissDirection.endToStart) {
//                     var result = await _showConfirmationDialog(
//                       context,
//                       'delete',
//                     );
//                     if (result) {
//                       remove(index);
//                     }
//                   } else {
//                     var result = await _showEditDialog(
//                       context,
//                       itemList[index],
//                       scanResult.rawContent.toString(),
//                     );
//                     if (result) {
//                       update(index, itemList[index]);
//                     }
//                   }
//                   return false;
//                 },
//               ),
//             );
//           }),
//         ),
//         floatingActionButton: FloatingActionButton(
//          onPressed: () async {
//             scan();
//             Item newItem = Item();
//             var result = await _showEditDialog(
//               context,
//               newItem,
//               "Check In",
              
//             );
//             if (result) {
//               add(newItem);
//             }
//           },
//           tooltip: 'Add New Task',
//           child: Icon(Icons.add),
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Card(
//             child: TextField(
//               decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: scanResult.rawContent.toString()),
//               onChanged: (val) {
//                 setState(() {
//                   firstName = val;
//                 });
//               },
//             ),
//           ),
//         ),
//         body: ReorderableListView(
//           onReorder: _onReorder,
//           children: List.generate(itemList.length, (index) {
//             return Card(
//               key: ValueKey(itemList[index].id),
//               child: Dismissible(
//                 key: Key(itemList[index].id),
//                 child: CheckboxListTile(
//                   title: Text(
//                     itemList[index].title,
//                     style: TextStyle(
//                       decoration: itemList[index].done
//                           ? TextDecoration.lineThrough
//                           : null,
//                     ),
//                   ),
//                   subtitle: Text(itemList[index].id),
//                   value: itemList[index].done,
//                   onChanged: (bool value) {
//                     setState(() {
//                       itemList[index].done = !itemList[index].done;
//                     });
//                     save();
//                   },
//                 ),
//                 background: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0.0),
//                   alignment: Alignment.centerLeft,
//                   color: Colors.blueAccent,
//                   child: Icon(Icons.edit),
//                 ),
//                 secondaryBackground: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0.0),
//                   alignment: Alignment.centerRight,
//                   color: Colors.redAccent,
//                   child: Icon(Icons.delete),
//                 ),
//                 confirmDismiss: (direction) async {
//                   if (direction == DismissDirection.endToStart) {
//                     var result = await _showConfirmationDialog(
//                       context,
//                       'delete',
//                     );
//                     if (result) {
//                       remove(index);
//                     }
//                   } else {
//                     var result = await _showEditDialog(
//                       context,
//                       itemList[index],
//                       "",
//                     );
//                     if (result) {
//                       update(index, itemList[index]);
//                     }
//                   }
//                   return false;
//                 },
//               ),
//             );
//           }),
//         ),
//         floatingActionButton: FloatingActionButton(
//          onPressed: () async {
//             scan();
//             Item newItem = Item();
//             var result = await _showEditDialog(
//               context,
//               newItem,
//               scanResult.rawContent.toString(),
//             );
//             if (result) {
//               add(newItem);
//             }
//           },
//           tooltip: 'Add New Task',
//           child: Icon(Icons.add),
//         ),
//       );
//     }
//   }

//   void add(Item item) {
//     //item.id = uuid.v4();
//     item.id = DateTime.now().toString();
//     item.done = false;
//     item.title = scanResult.rawContent;
//     setState(() {
//       itemList.add(item);
//     });

//     save();
//   }

//   void remove(int index) {
//     setState(() {
//       itemList.removeAt(index);
//     });
//     save();
//   }

//   void update(int index, Item item) {
//     setState(() {
//       itemList[index] = item;
//     });
//     save();
//   }

//   Future load() async {
//     var prefs = await SharedPreferences.getInstance();
//     var data = prefs.getString('data');

//     if (data != null) {
//       Iterable decoded = jsonDecode(data);
//       List<Item> result = decoded.map((item) => Item.fromJson(item)).toList();
//       setState(() {
//         itemList = result;
//       });
//     }
//   }

//   save() async {
//     var prefs = await SharedPreferences.getInstance();
//     await prefs.setString('data', jsonEncode(itemList));
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final Item item = itemList.removeAt(oldIndex);
//       itemList.insert(newIndex, item);
//     });
//     save();
//   }

//   Future<bool> _showConfirmationDialog(BuildContext context, String action) {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return ConfirmationAlertDialog(
//           action: 'delete',
//         );
//       },
//     );
//   }

//   Future<bool> _showEditDialog(BuildContext context, Item item, String title) {
//     TextEditingController _itemTitleController = TextEditingController();
//     _itemTitleController.text = "Check In Member";
//     return showDialog<bool>(
//               context: context,
//               barrierDismissible: true,
//               builder: (BuildContext context) {
//                 return EditTaskDialog(
//                   itemTitleController: _itemTitleController,
//                   item: item,
//                   title: title,
//                 );
//               },
//             );
//   }

//   Future scan() async {
//     try {
//       var options = ScanOptions(
//         strings: {
//           "cancel": _cancelController.text,
//           "flash_on": _flashOnController.text,
//           "flash_off": _flashOffController.text,
//         },
//         restrictFormat: selectedFormats,
//         useCamera: _selectedCamera,
//         autoEnableFlash: _autoEnableFlash,
//         android: AndroidOptions(
//           aspectTolerance: _aspectTolerance,
//           useAutoFocus: _useAutoFocus,
//         ),
//       );

//       var result = await BarcodeScanner.scan(options: options);

//       setState(() => scanResult = result);
//     } on PlatformException catch (e) {
//       var result = ScanResult(
//         type: ResultType.Error,
//         format: BarcodeFormat.unknown,
//       );

//       if (e.code == BarcodeScanner.cameraAccessDenied) {
//         setState(() {
//           result.rawContent = 'The user did not grant the camera permission!';
//         });
//       } else {
//         result.rawContent = 'Unknown error: $e';
//       }
//       setState(() {
//         scanResult = result;
//       });
//     }
//   }
// }
