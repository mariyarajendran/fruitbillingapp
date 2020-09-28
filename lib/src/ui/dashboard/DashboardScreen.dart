import 'package:IGO/src/data/apis/dashboard/dashboarddetails/IDashboardDetailsListener.dart';
import 'package:IGO/src/data/apis/dashboard/dashboarddetails/PresenterDashboardDetails.dart';
import 'package:IGO/src/models/responsemodel/dashboard/dashboarddetails/DashboardDetailsResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/ui/dashboard/DateModel.dart';
import 'package:IGO/src/ui/report/overallreport/OverallReportListScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModelDashboard.dart';
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

void main() => runApp(DashboardScreen());

DateModel dateModel;

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreenStateful(),
    );
  }
}

class DashboardScreenStateful extends StatefulWidget {
  DashboardScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState
    extends BaseStateStatefulState<DashboardScreenStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        BaseAlertListener,
        IDashboardDetailsListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModelDashboard _modelDashboard;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  PresenterDashboardDetails _presenterDashboardDetails;
  DashboardDetails _dashboardDetails;

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  DashboardScreenState() {
    this._modelDashboard = new ModelDashboard();
    this._connectivity = new Connectivitys(this);
    this._presenterDashboardDetails = new PresenterDashboardDetails(this);
    this._dashboardDetails = new DashboardDetails();
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modelDashboard.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modelDashboard.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modelDashboard.eventCircularLoader = status;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    Container containerCircularLoader = new Container(
      margin: EdgeInsets.only(top: 80, bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 6,
        value: _modelDashboard.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_APP_BASE),
      )),
    );

    Container containerDashTitle = new Container(
      child: new Text(
        "Dashboard",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: ConstantColor.COLOR_BLACK,
            fontFamily: ConstantCommon.BASE_FONT,
            fontSize: 24,
            fontWeight: FontWeight.w400),
      ),
      margin: EdgeInsets.only(top: appConfig.rHP(7), left: appConfig.rWP(5)),
    );

    Container containerDashTitleUser = new Container(
      child: new Text(
        "Welcome Raja",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: ConstantColor.COLOR_BLACK,
            fontFamily: ConstantCommon.BASE_FONT_REGULAR,
            fontSize: 20,
            fontWeight: FontWeight.w400),
      ),
      margin: EdgeInsets.only(top: appConfig.rHP(1), left: appConfig.rWP(5)),
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
        controller: _modelDashboard.textEditingControllerFromDate,
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
        controller: _modelDashboard.textEditingControllerToDate,
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
          margin: EdgeInsets.only(
              top: appConfig.rHP(2),
              left: appConfig.rWP(1),
              right: appConfig.rW(1)),
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

    Column columnTotalCustomer = new Column(
      children: [
        new Container(
          margin: EdgeInsets.only(
              top: appConfig.rHP(0),
              left: appConfig.rWP(1),
              right: appConfig.rW(1)),
          child: Card(
            child: new Row(
              children: [
                new Expanded(
                  flex: 1,
                  child: new Center(
                    child: new Container(
                      child: Image.asset(
                        "assets/images/customer.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Text(
                    "Customer",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new Text(
                        "${_dashboardDetails.customerCount ?? 0}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ConstantColor.COLOR_BLACK,
                            fontFamily: ConstantCommon.BASE_FONT,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      margin: EdgeInsets.only(right: appConfig.rWP(5)),
                    ))
              ],
            ),
            elevation: 2,
          ),
          height: 80,
        )
      ],
    );

    InkWell inkWellTotalCustomer = new InkWell(
      child: columnTotalCustomer,
      onTap: () {
        setState(() {
          navigateBaseRouting(10);
        });
      },
    );

    Container previewBillContainer = new Container(
      margin: EdgeInsets.only(top: appConfig.rH(2)),
      child: Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: appConfig.rHP(6),
                child: FlatButton(
                  child: Text("Billing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ConstantColor.COLOR_WHITE,
                          fontFamily: ConstantCommon.BASE_FONT,
                          fontSize: 17,
                          fontWeight: FontWeight.w400)),
                  color: ConstantColor.COLOR_GREEN,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      navigateBaseRouting(6);
                    });
                  },
                ),
              ))),
    );

    Column columnTotalProduct = new Column(
      children: [
        new Container(
          margin: EdgeInsets.only(
              top: appConfig.rHP(0),
              left: appConfig.rWP(1),
              right: appConfig.rW(1)),
          child: Card(
            child: new Row(
              children: [
                new Expanded(
                  flex: 1,
                  child: new Center(
                    child: new Container(
                      child: Image.asset(
                        "assets/images/products.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Text(
                    "Products",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new Text(
                        "${_dashboardDetails.productCount ?? 0}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ConstantColor.COLOR_BLACK,
                            fontFamily: ConstantCommon.BASE_FONT,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      margin: EdgeInsets.only(right: appConfig.rWP(5)),
                    ))
              ],
            ),
            elevation: 2,
          ),
          height: 80,
        )
      ],
    );

    InkWell inkWellTotalProduct = new InkWell(
      child: columnTotalProduct,
      onTap: () {
        setState(() {
          navigateBaseRouting(5);
        });
      },
    );

    Column columnOverAllAmount = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        new Container(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Container(
              child: new Text(
                "Overall Selled Price",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ConstantColor.COLOR_BLACK,
                    fontFamily: ConstantCommon.BASE_FONT,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
              margin: EdgeInsets.only(top: appConfig.rHP(2)),
            ),
            new Container(
              child: new Text(
                "₹ ${_dashboardDetails.overallAmount ?? 0}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ConstantColor.COLOR_BLACK,
                    fontFamily: ConstantCommon.BASE_FONT,
                    fontSize: 25,
                    fontWeight: FontWeight.w400),
              ),
              margin: EdgeInsets.only(top: appConfig.rHP(1)),
            )
          ],
        )),
        new Container(
          margin: EdgeInsets.only(
              top: appConfig.rHP(0),
              left: appConfig.rWP(1),
              right: appConfig.rW(1)),
          child: Card(
            child: new Row(
              children: [
                new Expanded(
                  flex: 1,
                  child: new Center(
                    child: new Container(
                      child: Image.asset(
                        "assets/images/profit.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Text(
                    "Received",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new Text(
                        "₹ ${_dashboardDetails.totalIncome ?? 0}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ConstantColor.COLOR_GREEN,
                            fontFamily: ConstantCommon.BASE_FONT,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      margin: EdgeInsets.only(right: appConfig.rWP(5)),
                    ))
              ],
            ),
          ),
          height: 80,
        ),
        new Container(
          margin:
              EdgeInsets.only(left: appConfig.rWP(1), right: appConfig.rW(1)),
          child: Card(
            child: new Row(
              children: [
                new Expanded(
                  flex: 1,
                  child: new Center(
                    child: new Container(
                      child: Image.asset(
                        "assets/images/lose.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Text(
                    "Pending",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantColor.COLOR_BLACK,
                        fontFamily: ConstantCommon.BASE_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new Text(
                        "₹ ${_dashboardDetails.pendingIncome ?? 0}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ConstantColor.COLOR_RED,
                            fontFamily: ConstantCommon.BASE_FONT,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      margin: EdgeInsets.only(right: appConfig.rWP(5)),
                    ))
              ],
            ),
          ),
          height: 80,
        ),
        previewBillContainer,
      ],
    );

    InkWell inkWellOverAllAmount = new InkWell(
      child: columnOverAllAmount,
      onTap: () {
        setState(() {
          dateModel =
              new DateModel(_modelDashboard.fromDate, _modelDashboard.toDate);
          navigationPushReplacementPassParams(OverallReportListStateful(
            dateModel: dateModel,
          ));
        });
      },
    );

    Column columnDashboardTitle = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        containerDashTitle,
        containerDashTitleUser,
        columnDateFilter,
        inkWellTotalCustomer,
        inkWellTotalProduct,
        inkWellOverAllAmount,
      ],
    );

    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ConstantColor.COLOR_BACKGROUND,
          drawerEdgeDragWidth: 0,
          body: !_modelDashboard.isNetworkStatus
              ? SingleChildScrollView(
                  child: AbsorbPointer(
                  child: new Stack(
                    children: [
                      columnDashboardTitle,
                      new Align(
                          alignment: Alignment.center,
                          child: containerCircularLoader),
                    ],
                  ),
                  absorbing: _modelDashboard.loadingEnableDisable,
                ))
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
      _modelDashboard.loadingEnableDisable = true;
      _modelDashboard.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modelDashboard.loadingEnableDisable = false;
      _modelDashboard.loadingCircularBar = 0.0;
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
        DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
        returnFromDate(pastMonth, false);
        DateTime now = DateTime.now();
        returnToDate(now, false);
        apiCallBack(0);
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

  void hitDashboardDetails() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterDashboardDetails.hitGetDashboardDetailsDatas();
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
      if (event == 0) {
        showDialog();
        hitDashboardDetails();
      } else if (event == 7) {}
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
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
    setState(() {});
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

  String returnFromDate(DateTime dateTime, bool hitCall) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    _modelDashboard.textEditingControllerFromDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modelDashboard.fromDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(0);
    }
    return _modelDashboard.fromDate;
  }

  String returnToDate(DateTime dateTime, bool hitCall) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    _modelDashboard.textEditingControllerToDate.text =
        formatter.format(dateTime);
    DateFormat yearformatter = DateFormat('yyyy-MM-dd');
    _modelDashboard.toDate = yearformatter.format(dateTime);
    if (true) {
      apiCallBack(0);
    }
    return _modelDashboard.toDate;
  }

  @override
  String getFromDate() {
    return _modelDashboard.fromDate;
  }

  @override
  String getToDate() {
    return _modelDashboard.toDate;
  }

  @override
  void onFailureMessageDashboardDetails(String error) {
    setState(() {
      dismissLoadingDialog();
      //showErrorAlert(error);
    });
  }

  @override
  void onSuccessResponseDashboardDetails(DashboardDetails dashboardDetails) {
    setState(() {
      this._dashboardDetails = dashboardDetails;
      dismissLoadingDialog();
    });
  }

  @override
  Map parseDashboardDetailsData() {
    return {'from_date': getFromDate(), 'to_date': getToDate()};
  }
}
