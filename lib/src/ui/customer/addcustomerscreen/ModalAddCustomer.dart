import 'package:flutter/cupertino.dart';

class ModalAddCustomer {
  bool isNetworkStatus = false;
  bool boolNodata = false;
  String languageDropDownName = "Deutsch";
  int languageDropDownID = 1;
  bool visibleOnline = false;
  bool invisibleOffline = false;
  bool loadingEnableDisable = false;
  double loadingCircularBar = 0.0;

  var emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  ModalAddCustomer() {}

  TextEditingController controllerCustomerName = new TextEditingController();
  TextEditingController controllerCustomerBillingName =
      new TextEditingController();
  TextEditingController controllerCustomerAddress = new TextEditingController();
  TextEditingController controllerCustomerPhoneNumber =
      new TextEditingController();
  TextEditingController controllerCustomerWhatsAppNumber =
      new TextEditingController();

  final focusCustomerName = FocusNode();
  final focusCustomerBillingName = FocusNode();
  final focusCustomerAddress = FocusNode();
  final focusCustomerPhoneNumber = FocusNode();
  final focusCustomerWhatsAppNumber = FocusNode();



  var email = "";
  Map mapSignUpData;
}
