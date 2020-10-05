import 'package:IGO/src/data/apis/report/orderreports/IOrderReportListener.dart';
import 'package:IGO/src/data/apis/report/orderreports/PresenterOrderReportList.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';
import 'package:IGO/src/ui/dashboard/DashboardScreen.dart';
import 'package:IGO/src/ui/dashboard/DateModel.dart';
import 'package:IGO/src/ui/report/overalldetailreport/OverAllDetailedReportScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModalOverallReport.dart';
import 'OverAllParamModel.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(OverallReportListScreen());
OverAllParamModel overAllParamModel;

class OverallReportListScreen extends StatelessWidget {
  const OverallReportListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverallReportListStateful(),
    );
  }
}

class OverallReportListStateful extends StatefulWidget {
  String title;
  final DateModel dateModel;

  OverallReportListStateful({Key key, this.title, @required this.dateModel})
      : super(key: key);

  @override
  OverallReportListState createState() => OverallReportListState();
}

class OverallReportListState
    extends BaseStateStatefulState<OverallReportListStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        BaseAlertListener,
        IOrderReportListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalOverallReport _modalOverallReport;
  TextEditingController searchcontroller = new TextEditingController();
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  PresenterOrderReportList _presenterOrderReportList;
  List<CustomerDetails> customerDetails = [];
  List<CustomerDetails> duplicateCustomerDetails = [];
  List<OverAllReports> listOverAllReports = [];

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  OverallReportListState() {
    this._modalOverallReport = new ModalOverallReport();
    this._connectivity = new Connectivitys(this);
    this._presenterOrderReportList = new PresenterOrderReportList(this);
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalOverallReport.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalOverallReport.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalOverallReport.eventCircularLoader = status;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    Container containerOverAllReports = new Container(
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
                                      onTap: () {
                                        setState(() {
                                          overAllParamModel =
                                              new OverAllParamModel(
                                                  listOverAllReports[index]
                                                      .orderId,
                                                  listOverAllReports[index]
                                                      .customerId,
                                                  listOverAllReports[index]
                                                      .totalAmount);
                                          navigationPushReplacementPassParams(
                                              OverAllDetailedReportStateful(
                                                  overAllParamModel:
                                                      overAllParamModel));
                                        });
                                      },
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
                                                            child: new Align(
                                                              child:
                                                                  new Container(
                                                                child: new Text(
                                                                  AppLocalizations
                                                                      .instance
                                                                      .text(
                                                                          'key_product_name'),
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
                                                                          'key_product_cost'),
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
                                                              child:
                                                                  new Container(
                                                                child: new Text(
                                                                  "# ${listOverAllReports[index].orderId ?? ''}",
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
                                                                        .rHP(
                                                                            1.5)),
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
                                                                  "₹ ${listOverAllReports[index].totalAmount ?? 0}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
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
                                                                        .rHP(
                                                                            1.5),
                                                                    bottom: appConfig
                                                                        .rHP(
                                                                            1.5)),
                                                              ),
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                        ],
                                                      ),
                                                      new Row(
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
                                                      new Row(
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
                                                                      "₹ ${listOverAllReports[index].receivedAmount ?? 0}",
                                                                      textAlign:
                                                                          TextAlign
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
                                                                        () {});
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
                                                                  "₹ ${listOverAllReports[index].pendingAmount ?? 0}",
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
                                                  margin: EdgeInsets.only(
                                                      top: appConfig.rHP(4)),
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
                childCount: listOverAllReports.length),
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
                    AppLocalizations.instance.text('key_customers'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
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
                    color: ConstantColor.COLOR_APP_BASE),
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
            margin: EdgeInsets.only(top: appConfig.rHP(7)),
            child: containerOverAllReports,
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
                              //filterSearchResults(value);
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
              child: Text(AppLocalizations.instance.text('key_no_data_found'),
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
        value: _modalOverallReport.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_APP_BASE),
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
            actions: <Widget>[],
            bottomOpacity: 1,
          ),
          body: !_modalOverallReport.isNetworkStatus
              ? _modalOverallReport.boolNodata
                  ? containerNoData
                  : containerClubListsAll
              : centerContainerNoNetwork,
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
    List<CustomerDetails> dummyCustomerDetails = [];
    dummyCustomerDetails.addAll(duplicateCustomerDetails);
    if (query.isNotEmpty) {
      List<CustomerDetails> dummyListData = [];
      dummyCustomerDetails.forEach((item) {
        if (item.customerName.toLowerCase().contains(query) ||
            item.customerBillingName.toLowerCase().contains(query) ||
            item.customerMobileNo.toLowerCase().contains(query) ||
            item.customerWhatsappNo.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        customerDetails.clear();
        customerDetails.addAll(dummyListData);
        updateNoDataController();
      });
      return;
    } else {
      setState(() {
        customerDetails.clear();
        customerDetails.addAll(duplicateCustomerDetails);
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

  void showDialog() {
    setState(() {
      _modalOverallReport.loadingEnableDisable = true;
      _modalOverallReport.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalOverallReport.loadingEnableDisable = false;
      _modalOverallReport.loadingCircularBar = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        apiCallBack(1);
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

  void getOverAllReportList() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterOrderReportList.getOrderReportList();
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
      if (event == 1) {
        showDialog();
        getOverAllReportList();
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      apiCallBack(1);
    });
    return null;
  }

  void updateNoDataController() {
    setState(() {
      if (listOverAllReports.length > 0) {
        updateNoData(false);
      } else {
        updateNoData(true);
      }
    });
  }

  @override
  void onTapAlertOkayListener() {
    setState(() {});
  }

  @override
  void onTapAlertQuitAppListener() {
    setState(() {
      SystemNavigator.pop();
    });
  }

  @override
  void onTapAlertProductCalculationListener(ProductDetails productDetails) {}

  @override
  int eventId() {
    return 0;
  }

  @override
  String getCustomerId() {
    return "";
  }

  @override
  String getFromDate() {
    return dateModel.fromDate;
  }

  @override
  String getPageCount() {
    return "0";
  }

  @override
  String getPageLimits() {
    return "100";
  }

  @override
  String getSearchkeyword() {
    return "";
  }

  @override
  String getToDate() {
    return dateModel.toDate;
  }

  @override
  void onFailureResponseGetOverAllOrderList(String statusCode) {
    setState(() {
      updateNoDataController();
      dismissLoadingDialog();
      showErrorAlert(statusCode);
    });
  }

  @override
  void onSuccessResponseGetOverAllOrderList(
      List<OverAllReports> listOverAllReports) {
    setState(() {
      dismissLoadingDialog();
      if (listOverAllReports.isNotEmpty && listOverAllReports != null) {
        this.listOverAllReports = listOverAllReports;
        updateNoDataController();
      }
    });
  }

  @override
  Map parseGetOverAllOrderRequestData() {
    return {
      "customer_id": getCustomerId(),
      "search_keyword": getSearchkeyword(),
      "page_count": getPageCount(),
      "page_limits": getPageLimits(),
      "from_date": getFromDate(),
      "to_date": getToDate(),
      "event_id": eventId()
    };
  }
}
