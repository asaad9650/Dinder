import 'package:flutter/material.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:toast/toast.dart';
import 'package:food_recommendation/screens/payment/mastercard.dart';
import 'package:food_recommendation/screens/payment/paypal.dart';
import 'package:food_recommendation/screens/payment/visacard.dart';
import 'package:square_in_app_payments/google_pay_constants.dart';

class GoPremium extends StatefulWidget {
  @override
  _GoPremiumState createState() => _GoPremiumState();
}

class _GoPremiumState extends State<GoPremium> {
  onItemClick(String click) {
    if (click == "visa") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => VisaCard()));
    } else if (click == "master") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MasterCard()));
    } else if (click == "paypal") {
      Toast.show("This service is currently unavailable right now", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => PayPal()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(child: buildPaymentOptions()),
      ),
    );
  }

  Widget buildPaymentOptions() {
    // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Subscribe now for ads free access",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\$ 4.99 / month",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Text(
          "Pay with",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          child: Container(
            child: Image(
              image: AssetImage("assets/images/visa.png"),
              fit: BoxFit.cover,
              height: 120,
              width: 150,
            ),
          ),
          onTap: () {
            onItemClick("visa");
          },
        ),
        GestureDetector(
          child: Container(
            child: Image(
              image: AssetImage("assets/images/master.png"),
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
          ),
          onTap: () {
            onItemClick("master");
          },
        ),
        GestureDetector(
          child: Container(
            child: Image(
              image: AssetImage("assets/images/paypal.png"),
              fit: BoxFit.fill,
              height: 120,
              width: 240,
            ),
          ),
          onTap: () {
            onItemClick("paypal");
          },
        ),
      ],
    );
    // } else {}
  }
}
