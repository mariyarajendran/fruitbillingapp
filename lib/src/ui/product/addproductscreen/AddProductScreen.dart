import 'package:IGO/src/data/apis/product/addproduct/IAddProductListener.dart';
import 'package:IGO/src/data/apis/product/addproduct/PresenterAddProduct.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IUpdateProductListener.dart';
import 'package:IGO/src/data/apis/product/updateproduct/PresenterUpdateProduct.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';
import 'package:IGO/src/ui/product/productcrud/ProductCrudScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:IGO/src/utils/SessionManager.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/localizations.dart';
import 'ModalAddProduct.dart';
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
  AddProductScreenStateful({Key key, this.title, @required this.productDetails})
      : super(key: key);
  final String title;
  final ProductDetails productDetails;

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState
    extends BaseStateStatefulState<AddProductScreenStateful>
    with WidgetsBindingObserver
    implements
        IAddProductListener,
        ViewContractConnectivityListener,
        IUpdateProductListener {
  AppConfig _appConfig;
  SessionManager _sessionManager;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalAddProduct _modalAddProduct;
  PresenterUpdateProduct _presenterUpdateProduct;
  PresenterAddProduct _presenterAddProduct;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};

  AddProductScreenState() {
    this._modalAddProduct = new ModalAddProduct();
    this._sessionManager = new SessionManager();
    this._presenterAddProduct = new PresenterAddProduct(this);
    this._presenterUpdateProduct = PresenterUpdateProduct(this);
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

  void setEditDetails() {
    setState(() {
      if (productDetailsNavigate.productPreviousBalanceFlag == null) {
        productDetailsNavigate.productPreviousBalanceFlag = false;
      }
      if (productDetailsNavigate.productPreviousBalanceFlag) {
        _modalAddProduct.switchEnabledPreviousBalance =
            productDetailsNavigate.productPreviousBalanceFlag;
        _modalAddProduct.controllerPreviousBalanceHint.text =
            productDetailsNavigate.productName;

        if (productDetailsNavigate.productCost != null) {
          _modalAddProduct.controllerPreviousBalance.text =
              cutNull(productDetailsNavigate.productCost.toString());
        }
      } else {
        _modalAddProduct.controllerProductName.text =
            productDetailsNavigate.productName;
        if (productDetailsNavigate.productCost != null) {
          _modalAddProduct.controllerProductCost.text =
              cutNull(productDetailsNavigate.productCost.toString());
        }
        if (productDetailsNavigate.boxCost != null) {
          _modalAddProduct.controllerBoxCost.text =
              cutNull(productDetailsNavigate.boxCost.toString());
        }
        _modalAddProduct.controllerProductCode.text =
            productDetailsNavigate.productCode;
        if (productDetailsNavigate.productStockKg != null) {
          _modalAddProduct.controllerProductKg.text =
              cutNull(productDetailsNavigate.productStockKg.toString());
        }
      }
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
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusProductName,
                _modalAddProduct.focusProductCost);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerPreviousBalanceDescription = new Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddProduct.controllerPreviousBalanceHint,
          keyboardType: TextInputType.text,
          focusNode: _modalAddProduct.focusPreviousBalanceHint,
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.instance.text('previous_balance_hint'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusPreviousBalanceHint,
                _modalAddProduct.focusPreviousBalance);
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
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusProductCost,
                _modalAddProduct.focusBoxCost);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerBoxCost = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          controller: _modalAddProduct.controllerBoxCost,
          keyboardType: TextInputType.number,
          focusNode: _modalAddProduct.focusBoxCost,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('key_box_cost'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            fieldFocusChange(context, _modalAddProduct.focusBoxCost,
                _modalAddProduct.focusProductCode);
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerPreviousBalance = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new TextFormField(
          style: TextStyle(
              color: ConstantColor.COLOR_DARK_GRAY,
              fontSize: 16,
              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.done,
          controller: _modalAddProduct.controllerPreviousBalance,
          keyboardType: TextInputType.number,
          focusNode: _modalAddProduct.focusPreviousBalance,
          decoration: InputDecoration(
              labelText: AppLocalizations.instance.text('previous_balance'),
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            _modalAddProduct.focusPreviousBalance.unfocus();
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
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
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
              labelStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              hintStyle: TextStyle(color: ConstantColor.COLOR_PRODUCTS),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                  gapPadding: 10.0,
                  borderRadius: BorderRadius.circular(1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(
                      color: ConstantColor.COLOR_PRODUCTS, width: 1.3),
                  gapPadding: 10.0),
              contentPadding: EdgeInsets.all(20.0)),
          onFieldSubmitted: (v) {
            _modalAddProduct.focusProductKg.unfocus();
          },
          textCapitalization: TextCapitalization.sentences,
        ));

    Container containerSwitchToPreviousBalanceEntry = new Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
        child: new Row(
          children: [
            Switch(
              value: _modalAddProduct.switchEnabledPreviousBalance,
              onChanged: (value) {
                setState(() {
                  clearAllEditTextDatas();
                  _modalAddProduct.switchEnabledPreviousBalance = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            new Expanded(
              child: new Text(
                AppLocalizations.instance
                    .text('key_add_previous_balance_switch'),
                style: TextStyle(
                    color: ConstantColor.COLOR_COOL_RED,
                    fontFamily: ConstantCommon.BASE_FONT,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));

    Container containerSaveProductButton = new Container(
      margin: EdgeInsets.only(top: _appConfig.rHP(5)),
      child: new SizedBox(
        width: _appConfig.rW(75),
        height: 50,
        child: new RaisedButton(
          padding: const EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: ConstantColor.COLOR_PRODUCTS,
          onPressed: () {
            setState(() {
              if (productDetailsNavigate.productId == null) {
                apiCallBacks(1);
              } else {
                apiCallBacks(3);
              }
            });
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
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_PRODUCTS),
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
                    navigateBaseRouting(11);
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
              child: Text(
                  _modalAddProduct.switchEnabledPreviousBalance
                      ? AppLocalizations.instance.text('previous_balance')
                      : AppLocalizations.instance.text('key_product_add'),
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
          backgroundColor: ConstantColor.COLOR_PRODUCTS,
          automaticallyImplyLeading: false,
          title: containerAppBar,
          centerTitle: false,
          bottomOpacity: 1,
        ),
        backgroundColor: ConstantColor.COLOR_WHITE,
        body: !_modalAddProduct.isNetworkStatus
            ? SingleChildScrollView(
                child: AbsorbPointer(
                  child: Center(
                      child: _modalAddProduct.switchEnabledPreviousBalance
                          ? Column(
                              children: <Widget>[
                                containerPreviousBalanceDescription,
                                containerPreviousBalance,
                                containerSwitchToPreviousBalanceEntry,
                                containerSaveProductButton,
                                containerCircularLoader
                              ],
                            )
                          : new Column(
                              children: [
                                containerProductName,
                                containerProductCost,
                                containerBoxCost,
                                containerProductCode,
                                containerProductKg,
                                containerSwitchToPreviousBalanceEntry,
                                containerSaveProductButton,
                                containerCircularLoader
                              ],
                            )),
                  absorbing: _modalAddProduct.loadingEnableDisable,
                ),
              )
            : centerContainerNoNetwork,
      ),
      onWillPop: () {
        setState(() {
          navigateBaseRouting(11);
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
        _presenterAddProduct.validateAddProductData(
            _modalAddProduct.switchEnabledPreviousBalance);
      });
    } else if (event == 2) {
      setState(() {
        showDialog();
        postProductDatas();
      });
    } else if (event == 3) {
      setState(() {
        _presenterUpdateProduct.validateUpdateProductData(
            _modalAddProduct.switchEnabledPreviousBalance);
      });
    } else if (event == 4) {
      setState(() {
        showDialog();
        updateProductDatas();
      });
    }
  }

  void updateProductDatas() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterUpdateProduct.hitUpdateProductDataCall();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
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
    return _modalAddProduct.switchEnabledPreviousBalance
        ? _modalAddProduct.controllerPreviousBalanceHint.text.toString()
        : _modalAddProduct.controllerProductName.text.trim().toString();
  }

  @override
  String getProductPrice() {
    return _modalAddProduct.switchEnabledPreviousBalance
        ? _modalAddProduct.controllerPreviousBalance.text.toString()
        : _modalAddProduct.controllerProductCost.text.trim().toString();
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
      navigateBaseRouting(11);
    });
  }

  @override
  Map parseAddProductData() {
    return {
      "product_name": getProductName().trim(),
      "product_cost": getProductPrice().trim(),
      "box_cost": getBoxPrice().trim(),
      "product_stock_kg": getProductKg().trim(),
      "product_code": getProductCode().trim(),
      "product_previous_balance_flag": getProductPreviousBalanceFlag(),
    };
  }

  @override
  void clearAllEditTextDatas() {
    setState(() {
      _modalAddProduct.controllerProductName.text = "";
      _modalAddProduct.controllerProductCode.text = "";
      _modalAddProduct.controllerBoxCost.text = "";
      _modalAddProduct.controllerProductCost.text = "";
      _modalAddProduct.controllerProductKg.text = "";
      _modalAddProduct.controllerPreviousBalance.text = "";
      _modalAddProduct.controllerPreviousBalanceHint.text = "";
    });
  }

  @override
  String getProductCodeUpdate() {
    return _modalAddProduct.controllerProductCode.text;
  }

  @override
  String getProductCostUpdate() {
    return _modalAddProduct.switchEnabledPreviousBalance
        ? _modalAddProduct.controllerPreviousBalance.text.toString()
        : _modalAddProduct.controllerProductCost.text.trim().toString();
  }

  @override
  String getProductIdUpdate() {
    return productDetailsNavigate.productId;
  }

  @override
  String getProductNameUpdate() {
    return _modalAddProduct.switchEnabledPreviousBalance
        ? _modalAddProduct.controllerPreviousBalanceHint.text.toString()
        : _modalAddProduct.controllerProductName.text.trim().toString();
  }

  @override
  String getProductStatusUpdate() {
    return "true";
  }

  @override
  String getProductStockKgUpdate() {
    return _modalAddProduct.controllerProductKg.text;
  }

  @override
  void onFailureMessageUpdateProduct(String error) {
    setState(() {
      dismissLoadingDialog();
      showErrorAlert(error);
    });
  }

  @override
  void onSuccessResponseUpdateProduct(
      UpdateProductResponseModel updateProductResponseModel) {
    setState(() {
      dismissLoadingDialog();
      showToast(updateProductResponseModel.message);
      navigateBaseRouting(11);
    });
  }

  @override
  Map parseUpdateProductData() {
    return {
      "product_id": getProductIdUpdate(),
      "product_name": getProductNameUpdate(),
      "product_cost": getProductCostUpdate(),
      "box_cost": getBoxCostUpdate(),
      "product_stock_kg": getProductStockKgUpdate(),
      "product_code": getProductCodeUpdate(),
      "product_status": getProductStatusUpdate(),
      "product_previous_balance_flag": getProductPreviousBalanceFlag(),
    };
  }

  @override
  void postUpdateProductData() {
    setState(() {
      apiCallBacks(4);
    });
  }

  @override
  String getProductPreviousBalanceFlag() {
    return _modalAddProduct.switchEnabledPreviousBalance ? "true" : "false";
  }

  @override
  String getBoxPrice() {
    return _modalAddProduct.controllerBoxCost.text.toString();
  }

  @override
  String getBoxCostUpdate() {
    return _modalAddProduct.controllerBoxCost.text.toString();
  }
}
