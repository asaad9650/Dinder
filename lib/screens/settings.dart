import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:food_recommendation/screens/Settings%20screens/changeradius.dart';
import 'package:food_recommendation/screens/Settings%20screens/dislikes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> radius = <String>[
    '2 miles',
    '5 miles',
    '10 miles',
    '15 miles',
    '18 miles',
    '20 miles',
    '25 miles'
  ];

  var selectedRadius = "";

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  Future getSF(String radius) async {
    final prefs = await SharedPreferences.getInstance();
    //Return String
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';

    databaseReference.child(myString).update({'default_radiius': radius});
  }

  Future getDefaultRadius() async {
    final prefs = await SharedPreferences.getInstance();
    //Return String
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';

    DatabaseReference restRef =
        FirebaseDatabase.instance.reference().child("users").child(myString);

    restRef.once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> value = snap.value;
      // value.forEach((keys, values) {
      print(value["default_radiius"]);
      setState(() {
        selectedRadius = value["default_radiius"];
      });
      // });
    });
  }

  @override
  void initState() {
    super.initState();
    getDefaultRadius();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Food Selection Settings',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Card(
              child: ListTile(
                title: Text(
                  'Default Radius',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  selectedRadius,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            onTap: () => showMaterialScrollPicker(
                context: context,
                title: "Pick Your Radius",
                items: radius,
                selectedItem: selectedRadius,
                onChanged: (value) {
                  setState(() => selectedRadius = value);
                  getSF(selectedRadius);
                }),
          ),
          GestureDetector(
            child: Card(
              child: ListTile(
                title: Text(
                  'Privacy and Policy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context, builder: (context) => customDialog());
            },
          ),
          GestureDetector(
            child: Card(
              child: ListTile(
                title: Text(
                  'Dislikes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Dislikes()));
            },
          ),
        ],
      ),
    );

    // body: ListView.builder(
    //   itemCount: 3,
    //   itemBuilder: (BuildContext context, int index) {
    //     return GestureDetector(
    //       onTap: () {
    //         print('object');
    //       },
    //       child: Card(
    //         child: ListTile(
    //           title: Text('abbajabba'),
    //         ),
    //       ),
    //     );
    //   },
    // ),
  }

  // Row buildNumberRow(BuildContext context) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         width: 150.0,
  //         child: RaisedButton(
  //           child: Text("Number Picker"),
  //           onPressed: () => showMaterialScrollPicker(
  //             context: context,
  //             title: "Pick Your Radius",
  //             items: radius,
  //             selectedItem: selectedRadius,

  //             // maxNumber: 25,
  //             // minNumber: 2,
  //             // selectedNumber: age,
  //             onChanged: (value) => setState(() => selectedRadius = value),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Text(
  //           selectedRadius,
  //           textAlign: TextAlign.right,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget showScroll() {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            child: Card(
              child: Text("Default Radius"),
            ),
            onDoubleTap: () => showMaterialScrollPicker(
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
        ],
      ),
    );
  }

  Widget customDialog() {
    return Material(
        type: MaterialType.transparency,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Card(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                    "Dinder built the Dinder app as an Ad Supported app. This SERVICE is provided by Dinder at no cost and is intended for use as is.\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Dinder unless otherwise defined in this Privacy Policy.\nFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information that we request will be retained by us and used as described in this privacy policy.\nWe want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.\nThis Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.\nWe value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\nBy agreeing our privacy policies you agree the app can use device location, phone and storage for better performance of the application\nWe may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page."),
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Contact Us!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                    "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at recommendation.food@gmail.com."),
                              ),
                              Divider(),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.redAccent)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok!"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
