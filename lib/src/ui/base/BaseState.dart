import 'package:IGO/src/data/HttpStatusString.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/di/di.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/BillPreviewScreen.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/bills/pendingbalancescreen/PendingBalanceListScreen.dart';
import 'package:IGO/src/ui/bills/updatependingbalance/ModelUpdatePending.dart';
import 'package:IGO/src/ui/bluetoothtest/BluetoothDemo.dart';
import 'package:IGO/src/ui/customer/addcustomerscreen/AddCustomerScreen.dart';
import 'package:IGO/src/ui/customer/customercrud/CustomerListsCrudScreen.dart';
import 'package:IGO/src/ui/customer/customerlist/CustomerListsScreen.dart';
import 'package:IGO/src/ui/dashboard/DashboardScreen.dart';
import 'package:IGO/src/ui/product/addproductscreen/AddProductScreen.dart';
import 'package:IGO/src/ui/product/cartscreen/CartListScreen.dart';
import 'package:IGO/src/ui/product/productcrud/ProductCrudScreen.dart';
import 'package:IGO/src/ui/product/productlist/ProductLists.dart';
import 'package:IGO/src/ui/report/overalldetailreport/OverAllDetailedReportScreen.dart';
import 'package:IGO/src/ui/report/overallreport/OverallReportListScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/SessionManager.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'package:IGO/src/utils/constants/ConstantSize.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

import '../../utils/localizations.dart';

abstract class BaseStateStatefulState<T extends StatefulWidget>
    extends State<T> {
  BuildContext contextLoadingDialog, contextAlertDialog;
  SessionManager _sessionManager;

  TextEditingController textEditingControllerKilograms =
      new TextEditingController();

  TextEditingController textEditingControllerReceivedAmount =
      new TextEditingController();

  TextEditingController textEditingControllerPendingAmount =
      new TextEditingController();

  BaseStateStatefulState() {
    // Parent constructor
    _sessionManager = new SessionManager();

    ///getLocal jwt session
    getLocalSessionDatas();
  }

  @override
  void initState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {}

  showLoadingDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false, //w user
        // must tap button!
        builder: (BuildContext context) {
          this.contextLoadingDialog = context;
          return new WillPopScope(
            onWillPop: () async => false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        ConstantColor.COLOR_APP_BASE),
                    strokeWidth: 6,
                  ),
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          );
        });
  }

  void closeLoadingDialog(BuildContext context) {
    Navigator.of(contextLoadingDialog, rootNavigator: true).pop();
  }

  void getSessionAuthToken() {
    _sessionManager.getJWTToken().then((data) {
      setState(() {
        BaseSingleton.shared.jwtToken = data;
      });
    });
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: ConstantColor.COLOR_BLACK,
        backgroundRadius: 16,
        textColor: ConstantColor.COLOR_WHITE);
  }

  Future<void> vibratePhone() async {
    Vibration.vibrate(
      pattern: [500, 1000],
    );
  }

  void getUserEmailId() {
    _sessionManager.getEmailId().then((data) {
      BaseSingleton.shared.userEmailId = data;
    });
  }

  void getSessionSubscribeID() {
    _sessionManager.getSubscriberID().then((data) {
      setState(() {
        BaseSingleton.shared.subscribeID = data;
      });
    });

    _sessionManager.getUserID().then((data) {
      setState(() {
        BaseSingleton.shared.userID = data;
      });
    });
  }

  void getLoginSession() {
    _sessionManager.getLoginSession().then((data) {
      setState(() {
        BaseSingleton.shared.loginSession = data;
      });
    });
  }

  void getFirstTimeOfAppSession() {
    _sessionManager.getAppFirstTimeSession().then((data) {
      setState(() {
        if (data == null) {
          BaseSingleton.shared.firstTimeOfApp = false;
        } else {
          BaseSingleton.shared.firstTimeOfApp = data;
        }
      });
    });
  }

  void getAppLangSession() {
    _sessionManager.getAppLang().then((data) {
      setState(() {
        if (data != null) {
          BaseSingleton.shared.appLocalLang = data;
          AppLocalizations.instance.load(new Locale(data));
          print("not null lang:" + data);
        } else {
          BaseSingleton.shared.appLocalLang = "de";
          AppLocalizations.instance.load(new Locale("de"));
          print("null lang:" + data);
        }
      });
    });
  }

  void setFirstTimeOfAppSession(bool status) {
    setState(() {
      BaseSingleton.shared.firstTimeOfApp = status;
      _sessionManager.setAppFirstTimeSession(status);
    });
  }

  void setAppLangSession(String appLang) {
    _sessionManager.setAppLang(appLang);
  }

  void getLocalSessionDatas() {
    getSessionAuthToken();
    getSessionSubscribeID();
    getLoginSession();
    getFirstTimeOfAppSession();
    getUserEmailId();
    //getAppLangSession();
  }

  void updateLoginSessionStatus() {
    _sessionManager.setLoginSession("1");
  }

  void twentySecondTimer() {
    Future.delayed(const Duration(milliseconds: 20000), () {
      setState(() {
        setFirstTimeOfAppSession(true);
      });
    });
  }

  void navigateBaseRouting(int event) {
    if (event == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AddProductScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProductListsScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CartListScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 4) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BillPreviewScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 5) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AddCustomerScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 6) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CustomerListsScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 7) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 8) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OverallReportListScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 9) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OverAllDetailedReportScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 10) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CustomerListsCrudScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 11) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProductCrudScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 12) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PendingBalanceListScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (event == 13) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BluetoothDemo()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void showErrorAlert(String message) {
    showMessageAlert(
        AppLocalizations.instance.text('key_something_wrong') + ': ' + message,
        AppLocalizations.instance.text('key_okay'),
        0);
  }

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void statusCodeValidation(String statusCode) {
    if (statusCode == HttpStatusString.STATUS_403) {
      _sessionManager.removeAllPreference();
      BaseSingleton.shared.clearAllBaseSingleton();
      showMessageAlert(AppLocalizations.instance.text('key_session_expire'),
          AppLocalizations.instance.text('key_okay'), 0);
      navigateBaseRouting(0);
    } else if (statusCode == HttpStatusString.STATUS_200) {
    } else if (statusCode == HttpStatusString.STATUS_204) {
    } else {
      showMessageAlert(
          AppLocalizations.instance.text('key_something_wrong') +
              ': ' +
              statusCode,
          AppLocalizations.instance.text('key_okay'),
          0);
    }
  }

  void navigationPushReplacementPassParams(StatefulWidget statefulWidget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
      (Route<dynamic> route) => false,
    );
  }

  String dateFormateConversion(String formattedString) {
    String formatted = "";
    try {
      if (formattedString != null) {
        var d = DateTime.parse(formattedString);
        var formatter = new DateFormat.yMMMMEEEEd().add_jm();
        formatted = formatter.format(d);
      } else {
        return "";
      }
    } on Exception catch (exception) {
      return "";
    }
    return formatted;
  }

  showAlertDialog(String msg, String positive, String negative, int events,
      BaseAlertListener baseAlertListener) async {
    return showDialog(
        context: context,
        barrierDismissible: false, //w user must tap button!
        builder: (BuildContext context) {
          contextAlertDialog = context;
          return new WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
//              contentPadding: EdgeInsets.all(0.0),
//              backgroundColor: Colors.transparent,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        child: new Text(msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: ConstantCommon.BASE_FONT,
                                color: ConstantColor.COLOR_BLACK,
                                fontSize: ConstantSize.FONT_LARGE_X,
                                fontWeight: FontWeight.bold)),
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 40, top: 30),
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                            height: 50,
                            child: FloatingActionButton.extended(
                                backgroundColor: ConstantColor.COLOR_RED,
                                elevation: 5.0,
                                onPressed: () {
                                  dismissKeyboard();
                                  Navigator.pop(context);
                                },
                                label: Text(
                                  negative,
                                  style: TextStyle(
                                      fontSize: ConstantSize.BUTTON_TEXT_SIZE,
                                      color: ConstantColor.COLOR_CORE,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ConstantCommon.BASE_FONT),
                                ))),
                        new Container(
                            height: 50,
                            child: FloatingActionButton.extended(
                                backgroundColor: ConstantColor.COLOR_GREEN,
                                elevation: 5.0,
                                onPressed: () {
                                  dismissKeyboard();
                                  if (events == 0) {
                                    Navigator.pop(context);
                                    baseAlertListener.onTapAlertOkayListener();
                                  } else if (events == 1) {
                                    Navigator.pop(context);
                                    baseAlertListener
                                        .onTapAlertQuitAppListener();
                                  }
                                },
                                label: Text(
                                  positive,
                                  style: TextStyle(
                                      fontSize: ConstantSize.BUTTON_TEXT_SIZE,
                                      color: ConstantColor.COLOR_CORE,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ConstantCommon.BASE_FONT),
                                )))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void clearResetCalculations(ProductDetails productDetails) {
    setState(() {
      productDetails.totalCost = 0;
      productDetails.totalKiloGrams = 0;
      textEditingControllerKilograms.text = "";
    });
  }

  showProductCalculationAlertDialog(
      String msg,
      String positive,
      String negative,
      int events,
      ProductDetails productDetails,
      BaseAlertListener baseAlertListener) async {
    textEditingControllerKilograms.text =
        productDetails.totalKiloGrams.toString();
    return showDialog(
        context: context,
        barrierDismissible: false, //w user must tap button!
        builder: (BuildContext context) {
          contextAlertDialog = context;
          return new WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
//              contentPadding: EdgeInsets.all(0.0),
//              backgroundColor: Colors.transparent,
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 35,
                              child: InkWell(
                                child: Image.asset(
                                  "assets/images/close.png",
                                  width: 35,
                                  height: 35,
                                ),
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                    dismissKeyboard();
                                  });
                                },
                              ),
                              alignment: Alignment.topRight,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: new Row(
                                  children: [
                                    Switch(
                                      value: productDetails.purchaseBoxFlag,
                                      onChanged: (value) {
                                        setState(() {
                                          productDetails.purchaseBoxFlag =
                                              value;
                                          clearResetCalculations(
                                              productDetails);
                                        });
                                      },
                                      activeTrackColor: Colors.lightGreenAccent,
                                      activeColor: Colors.green,
                                    ),
                                    new Expanded(
                                      child: new Text(
                                        productDetails.purchaseBoxFlag
                                            ? AppLocalizations.instance
                                                .text('key_box')
                                            : AppLocalizations.instance
                                                .text('key_kilo'),
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_COOL_RED,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )),
                            Center(
                              child: new Container(
                                child: new Text(msg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        color: ConstantColor.COLOR_BLACK,
                                        fontSize: ConstantSize.FONT_LARGE_X,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    AppLocalizations.instance.text('key_stock'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    AppLocalizations.instance.text('key_cost'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "${productDetails.productStockKg} kg",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    productDetails.purchaseBoxFlag
                                        ? "₹ ${productDetails.boxCost}"
                                        : "₹ ${productDetails.productCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    productDetails.purchaseBoxFlag
                                        ? AppLocalizations.instance
                                            .text('key_box')
                                        : AppLocalizations.instance
                                            .text('key_enter_kilogram'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    AppLocalizations.instance.text('key_price'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                  width: 100,
                                  child: TextField(
                                    controller: textEditingControllerKilograms,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText:
                                            productDetails.purchaseBoxFlag
                                                ? AppLocalizations.instance
                                                    .text('key_box')
                                                : AppLocalizations.instance
                                                    .text('key_kilograms'),
                                        labelStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        hintStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.5),
                                            gapPadding: 5.0,
                                            borderRadius:
                                                BorderRadius.circular(1.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.3),
                                            gapPadding: 10.0),
                                        contentPadding: EdgeInsets.all(10.0)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ConstantColor.COLOR_BLACK,
                                      fontFamily:
                                          ConstantCommon.BASE_FONT_REGULAR,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          clearResetCalculations(
                                              productDetails);
                                        } else {
                                          if (productDetails.purchaseBoxFlag) {
                                            productDetails.totalCost =
                                                int.parse(value) *
                                                    productDetails.boxCost;
                                            productDetails.totalKiloGrams =
                                                int.parse(value);
                                          } else {
                                            productDetails.totalCost =
                                                int.parse(value) *
                                                    productDetails.productCost;
                                            productDetails.totalKiloGrams =
                                                int.parse(value);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    "₹ ${productDetails.totalCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Container(
                                    height: 50,
                                    child: FloatingActionButton.extended(
                                        backgroundColor:
                                            ConstantColor.COLOR_RED,
                                        elevation: 5.0,
                                        onPressed: () {
                                          dismissKeyboard();
                                          setState(() {
                                            clearResetCalculations(
                                                productDetails);
                                          });

                                          //Nagator.pop(context);
                                        },
                                        label: Text(
                                          negative,
                                          style: TextStyle(
                                              fontSize:
                                                  ConstantSize.BUTTON_TEXT_SIZE,
                                              color: ConstantColor.COLOR_CORE,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  ConstantCommon.BASE_FONT),
                                        ))),
                                new Container(
                                    height: 50,
                                    child: FloatingActionButton.extended(
                                        backgroundColor:
                                            ConstantColor.COLOR_GREEN,
                                        elevation: 5.0,
                                        onPressed: () {
                                          dismissKeyboard();
                                          if (events == 0) {
                                            Navigator.pop(context);
                                            baseAlertListener
                                                .onTapAlertOkayListener();
                                          } else if (events == 1) {
                                            setState(() {
                                              if (textEditingControllerKilograms
                                                      .text.isEmpty ||
                                                  textEditingControllerKilograms
                                                          .text ==
                                                      "0") {
                                                showToast(AppLocalizations
                                                    .instance
                                                    .text(
                                                        'key_enter_kilograms'));
                                              } else {
                                                textEditingControllerKilograms
                                                    .text = "";
                                                Navigator.pop(context);
                                                baseAlertListener
                                                    .onTapAlertProductCalculationListener(
                                                        productDetails);
                                              }
                                            });
                                          }
                                        },
                                        label: Text(
                                          positive,
                                          style: TextStyle(
                                              fontSize:
                                                  ConstantSize.BUTTON_TEXT_SIZE,
                                              color: ConstantColor.COLOR_CORE,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  ConstantCommon.BASE_FONT),
                                        )))
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ));
        });
  }

  void clearReceivedAmount(ModelBalanceReceived modelBalanceReceived) {
    setState(() {
      textEditingControllerReceivedAmount.text = "";
      modelBalanceReceived.receivedCost = 0;
      modelBalanceReceived.pendingCost = 0;
    });
  }

  void clearPendingAmount(ModelUpdatePending modelUpdatePending,
      ModelUpdatePending dummyModelBalanceReceived) {
    setState(() {
      textEditingControllerPendingAmount.text = "";
      modelUpdatePending.receivedCost = dummyModelBalanceReceived.receivedCost;
      modelUpdatePending.pendingCost = dummyModelBalanceReceived.pendingCost;
      modelUpdatePending.totalCost = dummyModelBalanceReceived.totalCost;
      modelUpdatePending.orderPendinghistoryPendingCost = 0;
      modelUpdatePending.orderPendinghistoryReceivedCost = 0;
    });
  }

  showProductReceivedAlertDialog(
      String msg,
      String positive,
      int events,
      ModelBalanceReceived modelBalanceReceived,
      BaseAlertListener baseAlertListener) async {
    textEditingControllerReceivedAmount.text =
        modelBalanceReceived.receivedCost.toString();
    return showDialog(
        context: context,
        barrierDismissible: false, //w user must tap button!
        builder: (BuildContext context) {
          contextAlertDialog = context;
          return new WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
//              contentPadding: EdgeInsets.all(0.0),
//              backgroundColor: Colors.transparent,
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                child: Image.asset(
                                  "assets/images/close.png",
                                  width: 35,
                                  height: 35,
                                ),
                                alignment: Alignment.topRight,
                              ),
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                  dismissKeyboard();
                                });
                              },
                            ),
                            Center(
                              child: new Container(
                                child: new Text(msg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        color: ConstantColor.COLOR_BLACK,
                                        fontSize: ConstantSize.FONT_LARGE_X,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "Total Cost",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "Pending",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "${modelBalanceReceived.totalCost} kg",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "₹ ${modelBalanceReceived.pendingCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "Amount",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "Received",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                  width: 100,
                                  child: TextField(
                                    controller:
                                        textEditingControllerReceivedAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Amount",
                                        labelStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        hintStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.5),
                                            gapPadding: 5.0,
                                            borderRadius:
                                                BorderRadius.circular(1.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.3),
                                            gapPadding: 10.0),
                                        contentPadding: EdgeInsets.all(10.0)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ConstantColor.COLOR_BLACK,
                                      fontFamily:
                                          ConstantCommon.BASE_FONT_REGULAR,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          clearReceivedAmount(
                                              modelBalanceReceived);
                                        } else {
                                          modelBalanceReceived.pendingCost =
                                              modelBalanceReceived.totalCost -
                                                  int.parse(value);
                                          modelBalanceReceived.receivedCost =
                                              int.parse(value);
                                          //
                                          // productDetails.totalKiloGrams =
                                          //     int.parse(value);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    "₹ ${modelBalanceReceived.receivedCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Container(
                                    height: 50,
                                    child: FloatingActionButton.extended(
                                        backgroundColor:
                                            ConstantColor.COLOR_GREEN,
                                        elevation: 5.0,
                                        onPressed: () {
                                          dismissKeyboard();
                                          if (events == 0) {
                                            Navigator.pop(context);
                                            baseAlertListener
                                                .onTapAlertOkayListener();
                                          } else if (events == 1) {
                                            setState(() {
                                              if (textEditingControllerReceivedAmount
                                                      .text.isEmpty ||
                                                  textEditingControllerReceivedAmount
                                                          .text ==
                                                      "0") {
                                                showToast(AppLocalizations
                                                    .instance
                                                    .text(
                                                        'key_enter_kilograms'));
                                              } else {
                                                textEditingControllerReceivedAmount
                                                    .text = "";
                                                Navigator.pop(context);
                                                baseAlertListener
                                                    .onTapAlertReceivedCalculationListener(
                                                        modelBalanceReceived);
                                              }
                                            });
                                          }
                                        },
                                        label: Text(
                                          positive,
                                          style: TextStyle(
                                              fontSize:
                                                  ConstantSize.BUTTON_TEXT_SIZE,
                                              color: ConstantColor.COLOR_CORE,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  ConstantCommon.BASE_FONT),
                                        )))
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ));
        });
  }

  showUpdatePendingBalanceAlertDialog(
      String msg,
      String positive,
      int events,
      ModelUpdatePending modelUpdatePending,
      ModelUpdatePending dummyModelUpdatePending,
      BaseAlertListener baseAlertListener) async {
    textEditingControllerPendingAmount.text =
        modelUpdatePending.orderPendinghistoryReceivedCost.toString();
    return showDialog(
        context: context,
        barrierDismissible: false, //w user must tap button!
        builder: (BuildContext context) {
          contextAlertDialog = context;
          return new WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
//              contentPadding: EdgeInsets.all(0.0),
//              backgroundColor: Colors.transparent,
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                child: Image.asset(
                                  "assets/images/close.png",
                                  width: 35,
                                  height: 35,
                                ),
                                alignment: Alignment.topRight,
                              ),
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                  dismissKeyboard();
                                });
                              },
                            ),
                            Center(
                              child: new Container(
                                child: new Text(msg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        color: ConstantColor.COLOR_BLACK,
                                        fontSize: ConstantSize.FONT_LARGE_X,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "Total Cost",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "Pending",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "₹ ${modelUpdatePending.totalCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "₹ ${modelUpdatePending.pendingCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    "Amount",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                                new Container(
                                  child: new Text(
                                    "Received",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily: ConstantCommon.BASE_FONT,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                  width: 100,
                                  child: TextField(
                                    controller:
                                        textEditingControllerPendingAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Amount",
                                        labelStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        hintStyle: TextStyle(
                                            color: ConstantColor.COLOR_BLACK),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.5),
                                            gapPadding: 5.0,
                                            borderRadius:
                                                BorderRadius.circular(1.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColor.COLOR_BLACK,
                                                width: 1.3),
                                            gapPadding: 10.0),
                                        contentPadding: EdgeInsets.all(10.0)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ConstantColor.COLOR_BLACK,
                                      fontFamily:
                                          ConstantCommon.BASE_FONT_REGULAR,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          clearPendingAmount(modelUpdatePending,
                                              dummyModelUpdatePending);
                                        } else {
                                          int pendingBalance =
                                              dummyModelUpdatePending
                                                  .pendingCost;
                                          int receivedBalance =
                                              dummyModelUpdatePending
                                                  .receivedCost;
                                          modelUpdatePending.pendingCost =
                                              pendingBalance - int.parse(value);
                                          modelUpdatePending.receivedCost =
                                              receivedBalance +
                                                  int.parse(value);
                                          modelUpdatePending
                                                  .orderPendinghistoryReceivedCost =
                                              int.parse(value);
                                          modelUpdatePending
                                                  .orderPendinghistoryPendingCost =
                                              pendingBalance - int.parse(value);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    "₹ ${modelUpdatePending.receivedCost}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ConstantColor.COLOR_BLACK,
                                        fontFamily:
                                            ConstantCommon.BASE_FONT_REGULAR,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  margin: EdgeInsets.only(top: 10, bottom: 30),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Container(
                                    height: 50,
                                    child: FloatingActionButton.extended(
                                        backgroundColor:
                                            ConstantColor.COLOR_GREEN,
                                        elevation: 5.0,
                                        onPressed: () {
                                          dismissKeyboard();
                                          if (events == 0) {
                                            Navigator.pop(context);
                                            baseAlertListener
                                                .onTapAlertOkayListener();
                                          } else if (events == 1) {
                                            setState(() {
                                              if (textEditingControllerPendingAmount
                                                      .text.isEmpty ||
                                                  textEditingControllerPendingAmount
                                                          .text ==
                                                      "0") {
                                                showToast(AppLocalizations
                                                    .instance
                                                    .text(
                                                        'key_enter_kilograms'));
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            });
                                          }
                                        },
                                        label: Text(
                                          positive,
                                          style: TextStyle(
                                              fontSize:
                                                  ConstantSize.BUTTON_TEXT_SIZE,
                                              color: ConstantColor.COLOR_CORE,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  ConstantCommon.BASE_FONT),
                                        )))
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ));
        });
  }

  showMessageAlert(String msg, String btnText, int events) async {
    return showDialog(
        context: context,
        barrierDismissible: false, //w user must tap button!
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
//              contentPadding: EdgeInsets.all(0.0),
//              backgroundColor: Colors.transparent,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        child: new Text(msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: ConstantCommon.BASE_FONT,
                                color: ConstantColor.COLOR_BLACK,
                                fontSize: ConstantSize.FONT_LARGE_X,
                                fontWeight: FontWeight.bold)),
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 40, top: 30),
                      ),
                    ),
                    new Container(
                        child: FloatingActionButton.extended(
                            backgroundColor: ConstantColor.COLOR_APP_BASE,
                            elevation: 5.0,
                            onPressed: () {
                              dismissKeyboard();
                              Navigator.pop(context);
                            },
                            label: Text(
                              btnText,
                              style: TextStyle(
                                  fontSize: ConstantSize.BUTTON_TEXT_SIZE,
                                  color: ConstantColor.COLOR_CORE,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: ConstantCommon.BASE_FONT),
                            )))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void resetAppClearLocalAndSessionData() {
    _sessionManager.removeAllPreference();
    BaseSingleton.shared.clearAllBaseSingleton();
    navigateBaseRouting(0);
  }

  Center centerContainerNoNetwork = new Center(
    child: new Container(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: new Container(
            child: Image.asset(
              "assets/images/no_network.png",
              width: 50,
              height: 50,
            ),
          ),
        ),
        new Center(
          child: new Container(
            padding: EdgeInsets.all(10),
            child: Text(AppLocalizations.instance.text('key_no_network_con'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ConstantColor.COLOR_APP_BASE,
                    fontFamily: ConstantCommon.BASE_FONT,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    )),
  );

  Future<bool> checkConnectivityResponse() async {
    return await DataConnectionChecker().hasConnection;
  }

  Container containerAppLogo = new Container(
    child: new Container(
      child: new Center(
        child: new Container(
          child: Image.asset(
            "assets/images/applogo.png",
            width: 200,
            height: 200,
          ),
        ),
      ),
    ),
  );

  dismissKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String cutNull(Object value) {
    return value == null ? "" : value.toString();
  }

  String returnTime(String date) {
    return DateFormat.jms().format(DateTime.parse(date ?? ''));
  }

  String returnDate(String date) {
    return DateFormat.yMMMEd().format(DateTime.parse(date ?? ''));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
