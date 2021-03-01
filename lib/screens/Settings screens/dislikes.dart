import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dislikes extends StatefulWidget {
  @override
  _DislikesState createState() => _DislikesState();
}

class _DislikesState extends State<Dislikes> {
  List dislikedItems = [];
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("users");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSF();
  }

  Future getSF() async {
    final prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';

    databaseReference
        .child(myString)
        .child("dislikes")
        .once()
        .then((DataSnapshot snap) {
      // print(snap.value);
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      for (var individualKey in KEYS) {
        print(DATA[individualKey]["dislike"]);
        dislikedItems.add(DATA[individualKey]["dislike"]);
        setState(() {
          print('Length: $dislikedItems.length');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(dislikedItems);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dislikes"),
        centerTitle: false,
      ),
      body: Column(
        children: dislikedItems.map((item) {
          return Card(
            child: ListTile(
              title: Text(
                '$item',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onTap: () {
                    showAlert(context, '$item');
                  }),
            ),
          );
        }).toList(),
      ),
    );
  }

  showAlert(BuildContext context, String item) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.redAccent),
      ),
      onPressed: () {
        deleteFromDislikes(item);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("You want to remove $item from dislikes"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deleteFromDislikes(String removedItem) async {
    final prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';
    DatabaseReference deleteRef = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(myString)
        .child("dislikes");

    deleteRef.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((keys, values) {
        // restaurantList.clear();
        if (values["dislike"] == removedItem) {
          print(values["dislike"]);
          deleteRef.child(keys).remove();

          setState(() {
            dislikedItems.remove(removedItem);
          });

          // deleteRef.child(keys).remove();
          // print(type);
          // print(distance);
          // print(values["foodType"]);
          // deleteRef.child(keys).remove();
          // setState(() {
          // getSF();
          // restaurantList.remove(value)
          // });
        }
      });
    });
  }
}
