import 'package:flutter/cupertino.dart';

class ModalForgotPassword {
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

  ModalForgotPassword() {}

  TextEditingController controllerEmailID = new TextEditingController();
  TextEditingController controllerNewPassword = new TextEditingController();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  var email = "";
  Map mapSignUpData;
}
