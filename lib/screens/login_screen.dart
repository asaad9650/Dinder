import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recommendation/screens/step1.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name, email, phone, zip, age;
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');
  String databaseKey;
  Future<bool> rootFirebaseIsExists(DatabaseReference databaseReference) async {
    DataSnapshot snapshot = await databaseReference.once();

    return snapshot != null;
  }

  Future sendData(String username, String useremail, String userphone,
      String userzip, String userage) async {
    setState(() {
      isLoading = true;
    });
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: useremail, password: userphone);
        databaseKey = databaseReference.push().key;
        databaseReference.child(databaseKey).set({
          'name': username,
          'email': useremail,
          'phone': userphone,
          'zip_code': userzip,
          'age': userage,
          'default_radiius': 'null',
          'status': "null",
          'what_matters': 'null',
          'often_travel': ' null',
          'eat_outside': 'null',
          'eat_with_one': 'null'
        });
        addStringToSF(databaseKey, useremail, userphone);
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        if (error.hashCode.toString() == '86194409') {
          Toast.show(
              "This Email already in use, Please try with a different Email",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP);
        } else {
          Toast.show(error.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
        // if (error is PlatformException) {
        // if (error.code == "EMAIL_ALREADY_IN_USE") {

        // }
        // }
        setState(() {
          isLoading = false;
        });
      }

      print(databaseKey);
      print(username);
      print(useremail);
      print(userphone);
      print(userzip);
    }
  }

  addStringToSF(String sf, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('my_string_key', sf);
    prefs.setString('my_string_email', email);
    prefs.setString("my_string_phone", phone);
    _navigateToNextScreen(context);
  }

  void _navigateToNextScreen(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Step1()));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _zip = TextEditingController();
  final _age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        //appBar: AppBar(title: Text('Login')),
        body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/wall.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _name,
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                return 'Please enter name';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              name = value;
                            },
                            onChanged: (value) {
                              name = value;
                            },
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              hintText: 'Name',
                              hintMaxLines: 1,
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              //errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                                //borderSide: new BorderSide(color: Colors.black),
                                //),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _email,
                            onSaved: (value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@")) {
                                setState(() {
                                  isLoading = false;
                                });
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              hintText: 'Email',
                              hintMaxLines: 1,
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              //errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                                //borderSide: new BorderSide(color: Colors.black),
                                //),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _phone,
                            onSaved: (value) {
                              phone = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                return 'Please enter phone';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              phone = value;
                            },
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              hintText: 'Phone',
                              hintMaxLines: 1,

                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              //errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                                //borderSide: new BorderSide(color: Colors.black),
                                //),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _age,
                            onSaved: (value) {
                              age = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                return 'Please enter your age';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              age = value;
                            },
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              hintText: 'Your Age',
                              hintMaxLines: 1,

                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              //errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                                //borderSide: new BorderSide(color: Colors.black),
                                //),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _zip,
                            onSaved: (value) {
                              zip = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                return 'Please enter zip code';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              zip = value;
                            },
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              hintText: 'Zip Code',
                              hintMaxLines: 1,
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              //errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                                //borderSide: new BorderSide(color: Colors.black),
                                //),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            //buttonColor: Colors.blue,
                            minWidth: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.blue,
                              child: Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                sendData(name, email, phone, zip, age);
                                // setState(() {
                                //   isLoading = true;
                                // });
                                // if (_name.text.isEmpty ||
                                //     _email.text.isEmpty ||
                                //     _phone.text.isEmpty ||
                                //     _zip.text.isEmpty) {
                                //   //Scaffold.of(context).showSnackBar(
                                //   // new SnackBar(
                                //   //  content: new Text('Please Enter Name'),
                                //   // ),
                                //   //);
                                //   Toast.show("Please fill all fields", context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.TOP);
                                // } else if (!_email.text.contains('@') ||
                                //     !_email.text.contains('.com')) {
                                //   Toast.show(
                                //       "Please enter a valid email", context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.TOP);
                                // } else if (_name.text.length < 5) {
                                //   Toast.show(
                                //       "Name should be atleast 5 characters",
                                //       context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.TOP);
                                // } else if (_zip.text.length < 5) {
                                //   Toast.show(
                                //       "Zip code cann\'t be less than 5 characters",
                                //       context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.TOP);
                                // } else if (_phone.text.length < 11) {
                                //   Toast.show(
                                //       "Enter a valid phone number", context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.TOP);
                                // } else {
                                //   sendData(
                                //       _name.text.toString(),
                                //       _email.text.toString(),
                                //       _phone.text.toString(),
                                //       _zip.text.toString());
                                //   _navigateToNextScreen(context);
                                // }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
