import 'package:flutter/cupertino.dart';

class ModalOverallReport {
  bool isNetworkStatus = false;
  bool boolNodata = false;
  bool eventCircularLoader = true;
  bool loadingEnableDisable = false;
  double loadingCircularBar = 0.0;

  String CallLogImportIds = "";
  String IsCallBlock = "";
  Map mapProductDetDetailsData;

  TextEditingController textEditingControllerFromDate =
      new TextEditingController();
  TextEditingController textEditingControllerToDate =
      new TextEditingController();

  String fromDate;
  String toDate;
}
