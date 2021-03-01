import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/admin/admin_home.dart';
import 'package:food_recommendation/admin/login.dart';
import 'package:food_recommendation/admin/viewFoodTypes.dart';
import 'package:food_recommendation/admin/viewUsers.dart';
import 'package:toast/toast.dart';

class ChangeEmailPassowrd extends StatefulWidget {
  @override
  _ChangeEmailPassowrdState createState() => _ChangeEmailPassowrdState();
}

class _ChangeEmailPassowrdState extends State<ChangeEmailPassowrd> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  bool _passwordVisible;
  bool _confirmPasswordVisible;
  String _email, _password, _confirmPassword;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _confirmPasswordVisible = true;
    email = auth.currentUser.email;
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
          title: Text("Change Email/Password"),
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
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ChangeEmailPassowrd()),
                  //   (Route<dynamic> route) => false,
                  // );
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
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                      radius: 40.0,
                      // child: Image.asset('assets/images/dinder.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Text(
                      "Change Your Account",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      maxLines: 1,
                      showCursor: true,
                      validator: (value) {
                        if (value.isEmpty ||
                            !value.contains("@") ||
                            !value.contains(".com")) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      enableSuggestions: true,
                      // initialValue: 'alucard@gmail.com',
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      maxLines: 1,
                      showCursor: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Password should be alteast 5 characters long";
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value,
                      onChanged: (value) => _password = value,
                      autofocus: false,
                      // initialValue: 'some password',
                      obscureText: _passwordVisible,

                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: new BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: new BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(32.0),
                        //   borderSide: BorderSide(
                        //     color: Colors.redAccent,
                        //     width: 2,
                        //   ),
                        // ),
                        // focusColor: Colors.red,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      maxLines: 1,
                      showCursor: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Password should be alteast 5 characters long";
                        } else if (_password != _confirmPassword) {
                          return "Your Password does not match";
                        }
                        return null;
                      },
                      onSaved: (value) => _confirmPassword = value,
                      onChanged: (value) => _confirmPassword = value,
                      autofocus: false,
                      // initialValue: 'some password',
                      obscureText: _confirmPasswordVisible,

                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: new BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: new BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(32.0),
                        //   borderSide: BorderSide(
                        //     color: Colors.redAccent,
                        //     width: 2,
                        //   ),
                        // ),
                        // focusColor: Colors.red,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          update(_email, _password, _confirmPassword);
                          // print("hereeeee");
                          // print(email);
                          // print(password);
                          // login_with_auth(email, password);
                          // Navigator.of(context).pushNamed(HomePage.tag);
                        },
                        padding: EdgeInsets.all(12),
                        color: Colors.redAccent,
                        child: Text('UPDATE',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void update(String _userEmail, String _userPassword,
      String _userConfirmPassword) async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        await auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        Toast.show("Successfully Updated. ", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } catch (e) {
        Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}
