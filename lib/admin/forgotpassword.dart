import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/admin/login.dart';
import 'package:toast/toast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Hero(
                  tag: 'Dinder',
                  child: CircleAvatar(
                    backgroundImage: ExactAssetImage(
                      'assets/images/dinder.jpg',
                    ),
                    // backgroundColor: Colors.transparent,
                    radius: 70.0,
                    // child: Image.asset('assets/images/dinder.jpg'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
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
                      hintText: 'Type your email here',
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
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        sendEmail(_email);
                        // Login(_email, _password);
                        // Navigator.of(context).pushNamed(HomePage.tag);
                      },
                      padding: EdgeInsets.all(12),
                      color: Colors.redAccent,
                      child: Text('Send Confirmation',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                FlatButton(
                  child: Text(
                    'Or Login from here',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 1,
                        decorationThickness: 1.5,
                        color: Colors.black54,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminLogin()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(String email) async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _firebaseAuth.sendPasswordResetEmail(email: email);
      Toast.show("Email sent successfully ", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      form.reset();
    }
  }
}
