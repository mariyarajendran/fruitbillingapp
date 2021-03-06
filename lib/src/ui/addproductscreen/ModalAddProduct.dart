import 'package:flutter/cupertino.dart';

class ModalAddProduct {
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

  ModalAddProduct() {}

  TextEditingController controllerUserName = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();

  TextEditingController controllerProductName = new TextEditingController();
  TextEditingController controllerProductCost = new TextEditingController();
  TextEditingController controllerProductCode = new TextEditingController();
  TextEditingController controllerProductKg = new TextEditingController();

  final focusProductName = FocusNode();
  final focusProductCost = FocusNode();
  final focusProductCode = FocusNode();
  final focusProductKg = FocusNode();

  final focusPassword = FocusNode();

  var email = "";
  Map mapSignUpData;
}
