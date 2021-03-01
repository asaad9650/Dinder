import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeRadius extends StatefulWidget {
  @override
  _ChangeRadiusState createState() => _ChangeRadiusState();
}

class _ChangeRadiusState extends State<ChangeRadius> {
  List<String> radius = <String>[
    '2 miles',
    '5 miles',
    '10 miles',
    '15 miles',
    '18 miles',
    '20 miles',
    '25 miles'
  ];

  var selectedRadius = "5 miles";

  // var model = ExampleModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: radius.length == 7
          ? Center(child: Text("Ali Arfa"))
          : Center(
              child: Text("Saad Amir"),
            ),
    );
  }

  Row buildNumberRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150.0,
          child: RaisedButton(
            color: Colors.white,
            child: Text("Radius Picker"),
            onPressed: () => showMaterialScrollPicker(
              context: context,
              title: "Pick Your Radius",
              items: radius,
              selectedItem: selectedRadius,

              // maxNumber: 25,
              // minNumber: 2,
              // selectedNumber: age,
              onChanged: (value) => setState(() => selectedRadius = value),
            ),
          ),
        ),
        Expanded(
          child: Text(
            selectedRadius,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
