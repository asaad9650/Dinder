import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/admin/changeEmailPassword.dart';
import 'package:food_recommendation/admin/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_recommendation/admin/viewFoodTypes.dart';
import 'package:food_recommendation/admin/viewUsers.dart';
import 'package:toast/toast.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  AnimationController controller;
  var foodTypeArray = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  final DatabaseReference foodTypeReference =
      FirebaseDatabase.instance.reference().child("foodType");
  TextEditingController textController;

  // final DatabaseReference databaseReference =
  //     FirebaseDatabase.instance.reference().child('foodType');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String foodType;

  String image;

  @override
  void initState() {
    super.initState();
    // name = auth.currentUser.displayName;
    email = auth.currentUser.email;
    image = auth.currentUser.photoURL;
    foodTypeReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          foodTypeArray.add(values["foodType"]);
          // print(values["foodType"]);
        });
      });
    });
  }

  // Your back press code here...

  // showDialog(context: context, builder: (context) => logoutDialog());

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
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

  Widget logoutDialog() {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: <Widget>[
              Text("are you sure you want to logout?"),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to Logout?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("Admin"),
                accountEmail: new Text(email),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: AssetImage("assets/images/dinder.jpg"),
                  // backgroundColor: Colors.red,
                  // child: Text("Dinder"),
                  // backgroundImage: NetworkImage(image),
                ),
              ),
              new ListTile(
                title: new Text("Home"),
                trailing: new Icon(Icons.home),
                onTap: () {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ChangeEmailPassowrd()),
                  //   (Route<dynamic> route) => false,
                  // );
                },
              ),
              new ListTile(
                title: new Text("View Users"),
                trailing: new Icon(Icons.supervised_user_circle),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewUsers()));
                },
              ),
              new ListTile(
                title: new Text("View Food Types"),
                trailing: new Icon(Icons.fastfood),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFoodTypes()),
                  );
                },
              ),
              new Divider(),
              new ListTile(
                title: new Text("Account Settings"),
                trailing: new Icon(Icons.security),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeEmailPassowrd()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              new ListTile(
                title: new Text("Logout"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () async {
                  try {
                    await auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLogin()),
                      (Route<dynamic> route) => false,
                    );
                    Toast.show("Successfully Logged out", context,
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  } catch (e) {
                    Toast.show(e, context,
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  }
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Hero(
                tag: 'Dinder',
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage(
                    'assets/images/dinder.jpg',
                  ),
                  // backgroundColor: Colors.transparent,
                  radius: 60.0,
                  // child: Image.asset('assets/images/dinder.jpg'),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  "Add Food Type",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    maxLines: 1,
                    showCursor: true,

                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.isEmpty ||
                          value.contains("@") ||
                          value.contains(".") ||
                          value.contains(" ") ||
                          value.contains(",")) {
                        return "*Enter a valid Food Type without any symbol or space";
                      }
                      return null;
                    },
                    onSaved: (value) => foodType = value,
                    keyboardType: TextInputType.text,
                    controller: textController,
                    autofocus: false,
                    enableSuggestions: true,
                    // autovalidate: true,
                    // initialValue: 'alucard@gmail.com',
                    decoration: InputDecoration(
                      hintText: 'Enter a food type here',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: new BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    addType(foodType);
                    // textController.clear();
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.redAccent,
                  child: Text('ADD', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addType(String _foodType) {
    final FormState form = _formKey.currentState;
    bool exist = false;
    if (form.validate()) {
      form.save();

      if (foodTypeArray.contains(foodType)) {
        Toast.show("This Food Type already exist", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      } else {
        foodTypeReference.push().set({'foodType': foodType});
        foodTypeArray.add(foodType);
        Toast.show("Added", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
        _formKey.currentState.reset();
      }
      // for (int i = 0; i < foodTypeArray.length; i++) {
      //   if (foodType == foodTypeArray[i]) {
      //     exist = true;
      //   }
      // }
      // if (exist) {
      // } else {
      // print(foodTypeArray);

      // }
    }
  }
}
