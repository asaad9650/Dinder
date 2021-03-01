import 'package:flutter/material.dart';
import 'package:food_recommendation/userOrAdmin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_recommendation/admin/admin_home.dart';
import 'package:food_recommendation/admin/forgotpassword.dart';
import 'package:toast/toast.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // if (kReleaseMode) exit(1);
  };
  runApp(AdminLogin());
}

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool _passwordVisible;
  bool _loading = false;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email, password;
  // final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // try {
  // final user = _firebaseAuth.currentUser;

  // catch (e) {
  // Toast.show(e, context,
  // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

  void checkLogin() async {
    // // try {
    // //   User user = _firebaseAuth.currentUser;
    // //   // final user = await _firebaseAuth.currentUser;
    // //   if (user != null) {
    // //     Future.delayed(Duration.zero, () {
    // //       Navigator.of(context).push(
    // //         MaterialPageRoute(builder: (context) => AdminHome()),
    // //         // Navigator.pushAndRemoveUntil(
    // //         //   context,
    // //         //   MaterialPageRoute(builder: (context) => AdminHome()),
    // //         //   (Route<dynamic> route) => false,
    // //       );
    // //     });
    //   }
    // } catch (e) {
    //   print(e);
    //   // Toast.show(e.toString(), context,
    //   //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = true;
    super.initState();
    // showCirc
    // checkLogin();
  }

  // signIn("recommendation.food@gmail.com", "academy150");
  // if (FirebaseAuth.instance.currentUser != null) {
  //   Toast.show("Already", context,
  //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   print("Already");
  //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //   //   builder: (context) => HomeScreen()
  // } else {
  //   Toast.show("Not Already", context,
  //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   print("Not Already.");
  // }
  //}
  Future<bool> _onWillPop() async {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserOrAdmin()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ModalProgressHUD(
            inAsyncCall: _loading,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
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
                        SizedBox(height: 48.0),
                        Container(
                          child: Text(
                            "Admin Login",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 48.0),
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
                            onSaved: (value) => email = value,
                            onChanged: (value) => email = value,
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
                        SizedBox(height: 8.0),
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
                            onSaved: (value) => password = value,
                            onChanged: (value) => password = value,
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
                        SizedBox(height: 24.0),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin:
                                EdgeInsets.only(left: 30, right: 30, top: 10),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  // print("hereeeee");
                                  // print(email);
                                  // print(password);
                                  loginWithAuth(email, password);

                                  // Navigator.of(context).pushNamed(HomePage.tag);
                                },
                                padding: EdgeInsets.all(12),
                                color: Colors.redAccent,
                                child: Text('LOGIN',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 1,
                                decorationThickness: 1.5,
                                color: Colors.black54,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                          },
                        )
                      ],
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

  Future loginWithAuth(String _email, String _password) async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      try {
        setState(() {
          _loading = true;
        });
        await _firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password);
        // print(object)

        Toast.show("Login successfull. ", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminHome()));
      } catch (e) {
        setState(() {
          _loading = false;
        });
        Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        print(e.toString());
      }
    }
  }

  Future<void> forgotPassword() async {
    // await _firebaseAuth.signOut();
  }
  // body: Center(
  //   child: ListView(
  //     shrinkWrap: true,
  //     padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //     children: <Widget>[
  //       logo,
  //       SizedBox(height: 48.0),
  //       email,
  //       SizedBox(height: 8.0),
  //       password,
  //       SizedBox(height: 24.0),
  //       loginButton,
  //       forgotLabel
  //     ],
  //   ),
  // ),
  // );
  // appBar: AppBar(
  // title: Text("Home"),
  // ),
  // body: SafeArea(
  //   child: Center(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Container(
  //             child: Form(
  //               key: _formKey,
  //               child: Stack(
  //                 // alignment: Alignment.topCenter,
  //                 children: <Widget>[
  //                   Container(
  //                     // padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
  //                     child: CircleAvatar(
  //                       radius: 70,
  //                       backgroundImage: ExactAssetImage(
  //                         'assets/images/dinder.jpg',
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Container(
  //             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             child: TextFormField(
  //               validator: (input) {
  //                 if (!input.contains('@') ||
  //                     !input.contains('.com') ||
  //                     input.isEmpty) {
  //                   return 'Please enter a valid Email';
  //                 }
  //               },
  //               onSaved: (input) => _email = input,
  //               enabled: true,
  //               decoration: InputDecoration(
  //                 labelText: 'EMAIL',
  //                 labelStyle: TextStyle(
  //                   fontFamily: 'Montserrat',
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 15,
  //                   color: Colors.grey,
  //                 ),
  //                 focusedBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.green),
  //                 ),
  //               ),
  //               obscureText: false,
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Container(
  //             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             child: TextFormField(
  //               validator: (input) {
  //                 if (input.length < 6) {
  //                   return 'Password should be atleast 6 characters long.';
  //                 }
  //               },
  //               onSaved: (input) => _password = input,
  //               enabled: true,
  //               decoration: InputDecoration(
  //                 labelText: 'PASSWORD',
  //                 labelStyle: TextStyle(
  //                   fontFamily: 'Montserrat',
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.grey,
  //                   fontSize: 15,
  //                 ),
  //                 focusedBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.green),
  //                 ),
  //               ),
  //               obscureText: true,
  //             ),
  //           ),
  //           Container(
  //             alignment: Alignment(1, 0),
  //             padding: EdgeInsets.only(top: 15, left: 20, right: 10),
  //             child: InkWell(
  //               child: Text(
  //                 'Forgot Password?',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold,
  //                   decoration: TextDecoration.underline,
  //                   fontFamily: 'Montserrat',
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Container(
  //             padding: EdgeInsets.only(left: 10, right: 10),
  //             height: 40,
  //             child: Material(
  //               borderRadius: BorderRadius.circular(20),
  //               shadowColor: Colors.redAccent,
  //               color: Colors.redAccent,
  //               // elevation: 7.0,
  //               child: GestureDetector(
  //                 child: Center(
  //                   child: Text(
  //                     'LOGIN',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'Montserrat',
  //                     ),
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   signIn(_email, _password);
  //                 },
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   ),
  // ),
  // );

  Future<void> signIn(String email, String password) async {
    email = "recommendation.food@gmail.com";
    password = "academy150";
    print("DEEKH TERAA BAAAP AYA");
    // final formState = _formKey.currentState;
    // if (formState.validate()) {
    //   formState.save();
    //   // try {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (user != null) {
      Toast.show(user.additionalUserInfo.username.toString(), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      print("HOGAYAAAA");
      print(_firebaseAuth.currentUser.email);
      return "Hogaya";
    } else {
      Toast.show("Naeeee hua", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      print("NAEEEEE HUAAA");
      return "Naeeee HUAAAA";
    }

    // FirebaseAuth.instance.currentUser().then((firebaseUser) {
    // r  if (firebaseUser == null) {
    //     //signed out
    //   } else {
    //     //signed in
    //   }
    // });
    // FirebaseUser user = _firebaseAuth.currentUser;
    Toast.show(_firebaseAuth.currentUser.toString(), context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    // } catch (e) {
    //   Toast.show(e.toString(), context,
    //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // }
  }
}
