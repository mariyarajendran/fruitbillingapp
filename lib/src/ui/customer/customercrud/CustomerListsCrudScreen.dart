import 'package:IGO/src/data/apis/customer/customerlist/ICustomerListener.dart';
import 'package:IGO/src/data/apis/customer/customerlist/PresenterCustomerList.dart';
import 'package:IGO/src/data/apis/customer/updatecustomer/IUpdateCustomerListener.dart';
import 'package:IGO/src/data/apis/customer/updatecustomer/PresenterUpdateCustomer.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/customer/addcustomerscreen/AddCustomerScreen.dart';
import 'package:IGO/src/ui/dashboard/DateModel.dart';
import 'package:IGO/src/ui/report/overallreport/OverallReportListScreen.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import '../../../utils/localizations.dart';
import 'ModalCustomerListsCrud.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(CustomerListsCrudScreen());
CustomerDetails customerDetailsNavigate = new CustomerDetails();
DateModel dateModel;

class CustomerListsCrudScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomerListsCrudScreenStateful(),
    );
  }
}

class CustomerListsCrudScreenStateful extends StatefulWidget {
  CustomerListsCrudScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CustomerListsCrudScreenState createState() => CustomerListsCrudScreenState();
}

class CustomerListsCrudScreenState
    extends BaseStateStatefulState<CustomerListsCrudScreenStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        BaseAlertListener,
        ICustomerListener,
        IUpdateCustomerListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalCustomerListsCrud _modalCustomerListsCrud;
  PresenterCustomerList _presenterCustomerList;
  PresenterUpdateCustomer _presenterUpdateCustomer;

  AnimationController _animationController;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};

  List<CustomerDetails> customerDetails = [];
  List<CustomerDetails> duplicateCustomerDetails = [];

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  CustomerListsCrudScreenState() {
    this._modalCustomerListsCrud = new ModalCustomerListsCrud();
    this._connectivity = new Connectivitys(this);
    this._presenterCustomerList = new PresenterCustomerList(this);
    this._presenterUpdateCustomer = new PresenterUpdateCustomer(this);
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalCustomerListsCrud.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalCustomerListsCrud.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalCustomerListsCrud.eventCircularLoader = status;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    ExpansionPanelList expansionPanelList = new ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          customerDetails[index].isExpanded = !isExpanded;
        });
      },
      children: customerDetails.map<ExpansionPanel>((CustomerDetails item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: new Text(
                      item.customerName,
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
                            color: ConstantColor.COLOR_UNBLOCKED,
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
                                              AppLocalizations.instance.text(
                                                  'key_customer_bill_name'),
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
                                              AppLocalizations.instance.text(
                                                  'key_customer_whatsapp_no'),
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
                                              item.customerBillingName,
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
                                              "${item.customerWhatsappNo}",
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
                                              AppLocalizations.instance.text(
                                                  'key_customer_phone_no'),
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
                                                  .text('key_address'),
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
                                              "${item.customerMobileNo}",
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
                                              "${item.customerAddress}",
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
                                                customerDetailsNavigate = item;
                                                navigationPushReplacementPassParams(
                                                    AddCustomerScreenStateful(
                                                  customerDetails:
                                                      customerDetailsNavigate,
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
                                                _modalCustomerListsCrud
                                                        .customerId =
                                                    item.customerId;
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
                                      new Expanded(
                                        child: new Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              bottom: appConfig.rHP(3),
                                              top: appConfig.rHP(2.5)),
                                          child: FlatButton(
                                            child: Text(
                                                AppLocalizations.instance
                                                    .text('key_bills'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ConstantColor
                                                        .COLOR_WHITE,
                                                    fontFamily: ConstantCommon
                                                        .BASE_FONT,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            color: ConstantColor.COLOR_APP_BASE,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                BaseSingleton.shared.dateModel =
                                                    new DateModel("", "",
                                                        item.customerId, 1);
                                                navigationPushReplacementPassParams(
                                                    OverallReportListStateful());
                                              });
                                            },
                                          ),
                                        ),
                                        flex: 1,
                                      )
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
        color: ConstantColor.COLOR_CUSTOMER,
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
                    color: ConstantColor.COLOR_CUSTOMER_BACKGROUND),
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
              AppLocalizations.instance.text('key_customers'),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: ConstantColor.COLOR_BLACK,
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
      margin: EdgeInsets.only(top: appConfig.rHP(7), bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 6,
        value: _modalCustomerListsCrud.loadingCircularBar,
        valueColor:
            new AlwaysStoppedAnimation<Color>(ConstantColor.COLOR_WHITE),
      )),
    );

    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ConstantColor.COLOR_CUSTOMER_BACKGROUND,
          drawerEdgeDragWidth: 0,
          appBar: AppBar(
            backgroundColor: ConstantColor.COLOR_CUSTOMER,
            automaticallyImplyLeading: false,
            title: containerAppBar,
            centerTitle: false,
            actions: <Widget>[],
            bottomOpacity: 1,
          ),
          body: !_modalCustomerListsCrud.isNetworkStatus
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
                                                _modalCustomerListsCrud
                                                        .boolNodata
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
                          absorbing:
                              _modalCustomerListsCrud.loadingEnableDisable,
                        ),
                      ),
                    ],
                  ),
                  onRefresh: refreshList)
              : centerContainerNoNetwork,
          floatingActionButton: new FloatingActionButton(
            backgroundColor: ConstantColor.COLOR_CUSTOMER,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                customerDetailsNavigate = new CustomerDetails();
                navigationPushReplacementPassParams(AddCustomerScreenStateful(
                  customerDetails: customerDetailsNavigate,
                ));
                //navigateBaseRouting(5);
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

  void forSomeDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // onlineDisappear();
    });
  }

  void showDialog() {
    setState(() {
      _modalCustomerListsCrud.loadingEnableDisable = true;
      _modalCustomerListsCrud.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalCustomerListsCrud.loadingEnableDisable = false;
      _modalCustomerListsCrud.loadingCircularBar = 0.0;
    });
  }

  void runShakeAnimation() async {
    for (int i = 0; i < 2; i++) {
      await _animationController.forward(from: 0);
      await _animationController.reverse(from: 100);
    }
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
        _animationController = AnimationController(
            vsync: this, duration: Duration(milliseconds: 500));
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

  void getCustomerList() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterCustomerList.getCustomerList();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  void getDeleteCustomer() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterUpdateCustomer.hitUpdateCustomerDataCall();
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
        getCustomerList();
      } else if (event == 2) {
        showDialog();
        getDeleteCustomer();
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
    if (customerDetails.length > 0) {
      updateNoData(false);
    } else {
      updateNoData(true);
    }
  }

  @override
  void onTapAlertOkayListener() {
    setState(() {
      apiCallBack(2);
    });
  }

  @override
  void onTapAlertQuitAppListener() {
    setState(() {});
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  void onTapAlertProductCalculationListener(ProductDetails productDetails) {
    setState(() {});
  }

  @override
  void onFailureResponseGetCustomerList(String statusCode) {
    setState(() {
      showErrorAlert(statusCode);
      dismissLoadingDialog();
      updateNoDataController();
    });
  }

  @override
  void onSuccessResponseGetCustomerList(
      CustomerListResponseModel customerListResponseModel) {
    setState(() {
      dismissLoadingDialog();
      if (customerListResponseModel.isSuccess) {
        customerDetails = (customerListResponseModel.customerDetails as List)
            .map((datas) => new CustomerDetails.fromMap(datas))
            .toList();
        duplicateCustomerDetails =
            (customerListResponseModel.customerDetails as List)
                .map((datas) => new CustomerDetails.fromMap(datas))
                .toList();
      } else {
        customerDetails = [];
        duplicateCustomerDetails = [];
      }
      updateNoDataController();
    });
  }

  @override
  Map parseGetCustomerDetailsRequestData() {
    return {
      "search_keyword": getSearchkeyword().trim(),
      "page_count": getPageCount().trim(),
      "page_limits": BaseSingleton.shared.pageLimits
    };
  }

  @override
  void errorValidationMgs(String error) {
    setState(() {});
  }

  @override
  String getCustomerMobileNo() {
    return "";
  }

  @override
  String getCustomerStatus() {
    return "false";
  }

  @override
  String getCustomerWhatsAppNo() {
    return "";
  }

  @override
  String getCustonerId() {
    return _modalCustomerListsCrud.customerId;
  }

  @override
  void onFailureMessageUpdateCustomer(String error) {
    setState(() {
      showErrorAlert(error);
      dismissLoadingDialog();
    });
  }

  @override
  void onSuccessResponseUpdateCustomer(
      UpdateCustomerResponseModel updateCustomerResponseModel) {
    setState(() {
      showToast(updateCustomerResponseModel.message);
      dismissLoadingDialog();
      apiCallBack(1);
    });
  }

  @override
  Map parseUpdateCustomerData() {
    return {
      "customer_name": "",
      "customer_id": getCustonerId(),
      "customer_billing_name": "",
      "customer_address": "",
      "customer_mobile_no": "",
      "customer_whatsapp_no": "",
      "customer_status": getCustomerStatus()
    };
  }

  @override
  void postUpdateCustomerData() {
    setState(() {});
  }

  @override
  String getCustomerAddressUpdate() {
    return "";
  }

  @override
  String getCustomerBillingNameUpdate() {
    return "";
  }

  @override
  String getCustomerNameUpdate() {
    return "";
  }

  @override
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }
}
