import 'package:IGO/src/data/apis/product/productlist/IProductListListener.dart';
import 'package:IGO/src/data/apis/product/productlist/PresenterProductList.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IUpdateProductListener.dart';
import 'package:IGO/src/data/apis/product/updateproduct/PresenterUpdateProduct.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/product/addproductscreen/AddProductScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModaProductCrud.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ProductCrudScreen());
ProductDetails productDetailsNavigate = new ProductDetails();

class ProductCrudScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductCrudScreenStateful(),
    );
  }
}

class ProductCrudScreenStateful extends StatefulWidget {
  ProductCrudScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ProductCrudScreenState createState() => ProductCrudScreenState();
}

class ProductCrudScreenState
    extends BaseStateStatefulState<ProductCrudScreenStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        IProductListListener,
        BaseAlertListener,
        IUpdateProductListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModaProductCrud _modaProductCrud;
  PresenterProductList _presenterProductList;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  List<ProductDetails> callLogImportInfo = [];
  List<ProductDetails> duplicateCallLogImportInfo = [];
  PresenterUpdateProduct _presenterUpdateProduct;

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  ProductCrudScreenState() {
    this._modaProductCrud = new ModaProductCrud();
    this._connectivity = new Connectivitys(this);
    this._presenterProductList = new PresenterProductList(this);
    this._presenterUpdateProduct = new PresenterUpdateProduct(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modaProductCrud.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modaProductCrud.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modaProductCrud.eventCircularLoader = status;
  }

  bool checkDuplicateBillInCart(ProductDetails productDetails) {
    int count = 0;
    bool duplicateStatus = true;
    setState(() {
      if (BaseSingleton.shared.billingProductList.isNotEmpty) {
        for (int i = 0;
            i < BaseSingleton.shared.billingProductList.length;
            i++) {
          if (BaseSingleton.shared.billingProductList[i].productId
              .contains(productDetails.productId)) {
            count += 1;
          }
        }
        if (count > 0) {
          duplicateStatus = false;
        } else {
          duplicateStatus = true;
        }
      }
    });
    return duplicateStatus;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    ExpansionPanelList expansionPanelList = new ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          callLogImportInfo[index].isExpanded = !isExpanded;
        });
      },
      children: callLogImportInfo.map<ExpansionPanel>((ProductDetails item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//                  Checkbox(
//                      value: item.isChecked,
//                      activeColor: ConstantColor.COLOR_APP_BASE,
//                      onChanged: (bool value) {
//                        setState(() {
//                          if (value) {
//                            item.isChecked = value;
//                          } else {
//                            item.isChecked = value;
//                          }
//                        });
//                      }),
                  Expanded(
                    flex: 3,
                    child: new Text(
                      item.productName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ConstantColor.COLOR_BLACK,
                          fontFamily: ConstantCommon.BASE_FONT_REGULAR,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FractionalTranslation(
                      translation: Offset(0.5, 0.0),
                      child: new Container(
                        alignment: new FractionalOffset(0.0, 0.0),
                        decoration: new BoxDecoration(
                          border: new Border.all(
                            color: item.productStockKg <= 0
                                ? ConstantColor.COLOR_BLOCKED
                                : ConstantColor.COLOR_UNBLOCKED,
                            width:
                                10.0, // it's my slider variable, to change the size of the circle
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          body: new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  onTap: () {},
                  title: new Stack(
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: new Text(
                                              AppLocalizations.instance
                                                  .text('key_product_name'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily:
                                                      ConstantCommon.BASE_FONT,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: Align(
                                          child: new Container(
                                            child: new Text(
                                              AppLocalizations.instance
                                                  .text('key_product_code'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily:
                                                      ConstantCommon.BASE_FONT,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: new Text(
                                              item.productName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily: ConstantCommon
                                                      .BASE_FONT_REGULAR,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(1.5)),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: Align(
                                          child: new Container(
                                            child: new Text(
                                              "${item.productCode}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily: ConstantCommon
                                                      .BASE_FONT_REGULAR,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(1.5)),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: new Text(
                                              AppLocalizations.instance
                                                  .text('key_product_stock'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily:
                                                      ConstantCommon.BASE_FONT,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(3.5)),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: Align(
                                          child: new Container(
                                            child: new Text(
                                              AppLocalizations.instance
                                                  .text('key_product_cost'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily:
                                                      ConstantCommon.BASE_FONT,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(3.5)),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: new Text(
                                              "${item.productStockKg} kg",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily: ConstantCommon
                                                      .BASE_FONT_REGULAR,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(1.5),
                                                bottom: appConfig.rHP(1.5)),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: Align(
                                          child: new Container(
                                            child: new Text(
                                              "₹ ${item.productCost}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color:
                                                      ConstantColor.COLOR_BLACK,
                                                  fontFamily: ConstantCommon
                                                      .BASE_FONT_REGULAR,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(1.5),
                                                bottom: appConfig.rHP(1.5)),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Expanded(
                                        child: new Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              bottom: appConfig.rHP(3),
                                              top: appConfig.rHP(2.5)),
                                          child: FlatButton(
                                            child: Text(
                                                AppLocalizations.instance
                                                    .text('key_editing'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ConstantColor
                                                        .COLOR_WHITE,
                                                    fontFamily: ConstantCommon
                                                        .BASE_FONT,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            color: ConstantColor.COLOR_GREEN,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                productDetailsNavigate = item;
                                                navigationPushReplacementPassParams(
                                                    AddProductScreenStateful(
                                                  productDetails:
                                                      productDetailsNavigate,
                                                ));
                                              });
                                            },
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              bottom: appConfig.rHP(3),
                                              top: appConfig.rHP(2.5)),
                                          child: FlatButton(
                                            child: Text(
                                                AppLocalizations.instance
                                                    .text('key_delete'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ConstantColor
                                                        .COLOR_WHITE,
                                                    fontFamily: ConstantCommon
                                                        .BASE_FONT,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            color: ConstantColor.COLOR_RED,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _modaProductCrud.productId =
                                                    item.productId;
                                                showAlertDialog(
                                                    AppLocalizations.instance
                                                        .text(
                                                            'key_are_you_delete'),
                                                    AppLocalizations.instance
                                                        .text('key_yes'),
                                                    AppLocalizations.instance
                                                        .text('key_no'),
                                                    0,
                                                    this);
                                              });
                                            },
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );

    Container containerAppTitleHintBar = new Container(
        color: ConstantColor.COLOR_PRODUCTS,
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      right: appConfig.rWP(1),
                      left: appConfig.rWP(5),
                      top: appConfig.rWP(3),
                      bottom: appConfig.rWP(2)),
                  child: Image.asset(
                    "assets/images/product.png",
                    width: 40,
                    height: 40,
                  ),
                ),
                new Container(
                  child: new Text(
                    AppLocalizations.instance.text('key_user_product_list'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_WHITE,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                    height: 3.0,
                    margin: EdgeInsets.only(left: appConfig.rWP(5)),
                    width: appConfig.rW(39),
                    color: ConstantColor.COLOR_PRODUCTS_BACKGROUND),
              ],
            ),
          ],
        ));

    Container containerAppHint = new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(
                left: appConfig.rWP(5),
                top: appConfig.rHP(3),
                bottom: appConfig.rHP(2)),
            child: new Text(
              AppLocalizations.instance.text('key_user_product_list'),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: ConstantColor.COLOR_PRODUCTS,
                  fontFamily: ConstantCommon.BASE_FONT,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );

    Container containerClubListsAll = new Container(
      child: new Column(
        children: <Widget>[
          containerAppTitleHintBar,
          containerAppHint,
          new Container(
            padding: EdgeInsets.all(appConfig.rWP(3)),
            child: expansionPanelList,
          ),
        ],
      ),
    );

    Container containerAppBar = Container(
        margin: EdgeInsets.only(
            top: appConfig.rHP(1),
            left: appConfig.rWP(0),
            right: appConfig.rWP(1),
            bottom: appConfig.rHP(1)),
        child: new InkWell(
          child: new Container(
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  // flex: 0,
                  child: new Container(
                    child: new Column(children: [
                      new Container(
                        child: new TextFormField(
                          style: TextStyle(
                              color: ConstantColor.COLOR_DARK_GRAY,
                              fontSize: 16,
                              fontFamily: ConstantCommon.BASE_FONT_REGULAR),
                          enableInteractiveSelection: true,
                          keyboardType: TextInputType.text,
                          controller: searchcontroller,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: ConstantColor.COLOR_DARK_GRAY,
                              ),
                              focusColor: ConstantColor.COLOR_LIGHT_GREY,
                              filled: true,
                              fillColor: ConstantColor.COLOR_WHITE,
                              hintText:
                                  AppLocalizations.instance.text('key_search'),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: ConstantColor.COLOR_DARK_GRAY),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.only(top: appConfig.rHP(1.5))),
                          onFieldSubmitted: (v) {},
                          enableSuggestions: true,
                          onChanged: (value) {
                            setState(() {
                              filterSearchResults(value);
                            });
                          },
                        ),
                        height: appConfig.rH(5),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {},
        ));

    Center containerNoData = new Center(
      child: new Container(
          padding: EdgeInsets.only(top: appConfig.rHP(25)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Center(
                child: new Container(
                  child: Image.asset(
                    "assets/images/empty.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              new Center(
                child: new Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      AppLocalizations.instance.text('key_no_data_found'),
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

    Container containerCircularLoader = new Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 6,
        value: _modaProductCrud.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_WHITE),
      )),
    );

    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ConstantColor.COLOR_PRODUCTS_BACKGROUND,
          drawerEdgeDragWidth: 0,
          appBar: AppBar(
            backgroundColor: ConstantColor.COLOR_PRODUCTS,
            automaticallyImplyLeading: false,
            title: containerAppBar,
            centerTitle: false,
            actions: <Widget>[],
            bottomOpacity: 1,
          ),
          body: !_modaProductCrud.isNetworkStatus
              ? RefreshIndicator(
                  key: refreshKey,
                  child: new Stack(
                    children: [
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: AbsorbPointer(
                          child: Center(
                            child: new Container(
                              child: Column(
                                children: <Widget>[
                                  new Stack(
                                    children: <Widget>[
                                      new Stack(
                                        children: <Widget>[
                                          new Container(
                                            child: new Column(
                                              children: <Widget>[
                                                _modaProductCrud.boolNodata
                                                    ? containerNoData
                                                    : containerClubListsAll
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          new Align(
                                              alignment: Alignment.center,
                                              child: containerCircularLoader),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          absorbing: _modaProductCrud.loadingEnableDisable,
                        ),
                      ),
                    ],
                  ),
                  onRefresh: refreshList)
              : centerContainerNoNetwork,
          floatingActionButton: new FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: ConstantColor.COLOR_PRODUCTS,
            onPressed: () {
              setState(() {
                productDetailsNavigate = new ProductDetails();
                navigationPushReplacementPassParams(AddProductScreenStateful(
                  productDetails: productDetailsNavigate,
                ));
              });
            },
          ),
        ),
        onWillPop: () {
          setState(() {
            navigateBaseRouting(7);
          });
        });
  }

  _refreshScrollListener() {
    String message = "";
    if (_RefreshController.offset <=
            _RefreshController.position.minScrollExtent &&
        !_RefreshController.position.outOfRange) {
      setState(() {
        message = "reach the top";
        print("reach the top");
      });
    }
  }

  void filterSearchResults(String query) {
    List<ProductDetails> dummyCallLogImportInfo = [];
    dummyCallLogImportInfo.addAll(duplicateCallLogImportInfo);
    if (query.isNotEmpty) {
      List<ProductDetails> dummyListData = [];
      dummyCallLogImportInfo.forEach((item) {
        if (item.productName.toLowerCase().contains(query) ||
            item.productCode.toLowerCase().contains(query) ||
            item.productId.toLowerCase().contains(query) ||
            item.productId.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        callLogImportInfo.clear();
        callLogImportInfo.addAll(dummyListData);
        updateNoDataController();
      });
      return;
    } else {
      setState(() {
        callLogImportInfo.clear();
        callLogImportInfo.addAll(duplicateCallLogImportInfo);
      });
    }
  }

  void initNetworkConnectivity() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _sourceConnectionStatus = source);
      print("initnetw" + _sourceConnectionStatus.toString());
    });
  }

  void forSomeDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // onlineDisappear();
    });
  }

  void showDialog() {
    setState(() {
      _modaProductCrud.loadingEnableDisable = true;
      _modaProductCrud.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modaProductCrud.loadingEnableDisable = false;
      _modaProductCrud.loadingCircularBar = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        apiCallBack(6);
        _RefreshController = ScrollController();
        _RefreshController.addListener(_refreshScrollListener);
        initNetworkConnectivity();
      });
    }
  }

  @override
  void onConnectivityResponse(bool status) {
    if (status) {
      setState(() {
        updateInternetConnectivity(false);
      });
    } else {
      updateInternetConnectivity(true);
      setState(() {
        updateInternetConnectivity(true);
        //checkInternetAlert();
      });
    }
  }

  void getUserCallLogReport() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterProductList.getProductList();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  void getUpdateProductApi() {
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

  void apiCallBack(int event) {
    setState(() {
      if (event == 6) {
        showDialog();
        getUserCallLogReport();
      } else if (event == 1) {
        showDialog();
        getUpdateProductApi();
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      apiCallBack(6);
    });
    return null;
  }

  @override
  void onFailureResponseGetProductList(String statusCode) {
    setState(() {
      showErrorAlert(statusCode);
      dismissLoadingDialog();
    });
  }

  @override
  void onSuccessResponseGetProductList(
      ProductListResponseModel productListResponseModel) {
    setState(() {
      dismissLoadingDialog();
      if (productListResponseModel.isSuccess) {
        callLogImportInfo = (productListResponseModel.productDetails as List)
            .map((datas) => new ProductDetails.fromMap(datas))
            .toList();
        duplicateCallLogImportInfo =
            (productListResponseModel.productDetails as List)
                .map((datas) => new ProductDetails.fromMap(datas))
                .toList();
      } else {
        callLogImportInfo = [];
        duplicateCallLogImportInfo = [];
      }
      updateNoDataController();
    });
  }

  void updateNoDataController() {
    if (callLogImportInfo.length > 0) {
      updateNoData(false);
    } else {
      updateNoData(true);
    }
  }

  @override
  void onTapAlertOkayListener() {
    setState(() {
      apiCallBack(1);
    });
  }

  @override
  void onTapAlertQuitAppListener() {
    setState(() {
      SystemNavigator.pop();
    });
  }

  @override
  String getPageCount() {
    return "0";
  }

  @override
  String getSearchkeyword() {
    return "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Map parseGetProductDetailsRequestData() {
    return _modaProductCrud.mapProductDetDetailsData = {
      "search_keyword": getSearchkeyword().trim(),
      "page_count": getPageCount().trim(),
      "page_limits": BaseSingleton.shared.pageLimits
    };
  }

  @override
  void onTapAlertProductCalculationListener(ProductDetails productDetails) {
    setState(() {});
  }

  @override
  void errorValidationMgs(String error) {
    setState(() {
      showToast(error);
    });
  }

  @override
  String getProductCodeUpdate() {
    return "";
  }

  @override
  String getProductCostUpdate() {
    return "";
  }

  @override
  String getProductIdUpdate() {
    return _modaProductCrud.productId;
  }

  @override
  String getProductNameUpdate() {
    return "";
  }

  @override
  String getProductStatusUpdate() {
    return "false";
  }

  @override
  String getProductStockKgUpdate() {
    return "";
  }

  @override
  void onFailureMessageUpdateProduct(String error) {
    setState(() {
      showErrorAlert(error);
      dismissLoadingDialog();
    });
  }

  @override
  void onSuccessResponseUpdateProduct(
      UpdateProductResponseModel updateProductResponseModel) {
    setState(() {
      dismissLoadingDialog();
      showToast(updateProductResponseModel.message);
      apiCallBack(6);
    });
  }

  @override
  Map parseUpdateProductData() {
    return {
      "product_id": getProductIdUpdate(),
      "product_name": getProductNameUpdate(),
      "product_cost": getProductCostUpdate(),
      "product_stock_kg": getProductStockKgUpdate(),
      "product_code": getProductCodeUpdate(),
      "product_status": getProductStatusUpdate()
    };
  }

  @override
  void postUpdateProductData() {
    setState(() {});
  }

  @override
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }
}
