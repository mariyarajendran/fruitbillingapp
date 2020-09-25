import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/data/apis/product/addproduct/IAddProductListener.dart';
import 'package:IGO/src/data/apis/product/addproduct/PresenterAddProduct.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:IGO/src/utils/SessionManager.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ModalAddProduct.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';

void main() => runApp(AddProductScreen());

String emailId;

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddProductScreenStateful(),
    );
  }
}

class AddProductScreenStateful extends StatefulWidget {
  AddProductScreenStateful({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState
    extends BaseStateStatefulState<AddProductScreenStateful>
    with WidgetsBindingObserver
    implements IAddProductListener, ViewContractConnectivityListener {
  AppConfig _appConfig;
  SessionManager _sessionManager;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalAddProduct _modalAddProduct;
  PresenterAddProduct _presenterAddProduct;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};

  AddProductScreenState() {
    this._modalAddProduct = new ModalAddProduct();
    this._sessionManager = new SessionManager();
    this._presenterAddProduct = new PresenterAddProduct(this);
    this._connectivity = new Connectivitys(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalAddProduct.isNetworkStatus = networkStatus;
  }

  void initNetworkConnectivity() {
    //_connectivity.checkConnectivity();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _sourceConnectionStatus = source);
      print("initnetw" + _sourceConnectionStatus.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);

    Container containerProductName = new Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddProduct.controllerProductName,
          keyboardType: TextInputType.text,
          focusNode: _modalAddProduct.focusProductName,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_product_name'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              hintStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusProductName,
                _modalAddProduct.focusProductCost);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerProductCost = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddProduct.controllerProductCost,
          keyboardType: TextInputType.number,
          focusNode: _modalAddProduct.focusProductCost,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_product_cost'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              hintStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusProductCost,
                _modalAddProduct.focusProductCode);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerProductCode = new Container(
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
          controller: _modalAddProduct.controllerProductCode,
          keyboardType: TextInputType.text,
          focusNode: _modalAddProduct.focusProductCode,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_product_code'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              hintStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusProductCode,
                _modalAddProduct.focusProductKg);
          },
        ));

    Container containerProductKg = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.done,
          controller: _modalAddProduct.controllerProductKg,
          keyboardType: TextInputType.number,
          focusNode: _modalAddProduct.focusProductKg,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_product_kg'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              hintStyle: TextStyle(color: ConstantColor.COLOR_APP_BASE),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            _modalAddProduct.focusProductKg.unfocus();
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerSaveProductButton = new Container(
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
          child: new Text(AppLocalizations.instance.text('key_save_product'),
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
        value: _modalAddProduct.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_APP_BASE),
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
                    navigateBaseRouting(2);
                  });
                },
              ),
              alignment: Alignment.topLeft,
            ),
            flex: 0,
          ),
          new Expanded(
            flex: 4,
            child: Container(
              child: Text(AppLocalizations.instance.text('key_product_add'),
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
          backgroundColor: ConstantColor.COLOR_APP_BASE,
          automaticallyImplyLeading: false,
          title: containerAppBar,
          centerTitle: false,
          bottomOpacity: 1,
        ),
        body: !_modalAddProduct.isNetworkStatus
            ? SingleChildScrollView(
                child: AbsorbPointer(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        containerProductName,
                        containerProductCost,
                        containerProductCode,
                        containerProductKg,
                        containerSaveProductButton,
                        containerCircularLoader,
                      ],
                    ),
                  ),
                  absorbing: _modalAddProduct.loadingEnableDisable,
                ),
              )
            : centerContainerNoNetwork,
        backgroundColor: ConstantColor.COLOR_BACKGROUND,
      ),
      onWillPop: () {},
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
      _modalAddProduct.email = _msg;
      showMessageAlert(_msg, AppLocalizations.instance.text('key_okay'), 0);
    });
  }

  void showDialog() {
    setState(() {
      _modalAddProduct.loadingEnableDisable = true;
      _modalAddProduct.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalAddProduct.loadingEnableDisable = false;
      _modalAddProduct.loadingCircularBar = 0.0;
    });
  }

  @override
  void onConnectivityResponse(bool status) {
    if (status) {
      updateInternetConnectivity(false);
      print("Connected");
      _modalAddProduct.invisibleOffline = false;
      _modalAddProduct.visibleOnline = true;
    } else {
      updateInternetConnectivity(true);
      //checkInternetAlert();
      print("disconnected");
      _modalAddProduct.invisibleOffline = true;
      _modalAddProduct.visibleOnline = false;
    }
  }

  void apiCallBacks(int event) {
    if (event == 1) {
      setState(() {
        _presenterAddProduct.validateAddProductData();
      });
    } else if (event == 2) {
      setState(() {
        showDialog();
        postProductDatas();
      });
    }
  }

  @override
  String getProductCode() {
    return _modalAddProduct.controllerProductCode.text.trim().toString();
  }

  @override
  String getProductKg() {
    return _modalAddProduct.controllerProductKg.text.trim().toString();
  }

  @override
  String getProductName() {
    return _modalAddProduct.controllerProductName.text.trim().toString();
  }

  @override
  String getProductPrice() {
    return _modalAddProduct.controllerProductCost.text.trim().toString();
  }

  @override
  void postAddProductData() {
    setState(() {
      apiCallBacks(2);
    });
  }

  void postProductDatas() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterAddProduct.hitPostProductDataCall();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
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
    });
  }

  @override
  Map parseAddProductData() {
    return {
      "product_name": getProductName().trim(),
      "product_cost": getProductPrice().trim(),
      "product_stock_kg": getProductKg().trim(),
      "product_code": getProductCode().trim(),
    };
  }

  @override
  void clearAllEditTextDatas() {
    setState(() {
      _modalAddProduct.controllerProductName.text = "";
      _modalAddProduct.controllerProductCode.text = "";
      _modalAddProduct.controllerProductCost.text = "";
      _modalAddProduct.controllerProductKg.text = "";
    });
  }
}
