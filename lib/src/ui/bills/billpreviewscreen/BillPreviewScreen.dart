import 'package:IGO/src/models/responsemodel/product/calllogresponsemodel/ProductListResponseModel.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModalBillPreview.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(BillPreviewScreen());

int organizationID;
String organizationName;
String organizationName2;
String eventStartDate;
double eventLatitude;
double eventLongitude;

class BillPreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillPreviewScreenStateful(),
    );
  }
}

class BillPreviewScreenStateful extends StatefulWidget {
  BillPreviewScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  BillPreviewScreenState createState() => BillPreviewScreenState();
}

class BillPreviewScreenState
    extends BaseStateStatefulState<BillPreviewScreenStateful>
    with TickerProviderStateMixin
    implements ViewContractConnectivityListener, BaseAlertListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalBillPreview _modalBillPreview;

  AnimationController _animationController;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};


  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  BillPreviewScreenState() {
    this._modalBillPreview = new ModalBillPreview();
    this._connectivity = new Connectivitys(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalBillPreview.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalBillPreview.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalBillPreview.eventCircularLoader = status;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    Container containerBillPreviewCustomerDetails = new Container(
        child: new Container(
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
                                                .text('key_name'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                                .text('key_customer_bill_name'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                            BaseSingleton
                                                .shared
                                                .customerDetails[0]
                                                .customerName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                            BaseSingleton
                                                .shared
                                                .customerDetails[0]
                                                .customerBillingName,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                                .text('key_customer_phone_no'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                            AppLocalizations.instance.text(
                                                'key_customer_whatsapp_no'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                            BaseSingleton
                                                .shared
                                                .customerDetails[0]
                                                .customerMobileNo,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
                                            BaseSingleton
                                                .shared
                                                .customerDetails[0]
                                                .customerWhatsappNo,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color:
                                                    ConstantColor.COLOR_WHITE,
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
        margin: EdgeInsets.only(top: appConfig.rHP(2)));

    Container containerProductBilling = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      margin: EdgeInsets.only(top: appConfig.rHP(1)),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              floating: false,
              pinned: false,
              snap: false,
              backgroundColor: ConstantColor.COLOR_APP_BASE,
              flexibleSpace: SingleChildScrollView(
                child: containerBillPreviewCustomerDetails,
              ),
              bottom: new PreferredSize(
                  child: new Container(),
                  preferredSize: Size(appConfig.rW(50), appConfig.rH(13)))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => new Container(
                margin: EdgeInsets.only(
                  left: appConfig.rWP(1),
                  right: appConfig.rWP(1),
                ),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Card(
                              elevation: 2,
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
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      flex: 1,
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
                                                                .rHP(1.5)),
                                                      ),
                                                    ),
                                                    new Expanded(
                                                      flex: 1,
                                                      child: new Container(
                                                        child: new Text(
                                                          "₹ ${BaseSingleton.shared.billingProductList[index].productCost}",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        ),
                                                      ),
                                                    ),
                                                    new Expanded(
                                                      flex: 1,
                                                      child: new Container(
                                                        child: new Text(
                                                          "${BaseSingleton.shared.billingProductList[index].totalKiloGrams} Kg",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        ),
                                                      ),
                                                    ),
                                                    new Expanded(
                                                      flex: 1,
                                                      child: new Container(
                                                        child: new Text(
                                                          "₹ ${BaseSingleton.shared.billingProductList[index].totalCost}",
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
                                                                .rHP(1.5)),
                                                      ),
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

    Container containerBillHints = new Container(
      child: new Container(
        //margin: EdgeInsets.only(top: appConfig.rHP(8)),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Card(
              color: ConstantColor.COLOR_APP_BASE,
              elevation: 3,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    height: appConfig.rH(5),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        AppLocalizations.instance
                                            .text('key_product'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        AppLocalizations.instance
                                            .text('key_product_costs'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        AppLocalizations.instance
                                            .text('key_kg'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        AppLocalizations.instance
                                            .text('key_total'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
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
            ),
          ],
        ),
      ),
    );

    Container previewBillTotalContainer = new Container(
      margin: EdgeInsets.only(bottom: appConfig.rHP(6)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Card(
              color: ConstantColor.COLOR_APP_BASE,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    height: appConfig.rH(5),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        AppLocalizations.instance
                                            .text('key_total_costs'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        "₹ ${calculateTotalCost()}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ConstantColor.COLOR_WHITE,
                                            fontFamily:
                                                ConstantCommon.BASE_FONT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
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
            ),
          ],
        ),
      ),
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
                        "assets/images/billing.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                new Container(
                  child: new Text(
                    AppLocalizations.instance.text('key_bill_preview_hint'),
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
                    color: ConstantColor.COLOR_APP_BASE),
              ],
            ),
          ],
        ));

    Container containerBillPreview = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      child: new Stack(
        children: <Widget>[
          //containerAppTitleHintBar,
          containerBillHints,
          new Container(
            margin: EdgeInsets.only(
                top: appConfig.rHP(5), bottom: appConfig.rHP(12)),
            child: containerProductBilling,
          ),
        ],
      ),
    );

    Container previewBillContainer = new Container(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: appConfig.rHP(6),
            child: FlatButton(
              child: Text(AppLocalizations.instance.text('key_save_bill'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_WHITE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 17,
                      fontWeight: FontWeight.w400)),
              color: ConstantColor.COLOR_GREEN,
              textColor: Colors.white,
              onPressed: () {
                setState(() {});
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
                    navigateBaseRouting(3);
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
                  AppLocalizations.instance.text('key_bill_preview_hint'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ConstantColor.COLOR_WHITE,
                      fontFamily: ConstantCommon.BASE_FONT,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
              margin: EdgeInsets.only(right: appConfig.rWP(15)),
            ),
          ),
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
                      navigateBaseRouting(3);
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
            backgroundColor: ConstantColor.COLOR_APP_BASE,
            automaticallyImplyLeading: false,
            title: containerAppBar,
            centerTitle: false,
            bottomOpacity: 1,
          ),
          body: !_modalBillPreview.isNetworkStatus
              ? _modalBillPreview.boolNodata
                  ? containerNoData
                  : new Stack(
                      children: [
                        containerBillPreview,
                        previewBillTotalContainer,
                        previewBillContainer
                      ],
                    )
              : centerContainerNoNetwork,
        ),
        onWillPop: () {
          setState(() {
            navigateBaseRouting(3);
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

  int calculateTotalCost() {
    int totalCount = 0;
    setState(() {
      for (int i = 0; i < BaseSingleton.shared.billingProductList.length; i++) {
        totalCount += BaseSingleton.shared.billingProductList[i].totalCost;
      }
    });
    return totalCount;
  }

  void forSomeDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // onlineDisappear();
    });
  }

  void showDialog() {
    setState(() {
      _modalBillPreview.loadingEnableDisable = true;
      _modalBillPreview.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalBillPreview.loadingEnableDisable = false;
      _modalBillPreview.loadingCircularBar = 0.0;
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
}
