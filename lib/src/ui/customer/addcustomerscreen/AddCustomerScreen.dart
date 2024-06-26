import 'package:IGO/src/data/apis/customer/addcustomer/IAddCustomerListener.dart';
import 'package:IGO/src/data/apis/customer/addcustomer/PresenterAddCustomer.dart';
import 'package:IGO/src/data/apis/customer/updatecustomer/IUpdateCustomerListener.dart';
import 'package:IGO/src/data/apis/customer/updatecustomer/PresenterUpdateCustomer.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';
import 'package:IGO/src/ui/customer/customercrud/CustomerListsCrudScreen.dart';

import '../../../utils/localizations.dart';
import 'ModalAddCustomer.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:IGO/src/utils/SessionManager.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';

import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(AddCustomerScreen());

String emailId;

class AddCustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddCustomerScreenStateful(),
    );
  }
}

class AddCustomerScreenStateful extends StatefulWidget {
  AddCustomerScreenStateful(
      {Key key, this.title, @required this.customerDetails})
      : super(key: key);
  final String title;
  final CustomerDetails customerDetails;

  @override
  AddCustomerScreenState createState() => AddCustomerScreenState();
}

class AddCustomerScreenState
    extends BaseStateStatefulState<AddCustomerScreenStateful>
    with WidgetsBindingObserver
    implements
        IAddCustomerListener,
        ViewContractConnectivityListener,
        IUpdateCustomerListener {
  AppConfig _appConfig;
  SessionManager _sessionManager;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalAddCustomer _modalAddCustomer;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  PresenterAddCustomer _presenterAddCustomer;
  PresenterUpdateCustomer _presenterUpdateCustomer;

  AddCustomerScreenState() {
    this._modalAddCustomer = new ModalAddCustomer();
    this._sessionManager = new SessionManager();
    this._presenterAddCustomer = new PresenterAddCustomer(this);
    this._connectivity = new Connectivitys(this);
    this._presenterUpdateCustomer = new PresenterUpdateCustomer(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalAddCustomer.isNetworkStatus = networkStatus;
  }

  void initNetworkConnectivity() {
    //_connectivity.checkConnectivity();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _sourceConnectionStatus = source);
      print("initnetw" + _sourceConnectionStatus.toString());
    });
  }

  void setEditDetails() {
    setState(() {
      _modalAddCustomer.controllerCustomerName.text =
          customerDetailsNavigate.customerName;
      _modalAddCustomer.controllerCustomerBillingName.text =
          customerDetailsNavigate.customerBillingName;
      _modalAddCustomer.controllerCustomerAddress.text =
          customerDetailsNavigate.customerAddress;
      _modalAddCustomer.controllerCustomerPhoneNumber.text =
          customerDetailsNavigate.customerMobileNo;
      _modalAddCustomer.controllerCustomerWhatsAppNumber.text =
          customerDetailsNavigate.customerWhatsappNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);

    Container containerCustomerName = new Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddCustomer.controllerCustomerName,
          keyboardType: TextInputType.text,
          focusNode: _modalAddCustomer.focusCustomerName,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_customer_name'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              hintStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_CUSTOMER, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddCustomer.focusCustomerName,
                _modalAddCustomer.focusCustomerBillingName);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerCustomerBillingName = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddCustomer.controllerCustomerBillingName,
          keyboardType: TextInputType.text,
          focusNode: _modalAddCustomer.focusCustomerBillingName,
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.instance.text('key_customer_bill_name'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              hintStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_CUSTOMER, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(
                context,
                _modalAddCustomer.focusCustomerBillingName,
                _modalAddCustomer.focusCustomerAddress);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerCustomerAddress = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddCustomer.controllerCustomerAddress,
          keyboardType: TextInputType.text,
          focusNode: _modalAddCustomer.focusCustomerAddress,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_customer_address'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              hintStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_CUSTOMER, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddCustomer.focusCustomerAddress,
                _modalAddCustomer.focusCustomerPhoneNumber);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerCustomerPhoneNumber = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          maxLength: 10,
          controller: _modalAddCustomer.controllerCustomerPhoneNumber,
          keyboardType: TextInputType.number,
          focusNode: _modalAddCustomer.focusCustomerPhoneNumber,
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.instance.text('key_customer_phone_no'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              hintStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_CUSTOMER, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(
                context,
                _modalAddCustomer.focusCustomerPhoneNumber,
                _modalAddCustomer.focusCustomerWhatsAppNumber);
          },
        ));
    Container containerCustomerWhatsAppNumber = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          maxLength: 10,
          controller: _modalAddCustomer.controllerCustomerWhatsAppNumber,
          keyboardType: TextInputType.number,
          focusNode: _modalAddCustomer.focusCustomerWhatsAppNumber,
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.instance.text('key_customer_whatsapp_no'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              hintStyle: TextStyle(color: ConstantColor.COLOR_CUSTOMER),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_CUSTOMER, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            _modalAddCustomer.focusCustomerWhatsAppNumber.unfocus();
          },
        ));

    Container containerSaveProductButton = new Container(
      margin: EdgeInsets.only(top: _appConfig.rHP(5)),
      child: new SizedBox(
        width: _appConfig.rW(75),
        height: 50,
        child: new RaisedButton(
          padding: const EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: ConstantColor.COLOR_CUSTOMER,
          onPressed: () {
            if (customerDetailsNavigate.customerId == null) {
              apiCallBacks(1);
            } else {
              apiCallBacks(3);
            }
          },
          child: new Text(AppLocalizations.instance.text('key_add_customer'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ConstantColor.COLOR_WHITE,
                fontWeight: FontWeight.bold,
                fontFamily: ConstantCommon.BASE_FONT,
              )),
        ),
      ),
    );

    Container containerCircularLoader = new Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        value: _modalAddCustomer.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_CUSTOMER),
        strokeWidth: 6,
      )),
    );

    Container containerAppBar = Container(
      child: new Container(
          child: new Row(
        children: [
          new Expanded(
            child: new Container(
              width: _appConfig.rW(20),
              child: InkWell(
                child: Container(
                  child: Image.asset(
                    "assets/images/back.png",
                    width: 35,
                    height: 35,
                  ),
                ),
                onTap: () {
                  setState(() {
                    navigateBaseRouting(10);
                  });
                },
              ),
              alignment: Alignment.topLeft,
            ),
            flex: 0,
          ),
          new Expanded(
            child: Container(
              child: Text(AppLocalizations.instance.text('key_customer_add'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_WHITE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
              margin: EdgeInsets.only(right: _appConfig.rWP(14)),
            ),
          ),
        ],
      )),
    );

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantColor.COLOR_CUSTOMER,
          automaticallyImplyLeading: false,
          title: containerAppBar,
          centerTitle: false,
          bottomOpacity: 1,
        ),
        body: !_modalAddCustomer.isNetworkStatus
            ? SingleChildScrollView(
                child: AbsorbPointer(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        containerCustomerName,
                        containerCustomerBillingName,
                        containerCustomerAddress,
                        containerCustomerPhoneNumber,
                        containerCustomerWhatsAppNumber,
                        containerSaveProductButton,
                        containerCircularLoader,
                      ],
                    ),
                  ),
                  absorbing: _modalAddCustomer.loadingEnableDisable,
                ),
              )
            : centerContainerNoNetwork,
        backgroundColor: ConstantColor.COLOR_WHITE,
      ),
      onWillPop: () {
        setState(() {
          navigateBaseRouting(10);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        initNetworkConnectivity();
        setEditDetails();
      });
    }
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  void errorValidationMgs(String _msg) {
    setState(() {
      _modalAddCustomer.email = _msg;
      showMessageAlert(_msg, AppLocalizations.instance.text('key_okay'), 0);
    });
  }

  void showDialog() {
    setState(() {
      _modalAddCustomer.loadingEnableDisable = true;
      _modalAddCustomer.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalAddCustomer.loadingEnableDisable = false;
      _modalAddCustomer.loadingCircularBar = 0.0;
    });
  }

  @override
  void onConnectivityResponse(bool status) {
    if (status) {
      updateInternetConnectivity(false);
      print("Connected");
      _modalAddCustomer.invisibleOffline = false;
      _modalAddCustomer.visibleOnline = true;
    } else {
      updateInternetConnectivity(true);
      //checkInternetAlert();
      print("disconnected");
      _modalAddCustomer.invisibleOffline = true;
      _modalAddCustomer.visibleOnline = false;
    }
  }

  void apiCallBacks(int event) {
    if (event == 1) {
      setState(() {
        _presenterAddCustomer.validateAddCustomerData();
      });
    } else if (event == 2) {
      setState(() {
        showDialog();
        postCustomerDatas();
      });
    } else if (event == 3) {
      setState(() {
        _presenterUpdateCustomer.validateUpdateCustomerData();
      });
    } else if (event == 4) {
      setState(() {
        showDialog();
        updateCustomerDatas();
      });
    }
  }

  void postCustomerDatas() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterAddCustomer.hitPostCustomerDataCall();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  void updateCustomerDatas() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterUpdateCustomer.hitUpdateCustomerDataCall();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  @override
  String getCustomerAddress() {
    return _modalAddCustomer.controllerCustomerAddress.text.trim().toString();
  }

  @override
  String getCustomerBillingName() {
    return _modalAddCustomer.controllerCustomerBillingName.text
        .trim()
        .toString();
  }

  @override
  String getCustomerName() {
    return _modalAddCustomer.controllerCustomerName.text.trim().toString();
  }

  @override
  String getCustomerPhoneNumber() {
    return _modalAddCustomer.controllerCustomerPhoneNumber.text
        .trim()
        .toString();
  }

  @override
  String getCustomerWhatsAppNumberNumber() {
    return _modalAddCustomer.controllerCustomerWhatsAppNumber.text
        .trim()
        .toString();
  }

  @override
  void hitPostAddCustomerData() {
    setState(() {
      apiCallBacks(2);
    });
  }

  @override
  void onFailureMessageAddProduct(String error) {
    setState(() {
      showErrorAlert(error);
      dismissLoadingDialog();
    });
  }

  @override
  void onSuccessResponseAddProduct(String msg) {
    setState(() {
      showToast(msg);
      clearAllEditTextDatas();
      dismissLoadingDialog();
      navigateBaseRouting(10);
    });
  }

  @override
  Map parseAddCustomerData() {
    return {
      "customer_name": getCustomerName().trim(),
      "customer_billing_name": getCustomerBillingName().trim(),
      "customer_address": getCustomerAddress().trim(),
      "customer_mobile_no": getCustomerPhoneNumber().trim(),
      "customer_whatsapp_no": getCustomerWhatsAppNumberNumber().trim(),
    };
  }

  @override
  void clearAllEditTextDatas() {
    _modalAddCustomer.controllerCustomerName.text = "";
    _modalAddCustomer.controllerCustomerBillingName.text = "";
    _modalAddCustomer.controllerCustomerAddress.text = "";
    _modalAddCustomer.controllerCustomerPhoneNumber.text = "";
    _modalAddCustomer.controllerCustomerWhatsAppNumber.text = "";
  }

  @override
  String getCustomerMobileNo() {
    return _modalAddCustomer.controllerCustomerPhoneNumber.text;
  }

  @override
  String getCustomerStatus() {
    return "true";
  }

  @override
  String getCustomerWhatsAppNo() {
    return _modalAddCustomer.controllerCustomerWhatsAppNumber.text;
  }

  @override
  String getCustonerId() {
    return customerDetailsNavigate.customerId;
  }

  @override
  void onFailureMessageUpdateCustomer(String error) {
    setState(() {
      dismissLoadingDialog();
      showErrorAlert(error);
    });
  }

  @override
  void onSuccessResponseUpdateCustomer(
      UpdateCustomerResponseModel updateCustomerResponseModel) {
    setState(() {
      showToast(updateCustomerResponseModel.message);
      clearAllEditTextDatas();
      dismissLoadingDialog();
      navigateBaseRouting(10);
    });
  }

  @override
  Map parseUpdateCustomerData() {
    return {
      "customer_name": getCustomerNameUpdate(),
      "customer_id": getCustonerId(),
      "customer_billing_name": getCustomerBillingNameUpdate(),
      "customer_address": getCustomerAddressUpdate(),
      "customer_mobile_no": getCustomerMobileNo(),
      "customer_whatsapp_no": getCustomerWhatsAppNo(),
      "customer_status": getCustomerStatus()
    };
  }

  @override
  void postUpdateCustomerData() {
    setState(() {
      apiCallBacks(4);
    });
  }

  @override
  String getCustomerAddressUpdate() {
    return _modalAddCustomer.controllerCustomerAddress.text;
  }

  @override
  String getCustomerBillingNameUpdate() {
    return _modalAddCustomer.controllerCustomerBillingName.text;
  }

  @override
  String getCustomerNameUpdate() {
    return _modalAddCustomer.controllerCustomerName.text;
  }
}
