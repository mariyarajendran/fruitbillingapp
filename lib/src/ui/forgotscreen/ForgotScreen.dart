import 'package:IGO/src/allcalls/resetpassword/IResetPasswordListener.dart';
import 'package:IGO/src/allcalls/resetpassword/PresenterResetPassword.dart';
import 'package:IGO/src/constants/ConstantCommon.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/models/responsemodel/resetpasswordresponsemodel/ResetResponseModel.dart';
import 'package:IGO/src/models/responsemodel/signupresponsemodel/SignUpResponseModel.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:IGO/src/utils/SessionManager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../utils/AppConfig.dart';
import './../../constants/ConstantColor.dart';
import './../../ui/base/BaseState.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'ModalForgotPassword.dart';

void main() => runApp(ForgotScreen());

String emailId;

class ForgotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ForgotScreenStateful(),
    );
  }
}

class ForgotScreenStateful extends StatefulWidget {
  ForgotScreenStateful({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ForgotScreenState createState() => ForgotScreenState();
}

class ForgotScreenState extends BaseStateStatefulState<ForgotScreenStateful>
    with WidgetsBindingObserver
    implements IResetPasswordListener, ViewContractConnectivityListener {
  AppConfig _appConfig;
  SessionManager _sessionManager;
  Connectivitys _connectivity = Connectivitys.instance;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  ModalForgotPassword _modalForgotPassword;
  PresenterResetPassword _presenterResetPassword;

  ForgotScreenState() {
    this._sessionManager = new SessionManager();
    this._connectivity = new Connectivitys(this);
    this._modalForgotPassword = new ModalForgotPassword();
    this._presenterResetPassword = new PresenterResetPassword(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalForgotPassword.isNetworkStatus = networkStatus;
  }

  void initNetworkConnectivity() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _sourceConnectionStatus = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);

    Container containerLogo = new Container(
        margin: EdgeInsets.only(top: _appConfig.rHP(10)),
        child: new Column(
          children: <Widget>[containerAppLogo],
        ));

    Container containerEmailId = new Container(
      margin: EdgeInsets.only(top: _appConfig.rHP(2)),
      width: _appConfig.rW(75),
      child: TextField(
        controller: _modalForgotPassword.controllerEmailID,
        keyboardType: TextInputType.text,
//        validator: validateEmail,
        decoration: InputDecoration(
          labelText:
              // getTranslated(context, 'key_login_email_address'),
              AppLocalizations.instance.text('key_login_email_address'),
          labelStyle: TextStyle(color: ConstantColor.COLOR_GREY_HINT),
          hintStyle: TextStyle(color: ConstantColor.COLOR_GREY_HINT),
        ),
        style: TextStyle(
          fontSize: 16,
          color: ConstantColor.COLOR_BLACK,
          fontFamily: ConstantCommon.BASE_FONT_REGULAR,
        ),
      ),
    );

    Container containerNewPassword = new Container(
      margin: EdgeInsets.only(top: _appConfig.rHP(2)),
      width: _appConfig.rW(75),
      child: TextField(
        controller: _modalForgotPassword.controllerNewPassword,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
//        validator: validateEmail,
        decoration: InputDecoration(
          labelText:
              // getTranslated(context, 'key_login_email_address'),
              AppLocalizations.instance.text('key_new_password'),
          labelStyle: TextStyle(color: ConstantColor.COLOR_GREY_HINT),
          hintStyle: TextStyle(color: ConstantColor.COLOR_GREY_HINT),
        ),
        style: TextStyle(
          fontSize: 16,
          color: ConstantColor.COLOR_BLACK,
          fontFamily: ConstantCommon.BASE_FONT_REGULAR,
        ),
      ),
    );

    Container containerChangePasswordButton = new Container(
      margin: EdgeInsets.only(top: _appConfig.rHP(5)),
      child: new SizedBox(
        width: _appConfig.rW(75),
        height: 50,
        child: new RaisedButton(
          padding: const EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: ConstantColor.COLOR_APP_BASE,
          onPressed: () {
            apiCallBacks(1);
          },
          child: new Text(
              //getTranslated(context, 'key_login_buttton'),
              AppLocalizations.instance.text('key_change_password'),
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
        value: _modalForgotPassword.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_APP_BASE),
        strokeWidth: 6,
      )),
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: ConstantColor.COLOR_BACKGROUND,
        appBar: AppBar(
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new InkWell(
                  child: new Container(
                      padding: EdgeInsets.only(right: _appConfig.rWP(4)),
                      child: Image.asset(
                        "assets/images/back_arrow.png",
                        width: 40,
                        height: 30,
                      )),
                  onTap: () {
                    setState(() {
                      navigateBaseRouting(0);
                    });
                  }),
              new Container(
                child: Text(
                  //ConstantString.SIGN_UP_TITLE,
                  AppLocalizations.instance.text('key_forgot_password'),
                  //getTranslated(context, 'key_login_welcome'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: ConstantCommon.BASE_FONT,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: ConstantColor.COLOR_APP_BASE,
          centerTitle: true,
        ),
        body: !_modalForgotPassword.isNetworkStatus
            ? SingleChildScrollView(
                child: AbsorbPointer(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        containerLogo,
                        containerEmailId,
                        containerNewPassword,
                        containerChangePasswordButton,
                        containerCircularLoader,
                      ],
                    ),
                  ),
                  absorbing: _modalForgotPassword.loadingEnableDisable,
                ),
              )
            : centerContainerNoNetwork,
      ),
      onWillPop: () {
        setState(() {
          navigateBaseRouting(0);
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
      _modalForgotPassword.email = _msg;
      showMessageAlert(_msg, AppLocalizations.instance.text('key_okay'), 0);
    });
  }

  @override
  String getEmailId() {
    return _modalForgotPassword.controllerEmailID.text.trim();
  }

  void showDialog() {
    setState(() {
      _modalForgotPassword.loadingEnableDisable = true;
      _modalForgotPassword.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalForgotPassword.loadingEnableDisable = false;
      _modalForgotPassword.loadingCircularBar = 0.0;
    });
  }

  @override
  void onConnectivityResponse(bool status) {
    if (status) {
      updateInternetConnectivity(false);
      _modalForgotPassword.invisibleOffline = false;
      _modalForgotPassword.visibleOnline = true;
    } else {
      updateInternetConnectivity(true);
      _modalForgotPassword.invisibleOffline = true;
      _modalForgotPassword.visibleOnline = false;
    }
  }

  void apiCallBacks(int event) {
    if (event == 1) {
      setState(() {
        _presenterResetPassword.validateResetDataDatas();
      });
    }
  }

  @override
  void onFailureResponseResetPassword(String statusCode) {
    setState(() {
      dismissLoadingDialog();
      showErrorAlert(statusCode);
    });
  }

  @override
  void onSuccessResponseResetPassword(ResetResponseModel resetResponseModel) {
    setState(() {
      dismissLoadingDialog();
      showToast(AppLocalizations.instance.text('key_password_reset'));
      navigateBaseRouting(0);
    });
  }

  @override
  Map parseResetMapData() {
    Map mapResetData;
    return mapResetData = {
      "EmailId": getEmailId().trim(),
      "NewPassword": getNewPassword().trim(),
    };
  }

  @override
  String getNewPassword() {
    return _modalForgotPassword.controllerNewPassword.text.trim();
  }

  @override
  void postResetPassword() {
    setState(() {
      showDialog();
      checkConnectivityResponse().then((data) {
        if (data) {
          setState(() {
            updateInternetConnectivity(false);
            _presenterResetPassword.resetPassword();
          });
        } else {
          setState(() {
            updateInternetConnectivity(true);
          });
        }
      });
    });
  }
}
