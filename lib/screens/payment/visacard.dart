import 'package:flutter/material.dart';
import 'package:square_in_app_payments/google_pay_constants.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:toast/toast.dart';

class VisaCard extends StatefulWidget {
  @override
  _VisaCardState createState() => _VisaCardState();
}

class _VisaCardState extends State<VisaCard> {
  void _cardEntryCancel() {}
  void _cardNonceRequestSuccess(CardDetails results) {
    Toast.show(results.nonce, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() {
    Toast.show("Successfully completed the payment", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: start(),
      ),
    );
  }

// https://squareup.com/signup/pk/business-information
  Widget start() {
    InAppPayments.setSquareApplicationId("sq0idp-Gp_OnoEQsjRRuqgmU2Hc7w");
    InAppPayments.startCardEntryFlow(
      onCardEntryCancel: _cardEntryCancel,
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    );
  }
}
