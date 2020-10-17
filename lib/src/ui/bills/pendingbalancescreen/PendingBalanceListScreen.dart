import 'package:IGO/src/data/apis/bills/getallpendingbalance/IGetPendingBalanceListener.dart';
import 'package:IGO/src/data/apis/bills/getallpendingbalance/PresenterPendingBalanceList.dart';
import 'package:IGO/src/data/apis/report/orderreports/IOrderReportListener.dart';
import 'package:IGO/src/data/apis/report/orderreports/PresenterOrderReportList.dart';
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalance/GetPendingBalanceResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/bills/updatependingbalance/UpdatePendingBalanceScreen.dart';
import 'package:IGO/src/ui/customer/customercrud/CustomerListsCrudScreen.dart';
import 'package:IGO/src/ui/dashboard/DashboardScreen.dart';
import 'package:IGO/src/ui/dashboard/DateModel.dart';
import 'package:IGO/src/ui/report/overalldetailreport/OverAllDetailedReportScreen.dart';
import 'package:IGO/src/ui/report/overallreport/OverAllParamModel.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModalPendingBalance.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(PendingBalanceListScreen());
OverAllParamModel overAllParamModel;

class PendingBalanceListScreen extends StatelessWidget {
  const PendingBalanceListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PendingBalanceListStateful(),
    );
  }
}

class PendingBalanceListStateful extends StatefulWidget {
  String title;

  PendingBalanceListStateful({Key key, this.title}) : super(key: key);

  @override
  PendingBalanceListState createState() => PendingBalanceListState();
}

class PendingBalanceListState
    extends BaseStateStatefulState<PendingBalanceListStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        BaseAlertListener,
        IGetPendingBalanceListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalPendingBalance _modalPendingBalance;
  TextEditingController searchcontroller = new TextEditingController();
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  List<CustomerDetails> customerDetails = [];
  List<CustomerDetails> duplicateCustomerDetails = [];
  List<PendingBalanceDetails> listPendingBalanceDetails = [];
  DashboardScreen dashboardScreen;
  CustomerListsCrudScreen customerListsCrudScreen;
  PresenterPendingBalanceList _presenterPendingBalanceList;

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  PendingBalanceListState() {
    this._modalPendingBalance = new ModalPendingBalance();
    this._connectivity = new Connectivitys(this);
    this._presenterPendingBalanceList = new PresenterPendingBalanceList(this);
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalPendingBalance.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalPendingBalance.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalPendingBalance.eventCircularLoader = status;
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
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .orderId,
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .customerId,
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .totalAmount,
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .receivedAmount,
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .pendingAmount,
                                                  listPendingBalanceDetails[
                                                          index]
                                                      .orderSummaryId);
                                          navigationPushReplacementPassParams(
                                              UpdatePendingBalanceStateful(
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
                                                                  "# ${listPendingBalanceDetails[index].orderId ?? ''}",
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
                                                                  "₹ ${listPendingBalanceDetails[index].totalAmount ?? 0}",
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
                                                                      "₹ ${listPendingBalanceDetails[index].receivedAmount ?? 0}",
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
                                                                  "₹ ${listPendingBalanceDetails[index].pendingAmount ?? 0}",
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
                childCount: listPendingBalanceDetails.length),
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
            color: ConstantColor.COLOR_BLACK,
            fontSize: 16,
            fontFamily: ConstantCommon.BASE_FONT_SEMI_BOLD),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            //labelText: AppLocalizations.instance.text('key_product_name'),
            labelText: "From Date",
            labelStyle: TextStyle(color: ConstantColor.COLOR_BLACK),
            hintStyle: TextStyle(color: ConstantColor.COLOR_BLACK),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                gapPadding: 10.0,
                borderRadius: BorderRadius.circular(1.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                gapPadding: 10.0),
            contentPadding: EdgeInsets.all(20.0)),
        onFieldSubmitted: (v) {},
        textCapitalization: TextCapitalization.sentences,
        controller: _modalPendingBalance.textEditingControllerFromDate,
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
            color: ConstantColor.COLOR_BLACK,
            fontSize: 16,
            fontFamily: ConstantCommon.BASE_FONT_SEMI_BOLD),
        enableInteractiveSelection: false,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            //labelText: AppLocalizations.instance.text('key_product_name'),
            labelText: "To Date",
            labelStyle: TextStyle(color: ConstantColor.COLOR_BLACK),
            hintStyle: TextStyle(color: ConstantColor.COLOR_BLACK),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ConstantColor.COLOR_LIGHT_GREY_ONE, width: 0.5),
                gapPadding: 10.0,
                borderRadius: BorderRadius.circular(1.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide:
                    BorderSide(color: ConstantColor.COLOR_APP_BASE, width: 1.3),
                gapPadding: 10.0),
            contentPadding: EdgeInsets.all(20.0)),
        onFieldSubmitted: (v) {},
        textCapitalization: TextCapitalization.sentences,
        controller: _modalPendingBalance.textEditingControllerToDate,
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

    Container containerClubListsAll = new Container(
      color: ConstantColor.COLOR_LIGHT_GREY,
      child: new Stack(
        children: <Widget>[
          containerAppTitleHintBar,
          _modalPendingBalance.boolNodata
              ? containerNoData
              : new Container(
                  margin: EdgeInsets.only(top: appConfig.rHP(8)),
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

    Container containerCircularLoader = new Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 6,
        value: _modalPendingBalance.loadingCircularBar,
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
          body: !_modalPendingBalance.isNetworkStatus
              ? containerClubListsAll
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
    _modalPendingBalance.textEditingControllerFromDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modalPendingBalance.fromDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(1);
    }
    return _modalPendingBalance.fromDate;
  }

  String returnToDate(DateTime dateTime, bool hitCall) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    _modalPendingBalance.textEditingControllerToDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modalPendingBalance.toDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(1);
    }
    return _modalPendingBalance.toDate;
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
      _modalPendingBalance.loadingEnableDisable = true;
      _modalPendingBalance.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalPendingBalance.loadingEnableDisable = false;
      _modalPendingBalance.loadingCircularBar = 0.0;
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

  void getAllPendingBalanceList() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterPendingBalanceList.getPendingBalance();
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
        getAllPendingBalanceList();
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
      if (listPendingBalanceDetails.length > 0) {
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
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }

  @override
  String getFromDate() {
    return _modalPendingBalance.fromDate.trim();
  }

  @override
  String getSearchkeyword() {
    return "";
  }

  @override
  String getToDate() {
    return _modalPendingBalance.toDate.trim();
  }

  @override
  void onFailureResponseGetAllPendingBalance(String statusCode) {
    setState(() {
      updateNoDataController();
      dismissLoadingDialog();
      showErrorAlert(statusCode);
    });
  }

  @override
  void onSuccessResponseGetAllPendingBalanceList(
      List<PendingBalanceDetails> listPendingBalanceDetails) {
    setState(() {
      dismissLoadingDialog();
      if (listPendingBalanceDetails != null) {
        this.listPendingBalanceDetails = listPendingBalanceDetails;
        updateNoDataController();
      }
    });
  }

  @override
  Map parseGetAllPendingBalanceRequestData() {
    return {
      "search_keyword": getSearchkeyword(),
      "from_date": getFromDate(),
      "to_date": getToDate()
    };
  }
}
