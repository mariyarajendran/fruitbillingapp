import 'package:IGO/src/data/apis/report/orderreports/IOrderReportListener.dart';
import 'package:IGO/src/data/apis/report/orderreports/PresenterOrderReportList.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/customer/customercrud/CustomerListsCrudScreen.dart';
import 'package:IGO/src/ui/dashboard/DashboardScreen.dart';
import 'package:IGO/src/ui/dashboard/DateModel.dart';
import 'package:IGO/src/ui/report/overalldetailreport/OverAllDetailedReportScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import '../../../utils/localizations.dart';
import 'ModalOverallReport.dart';
import 'OverAllParamModel.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  OverallReportListStateful({Key key, this.title}) : super(key: key);

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
  DashboardScreen dashboardScreen;
  CustomerListsCrudScreen customerListsCrudScreen;

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
      margin: EdgeInsets.only(top: appConfig.rHP(3)),
      child: CustomScrollView(
        slivers: <Widget>[
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
                                                      .totalAmount,
                                                  listOverAllReports[index]
                                                      .receivedAmount,
                                                  listOverAllReports[index]
                                                      .pendingAmount,
                                                  listOverAllReports[index]
                                                      .orderSummaryId);
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
                                                                  "${listOverAllReports[index].customerName ?? ''}  ₹${listOverAllReports[index].totalAmount ?? ''}",
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
                                                                          16,
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
                                                                  "₹ ${listOverAllReports[index].receivedAmount ?? ''}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_GREEN,
                                                                      fontFamily:
                                                                          ConstantCommon
                                                                              .BASE_FONT,
                                                                      fontSize:
                                                                          16,
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
                                                                  AppLocalizations
                                                                          .instance
                                                                          .text(
                                                                              'key_order_id') +
                                                                      " #${listOverAllReports[index].orderId ?? ''}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_GERY_DATE,
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
                                                                            0)),
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
                                                                          .right,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_RED,
                                                                      fontFamily:
                                                                          ConstantCommon
                                                                              .BASE_FONT,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                margin: EdgeInsets.only(
                                                                    top: appConfig
                                                                        .rHP(1),
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
                                                                  listOverAllReports[index]
                                                                              .pendingAmount ==
                                                                          0
                                                                      ? AppLocalizations
                                                                          .instance
                                                                          .text(
                                                                              'key_bill_paid')
                                                                      : AppLocalizations
                                                                          .instance
                                                                          .text(
                                                                              'key_bill_pending'),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: listOverAllReports[index].pendingAmount == 0
                                                                          ? ConstantColor
                                                                              .COLOR_COOL_GREEN
                                                                          : ConstantColor
                                                                              .COLOR_RED,
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
                                                                            1.5),
                                                                    bottom: appConfig
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
                                                                  returnTime(listOverAllReports[
                                                                              index]
                                                                          .orderSummaryDate) +
                                                                      "\n" +
                                                                      returnDate(
                                                                          (listOverAllReports[index]
                                                                              .orderSummaryDate)),
                                                                  //"₹ ${listOverAllReports[index].orderSummaryDate ?? 0}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: TextStyle(
                                                                      color: ConstantColor
                                                                          .COLOR_GERY_DATE,
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
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      top: appConfig.rHP(2)),
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

    Container containerFromDate = new Container(
      margin: EdgeInsets.only(left: appConfig.rWP(5), right: appConfig.rWP(5)),
      height: 40,
      child: new TextFormField(
        style: TextStyle(
            color: ConstantColor.COLOR_WHITE,
            fontSize: 16,
            fontFamily: ConstantCommon.BASE_FONT_SEMI_BOLD),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            //labelText: AppLocalizations.instance.text('key_product_name'),
            labelText: "From Date",
            labelStyle: TextStyle(color: ConstantColor.COLOR_WHITE),
            hintStyle: TextStyle(color: ConstantColor.COLOR_WHITE),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_WHITE, width: 0.5),
                gapPadding: 10.0,
                borderRadius: BorderRadius.circular(1.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_WHITE, width: 1.3),
                gapPadding: 10.0),
            contentPadding: EdgeInsets.all(20.0)),
        onFieldSubmitted: (v) {},
        textCapitalization: TextCapitalization.sentences,
        controller: _modalOverallReport.textEditingControllerFromDate,
        readOnly: true,
        onTap: () {
          setState(() {
            _selectDate(context, 0);
          });
        },
      ),
    );

    Container containerToDate = new Container(
      margin: EdgeInsets.only(left: appConfig.rWP(5), right: appConfig.rWP(5)),
      height: 40,
      child: new TextFormField(
        style: TextStyle(
            color: ConstantColor.COLOR_WHITE,
            fontSize: 16,
            fontFamily: ConstantCommon.BASE_FONT_SEMI_BOLD),
        enableInteractiveSelection: false,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            //labelText: AppLocalizations.instance.text('key_product_name'),
            labelText: "To Date",
            labelStyle: TextStyle(color: ConstantColor.COLOR_WHITE),
            hintStyle: TextStyle(color: ConstantColor.COLOR_WHITE),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_WHITE, width: 0.5),
                gapPadding: 10.0,
                borderRadius: BorderRadius.circular(1.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_WHITE, width: 1.3),
                gapPadding: 10.0),
            contentPadding: EdgeInsets.all(20.0)),
        onFieldSubmitted: (v) {},
        textCapitalization: TextCapitalization.sentences,
        controller: _modalOverallReport.textEditingControllerToDate,
        readOnly: true,
        onTap: () {
          setState(() {
            _selectDate(context, 1);
          });
        },
      ),
    );

    Column columnDateFilter = new Column(
      children: [
        new Container(
          margin:
              EdgeInsets.only(left: appConfig.rWP(1), right: appConfig.rW(1)),
          child: Card(
            color: ConstantColor.COLOR_COOL_DARK_GERY,
            child: new Row(
              children: [
                new Expanded(flex: 2, child: containerFromDate),
                new Expanded(flex: 2, child: containerToDate),
              ],
            ),
            elevation: 2,
          ),
          height: 80,
        )
      ],
    );

    Container containerAppTitleHintBar = new Container(
        child: new Column(
      children: <Widget>[columnDateFilter],
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
        margin: EdgeInsets.only(top: appConfig.rHP(11), bottom: 10),
        child: CircularProgressIndicator(
          strokeWidth: 6,
          value: _modalOverallReport.loadingCircularBar,
          valueColor:
              new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_COOL_DARK_GERY),
        ));

    Container containerClubListsAll = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      child: new Stack(
        children: <Widget>[
          containerAppTitleHintBar,
          _modalOverallReport.boolNodata
              ? containerNoData
              : new Container(
                  margin: EdgeInsets.only(top: appConfig.rHP(8)),
                  child: containerOverAllReports,
                ),
          new Align(
              alignment: Alignment.topCenter, child: containerCircularLoader),
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

    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ConstantColor.COLOR_BACKGROUND,
          drawerEdgeDragWidth: 0,
          appBar: AppBar(
            backgroundColor: ConstantColor.COLOR_COOL_DARK_GERY,
            automaticallyImplyLeading: false,
            title: containerAppBar,
            centerTitle: false,
            actions: <Widget>[],
            bottomOpacity: 1,
          ),
          body: !_modalOverallReport.isNetworkStatus
              ? containerClubListsAll
              : centerContainerNoNetwork,
        ),
        onWillPop: () {
          setState(() {
            if (BaseSingleton.shared.dateModel.eventId == 0) {
              navigateBaseRouting(7);
            } else {
              navigateBaseRouting(10);
            }
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

  Future<void> _selectDate(BuildContext context, int event) async {
    final DateTime d = await showDatePicker(
      context: context,
      locale: Locale("en"),
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        if (event == 0) {
          returnFromDate(d, true);
        } else if (event == 1) {
          returnToDate(d, true);
        }
      });
  }

  String returnFromDate(DateTime dateTime, bool hitCall) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    _modalOverallReport.textEditingControllerFromDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modalOverallReport.fromDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(1);
    }
    return _modalOverallReport.fromDate;
  }

  String returnToDate(DateTime dateTime, bool hitCall) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    _modalOverallReport.textEditingControllerToDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modalOverallReport.toDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(1);
    }
    return _modalOverallReport.toDate;
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
        _RefreshController = ScrollController();
        _RefreshController.addListener(_refreshScrollListener);
        initNetworkConnectivity();
        DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
        returnFromDate(pastMonth, false);
        DateTime now = DateTime.now();
        returnToDate(now, false);
        apiCallBack(1);
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
    return BaseSingleton.shared.dateModel.eventId;
  }

  @override
  String getCustomerId() {
    return BaseSingleton.shared.dateModel.customerId;
  }

  @override
  String getFromDate() {
    return _modalOverallReport.fromDate;
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
    return _modalOverallReport.toDate;
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
      if (listOverAllReports != null) {
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

  @override
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }
}
