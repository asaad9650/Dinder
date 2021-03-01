import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/admin/admin_home.dart';
import 'package:food_recommendation/admin/login.dart';
import 'package:food_recommendation/admin/viewFoodTypes.dart';
import 'package:toast/toast.dart';

import 'changeEmailPassword.dart';

class ViewUsers extends StatefulWidget {
  @override
  _ViewUsersState createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("users");

  var userArray = [];
  var userEmailArray = [];
  var userPhoneArray = [];

  FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  @override
  void initState() {
    super.initState();
    email = auth.currentUser.email;
    reference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          userArray.add(values["name"]);
          userEmailArray.add(values["email"]);
          userPhoneArray.add(values["phone"]);
          // print(values["foodType"]);
        });
      });
    });
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
          title: Text("View Users"),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              new ListTile(
                title: new Text("View Users"),
                trailing: new Icon(Icons.supervised_user_circle),
                onTap: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => ViewUsers()));
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
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => AdminLogin()));
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
        body: Container(
          child: userArray.length == 0
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  // Let the ListView know how many items it needs to build.
                  itemCount: userArray.length,

                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    return displayUsers(userArray[index], userEmailArray[index],
                        userPhoneArray[index]);
                    // return new Text(userArray[index]);
                  },
                ),
        ),
      ),
    );
  }

  Widget displayUsers(String userName, String userEmail, String userPhone) {
    return Card(
      elevation: 10.0,
      color: Colors.red[90],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
      child: new ListTile(
        title: Text(
          userName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(userEmail),
        trailing: Text(userPhone),

        // leading: Text(userName),
        onTap: () {
          print("Clicked");
          showDialog(
              context: context,
              builder: (context) =>
                  customDialog(userName, userEmail, userPhone));
        },
        // selected: false,
        // dense: true,

        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // crossAxisCount: 1,
        // mainAxisSpacing: 0,
        // children: List.generate(userArray.length, (index) {
        // return displayUI(userArray[index]);
        // }),
      ),
    );
  }

  Widget customDialog(String userName, String email, String phone) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Delete"),
                    onTap: () {
                      deleteUser(userName, email, phone);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text("Close"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // ListTile(),
                ],
              ),
            ),
          ),
        ));
  }

  void deleteUser(String name, String email, String phone) {
    reference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values["name"] == name) {
          reference.child(key).update({"status": "blocked"});
          setState(() {
            userArray.remove(name);
            userEmailArray.remove(email);
            userPhoneArray.remove(phone);
          });
        }
        // setState(() {
        //   userArray.add(values["name"]);
        //   userEmailArray.add(values["email"]);
        //   userPhoneArray.add(values["phone"]);
        //   // print(values["foodType"]);
        // });
      });
    });
  }

  Widget displayUI(String userName) {
    return GestureDetector(
      child: Container(
        // height: 250,
        // child: Row(
        // children: <Widget>[
        // Column(
        // children: <Widget>[
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Text(
              userName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // ],
      ),
      onTap: () {},
    );
  }
}
