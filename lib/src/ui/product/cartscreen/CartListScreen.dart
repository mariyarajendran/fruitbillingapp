import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import '../../../utils/localizations.dart';
import 'ModalCartLists.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(CartListScreen());

int organizationID;
String organizationName;
String organizationName2;
String eventStartDate;
double eventLatitude;
double eventLongitude;

class CartListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CartListScreenStateful(),
    );
  }
}

class CartListScreenStateful extends StatefulWidget {
  CartListScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CartListScreenState createState() => CartListScreenState();
}

class CartListScreenState extends BaseStateStatefulState<CartListScreenStateful>
    with TickerProviderStateMixin
    implements ViewContractConnectivityListener, BaseAlertListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalCartLists _modalCartLists;

  AnimationController _animationController;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  CartListScreenState() {
    this._modalCartLists = new ModalCartLists();
    this._connectivity = new Connectivitys(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalCartLists.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalCartLists.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalCartLists.eventCircularLoader = status;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    Container containerProductBilling = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      margin: EdgeInsets.only(top: appConfig.rHP(1)),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => new Container(
                margin: EdgeInsets.only(
                    left: appConfig.rWP(1),
                    right: appConfig.rWP(1),
                    top: appConfig.rHP(0.1)),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Card(
                              elevation: 3,
                              child: new ListTile(
                                onTap: () {},
                                title: new Stack(
                                  children: <Widget>[
                                    new Container(
                                      width: double.infinity,
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Container(
                                            child: new Column(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    child: Image.asset(
                                                      "assets/images/close.png",
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        top: appConfig.rHP(1),
                                                        bottom:
                                                            appConfig.rHP(2)),
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      BaseSingleton.shared
                                                          .billingProductList
                                                          .removeAt(index);
                                                      updateNoDataController();
                                                    });
                                                  },
                                                ),
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: new Align(
                                                        child: new Container(
                                                          child: new Text(
                                                            BaseSingleton
                                                                    .shared
                                                                    .billingProductList[
                                                                        index]
                                                                    .productPreviousBalanceFlag
                                                                ? AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        'previous_balance_details')
                                                                : AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        'key_product_name'),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: ConstantColor
                                                                    .COLOR_BLACK,
                                                                fontFamily:
                                                                    ConstantCommon
                                                                        .BASE_FONT,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                      ),
                                                      flex: 1,
                                                    ),
                                                    new Expanded(
                                                      child: Align(
                                                        child: new Container(
                                                          child: new Text(
                                                            BaseSingleton
                                                                    .shared
                                                                    .billingProductList[
                                                                        index]
                                                                    .productPreviousBalanceFlag
                                                                ? AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        'previous_balance')
                                                                : AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        'key_product_cost'),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: ConstantColor
                                                                    .COLOR_BLACK,
                                                                fontFamily:
                                                                    ConstantCommon
                                                                        .BASE_FONT,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .bottomRight,
                                                      ),
                                                      flex: 1,
                                                    )
                                                  ],
                                                ),
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: new Align(
                                                        child: new Container(
                                                          child: new Text(
                                                            BaseSingleton
                                                                .shared
                                                                .billingProductList[
                                                                    index]
                                                                .productName,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: ConstantColor
                                                                    .COLOR_BLACK,
                                                                fontFamily:
                                                                    ConstantCommon
                                                                        .BASE_FONT_REGULAR,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          margin: EdgeInsets.only(
                                                              top: appConfig
                                                                  .rHP(1.5),
                                                              bottom: appConfig
                                                                  .rHP(2)),
                                                        ),
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                      ),
                                                      flex: 1,
                                                    ),
                                                    new Expanded(
                                                      child: Align(
                                                        child: new Container(
                                                          child: new Text(
                                                            BaseSingleton
                                                                    .shared
                                                                    .billingProductList[
                                                                        index]
                                                                    .purchaseBoxFlag
                                                                ? "₹ ${BaseSingleton.shared.billingProductList[index].boxCost}"
                                                                : "₹ ${BaseSingleton.shared.billingProductList[index].productCost}",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: ConstantColor
                                                                    .COLOR_BLACK,
                                                                fontFamily:
                                                                    ConstantCommon
                                                                        .BASE_FONT_REGULAR,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          margin: EdgeInsets.only(
                                                              top: appConfig
                                                                  .rHP(1.5),
                                                              bottom: appConfig
                                                                  .rHP(2)),
                                                        ),
                                                        alignment: Alignment
                                                            .bottomRight,
                                                      ),
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                                BaseSingleton
                                                        .shared
                                                        .billingProductList[
                                                            index]
                                                        .productPreviousBalanceFlag
                                                    ? new Container()
                                                    : new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          new Expanded(
                                                            child: new Align(
                                                              child:
                                                                  new Container(
                                                                child: new Text(
                                                                  AppLocalizations
                                                                      .instance
                                                                      .text(
                                                                          'key_edit_kg'),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_BLACK,
                                                                      fontFamily:
                                                                          ConstantCommon
                                                                              .BASE_FONT,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                margin: EdgeInsets.only(
                                                                    top: appConfig
                                                                        .rHP(
                                                                            3)),
                                                              ),
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                          new Expanded(
                                                            child: Align(
                                                              child:
                                                                  new Container(
                                                                child: new Text(
                                                                  AppLocalizations
                                                                      .instance
                                                                      .text(
                                                                          'key_total_cost'),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_BLACK,
                                                                      fontFamily:
                                                                          ConstantCommon
                                                                              .BASE_FONT,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                margin: EdgeInsets.only(
                                                                    top: appConfig
                                                                        .rHP(
                                                                            3)),
                                                              ),
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                        ],
                                                      ),
                                                BaseSingleton
                                                        .shared
                                                        .billingProductList[
                                                            index]
                                                        .productPreviousBalanceFlag
                                                    ? new Container()
                                                    : new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          new Expanded(
                                                            child: new Align(
                                                              child:
                                                                  new Container(
                                                                child:
                                                                    FlatButton(
                                                                  child: Text(
                                                                      BaseSingleton
                                                                              .shared
                                                                              .billingProductList[
                                                                                  index]
                                                                              .purchaseBoxFlag
                                                                          ? "${BaseSingleton.shared.billingProductList[index].totalKiloGrams} Box"
                                                                          : "${BaseSingleton.shared.billingProductList[index].totalKiloGrams} Kg",
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          color: ConstantColor
                                                                              .COLOR_WHITE,
                                                                          fontFamily: ConstantCommon
                                                                              .BASE_FONT,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                  color: ConstantColor
                                                                      .COLOR_RED,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      showProductCalculationAlertDialog(
                                                                          BaseSingleton
                                                                              .shared
                                                                              .billingProductList[
                                                                                  index]
                                                                              .productName,
                                                                          AppLocalizations.instance.text(
                                                                              'key_done'),
                                                                          AppLocalizations.instance.text(
                                                                              'key_clear'),
                                                                          1,
                                                                          BaseSingleton
                                                                              .shared
                                                                              .billingProductList[index],
                                                                          this);
                                                                    });
                                                                  },
                                                                ),
                                                                margin: EdgeInsets.only(
                                                                    top: appConfig
                                                                        .rHP(3),
                                                                    bottom: appConfig
                                                                        .rHP(
                                                                            3)),
                                                              ),
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                          new Expanded(
                                                            child: Align(
                                                              child:
                                                                  new Container(
                                                                child: new Text(
                                                                  "₹ ${BaseSingleton.shared.billingProductList[index].totalCost}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_BLACK,
                                                                      fontFamily:
                                                                          ConstantCommon
                                                                              .BASE_FONT_REGULAR,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                margin: EdgeInsets.only(
                                                                    top: appConfig
                                                                        .rHP(3),
                                                                    bottom: appConfig
                                                                        .rHP(
                                                                            3)),
                                                              ),
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              childCount: BaseSingleton.shared.billingProductList.length,
            ),
          ),
        ],
      ),
      //),
    );

    Container containerAppTitleHintBar = new Container(
        color: ConstantColor.COLOR_WHITE,
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Stack(
                  children: [
                    new Container(
                      padding: EdgeInsets.only(
                          right: appConfig.rWP(1),
                          left: appConfig.rWP(5),
                          top: appConfig.rWP(3),
                          bottom: appConfig.rWP(2)),
                      child: Image.asset(
                        "assets/images/cart.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    new Positioned(
                        child: new Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        new Icon(Icons.brightness_1,
                            size: 30.0, color: ConstantColor.COLOR_RED),
                        new Positioned(
                            top: 6.0,
                            right: 8.0,
                            child: new Center(
                              child: new Text(
                                BaseSingleton.shared.billingProductList.length
                                    .toString(),
                                style: TextStyle(
                                    color: ConstantColor.COLOR_WHITE,
                                    fontFamily: ConstantCommon.BASE_FONT,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    )),
                  ],
                ),
                new Container(
                  child: new Text(
                    AppLocalizations.instance.text('key_cart'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Spacer(),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                    height: 3.0,
                    margin: EdgeInsets.only(left: appConfig.rWP(5)),
                    width: appConfig.rW(39),
                    color: ConstantColor.COLOR_PREVIEW_BILL),
              ],
            ),
          ],
        ));

    Container containerClubListsAll = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      child: new Stack(
        children: <Widget>[
          containerAppTitleHintBar,
          new Container(
            margin: EdgeInsets.only(
                top: appConfig.rHP(7), bottom: appConfig.rHP(6)),
            child: containerProductBilling,
          ),
        ],
      ),
    );

    Container previewBillContainer = new Container(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: appConfig.rHP(7)),
            width: double.infinity,
            height: appConfig.rHP(6),
            child: FlatButton(
              child: Text(AppLocalizations.instance.text('key_bill_preview'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_WHITE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 17,
                      fontWeight: FontWeight.w400)),
              color: ConstantColor.COLOR_RED,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  navigateBaseRouting(4);
                });
              },
            ),
          )),
    );

    Container containerAppBar = Container(
      child: new Container(
          child: new Row(
        children: [
          new Expanded(
            child: new Container(
              width: appConfig.rW(20),
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
              child: Text(AppLocalizations.instance.text('key_product_cart'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_WHITE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
              margin: EdgeInsets.only(right: appConfig.rWP(7)),
            ),
          ),
          new Expanded(
              flex: 0,
              child: new InkWell(
                child: new Container(
                  padding: EdgeInsets.only(
                      right: appConfig.rWP(1),
                      left: appConfig.rWP(3),
                      top: appConfig.rWP(3),
                      bottom: appConfig.rWP(2)),
                  child: Image.asset(
                    "assets/images/addproduct.png",
                    width: 30,
                    height: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    dismissKeyboard();
                    navigateBaseRouting(2);
                  });
                },
              ))
        ],
      )),
    );

    Center containerNoData = new Center(
      child: new Container(
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
              child: Text(AppLocalizations.instance.text('key_cart_empty'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_APP_BASE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          new Container(
              height: 40,
              child: FloatingActionButton.extended(
                  backgroundColor: ConstantColor.COLOR_APP_BASE,
                  elevation: 5.0,
                  onPressed: () {
                    dismissKeyboard();
                    setState(() {
                      navigateBaseRouting(2);
                    });
                  },
                  label: Text(
                    AppLocalizations.instance.text('key_add_product'),
                    style: TextStyle(
                        fontSize: 14,
                        color: ConstantColor.COLOR_WHITE,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantCommon.BASE_FONT),
                  ))),
        ],
      )),
    );

    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ConstantColor.COLOR_BACKGROUND,
          drawerEdgeDragWidth: 0,
          appBar: AppBar(
            backgroundColor: ConstantColor.COLOR_BILLINGS,
            automaticallyImplyLeading: false,
            title: containerAppBar,
            centerTitle: false,
            bottomOpacity: 1,
          ),
          body: !_modalCartLists.isNetworkStatus
              ? _modalCartLists.boolNodata
                  ? containerNoData
                  : new Stack(
                      children: [containerClubListsAll, previewBillContainer],
                    )
              : centerContainerNoNetwork,
        ),
        onWillPop: () {
          setState(() {
            navigateBaseRouting(2);
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
      _modalCartLists.loadingEnableDisable = true;
      _modalCartLists.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalCartLists.loadingEnableDisable = false;
      _modalCartLists.loadingCircularBar = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _RefreshController = ScrollController();
        _RefreshController.addListener(_refreshScrollListener);
        initNetworkConnectivity();
        updateNoDataController();
      });
    }
  }

  @override
  void onConnectivityResponse(bool status) {
    if (status) {
      setState(() {
        updateInternetConnectivity(false);
        apiCallBack(6);
      });
    } else {
      updateInternetConnectivity(true);
      setState(() {
        updateInternetConnectivity(true);
        //checkInternetAlert();
      });
    }
  }

  void apiCallBack(int event) {
    setState(() {
      if (event == 6) {
      } else if (event == 7) {}
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

  void updateNoDataController() {
    if (BaseSingleton.shared.billingProductList.length > 0) {
      updateNoData(false);
    } else {
      updateNoData(true);
    }
  }

  @override
  void onTapAlertOkayListener() {
    setState(() {
      apiCallBack(7);
    });
  }

  @override
  void onTapAlertQuitAppListener() {
    setState(() {
      SystemNavigator.pop();
    });
  }

  @override
  void onTapAlertProductCalculationListener(ProductDetails productDetails) {
    setState(() {});
  }

  @override
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }
}
