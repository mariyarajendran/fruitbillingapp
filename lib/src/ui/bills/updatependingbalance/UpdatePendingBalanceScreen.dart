import 'package:IGO/src/data/apis/bills/savebill/ISaveBillListener.dart';
import 'package:IGO/src/data/apis/bills/savebill/PresenterSaveBillData.dart';
import 'package:IGO/src/data/apis/bills/updatependingbalance/IUpdatePendingBalanceListener.dart';
import 'package:IGO/src/data/apis/bills/updatependingbalance/PresenterUpdatePendingBalance.dart';
import 'package:IGO/src/data/apis/report/orderdetailsreport/IOrderDetailReportListener.dart';
import 'package:IGO/src/data/apis/report/orderdetailsreport/PresenterOrderDetailReportList.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';
import 'package:IGO/src/ui/bills/pendingbalancescreen/PendingBalanceListScreen.dart';
import 'package:IGO/src/ui/report/overallreport/OverAllParamModel.dart';
import 'package:IGO/src/utils/AppConfig.dart';
import 'package:IGO/src/utils/constants/ConstantColor.dart';
import 'package:IGO/src/utils/constants/ConstantCommon.dart';
import 'ModalUpdatePendingBalance.dart';
import 'ModelUpdatePending.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(UpdatePendingBalanceScreen());

class UpdatePendingBalanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UpdatePendingBalanceStateful(),
    );
  }
}

class UpdatePendingBalanceStateful extends StatefulWidget {
  UpdatePendingBalanceStateful(
      {Key key, this.title, @required this.overAllParamModel})
      : super(key: key);
  final OverAllParamModel overAllParamModel;
  final String title;
  PendingBalanceListScreen pendingBalanceListScreen;

  @override
  UpdatePendingBalanceState createState() => UpdatePendingBalanceState();
}

class UpdatePendingBalanceState
    extends BaseStateStatefulState<UpdatePendingBalanceStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        BaseAlertListener,
        IOrderDetailReportListener,
        IUpdatePendingBalanceListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModalUpdatePendingBalance _modalUpdatePendingBalance;
  PresenterOrderDetailReportList _presenterOrderDetailReportList;
  AnimationController _animationController;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  List<OverAllDetailReports> overAllDetailReports = [];
  OrderDetailsReportResponseModel orderDetailsReportResponseModel =
      new OrderDetailsReportResponseModel();
  CustomerDetails customerDetails = new CustomerDetails();
  ModelUpdatePending modelUpdatePending;
  ModelUpdatePending dummyModelUpdatePending;
  PresenterUpdatePendingBalance _presenterUpdatePendingBalance;

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  UpdatePendingBalanceState() {
    this._modalUpdatePendingBalance = new ModalUpdatePendingBalance();
    this._connectivity = new Connectivitys(this);
    _presenterOrderDetailReportList = new PresenterOrderDetailReportList(this);
    this._presenterUpdatePendingBalance =
        new PresenterUpdatePendingBalance(this);
    this.modelUpdatePending = new ModelUpdatePending(
        overAllParamModel.totalBalanceAmount,
        int.parse(overAllParamModel.receivedBalanceAmount),
        overAllParamModel.pendingBalanceAmount,
        overAllParamModel.pendingBalanceAmount,
        0,
        0);
    this.dummyModelUpdatePending = new ModelUpdatePending(
        overAllParamModel.totalBalanceAmount,
        int.parse(overAllParamModel.receivedBalanceAmount),
        overAllParamModel.pendingBalanceAmount,
        overAllParamModel.pendingBalanceAmount,
        0,
        0);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modalUpdatePendingBalance.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modalUpdatePendingBalance.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modalUpdatePendingBalance.eventCircularLoader = status;
  }

  void calculatePendingAmountAlert() {
    setState(() {
      modelUpdatePending = new ModelUpdatePending(
        modelUpdatePending.totalCost,
        modelUpdatePending.receivedCost,
        modelUpdatePending.pendingCost,
        modelUpdatePending.orderSummaryPendingCost,
        modelUpdatePending.orderPendinghistoryReceivedCost,
        modelUpdatePending.orderPendinghistoryPendingCost,
      );
      showUpdatePendingBalanceAlertDialog("Update Pending Amount", "Done", 1,
          modelUpdatePending, dummyModelUpdatePending, this);
    });
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
                                            customerDetails.customerName ?? '',
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
                                            customerDetails
                                                    .customerBillingName ??
                                                '',
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
                                            customerDetails.customerMobileNo ??
                                                '',
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
                                            customerDetails
                                                    .customerWhatsappNo ??
                                                '',
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
                                                          overAllDetailReports[
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
                                                          "₹ ${overAllDetailReports[index].productCost}",
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
                                                          "${overAllDetailReports[index].productStockKg} Kg",
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
                                                          "₹ ${overAllDetailReports[index].productTotalCost}",
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
              childCount: overAllDetailReports.length,
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
      margin: EdgeInsets.only(bottom: appConfig.rHP(10)),
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
                                        "₹ ${modelUpdatePending.totalCost}",
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

    InkWell inkwellTotal = new InkWell(
      child: previewBillTotalContainer,
      onTap: () {
        calculatePendingAmountAlert();
      },
    );

    Container previewBillReceivedContainer = new Container(
      margin: EdgeInsets.only(bottom: appConfig.rHP(5)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Card(
              color: ConstantColor.COLOR_GREEN,
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
                                        "Received",
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
                                        "₹ ${modelUpdatePending.receivedCost}",
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

    InkWell inkwellReceived = new InkWell(
      child: previewBillReceivedContainer,
      onTap: () {
        calculatePendingAmountAlert();
      },
    );

    Container previewBillPendingContainer = new Container(
      margin: EdgeInsets.only(bottom: appConfig.rHP(0)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Card(
              color: ConstantColor.COLOR_RED,
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
                                        "Pending",
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
                                        "₹ ${modelUpdatePending.pendingCost}",
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

    InkWell inkwellPending = new InkWell(
      child: previewBillPendingContainer,
      onTap: () {
        calculatePendingAmountAlert();
      },
    );

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
                    navigateBaseRouting(12);
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
          new Expanded(
            child: new Container(
              child: InkWell(
                child: Container(
                  child: Image.asset(
                    "assets/images/billing.png",
                    width: 35,
                    height: 35,
                    color: ConstantColor.COLOR_WHITE,
                  ),
                ),
                onTap: () {
                  setState(() {
                    apiCallBack(1);
                  });
                },
              ),
              alignment: Alignment.topRight,
            ),
            flex: 0,
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

    Container containerCircularLoader = new Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 6,
        value: _modalUpdatePendingBalance.loadingCircularBar,
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
            bottomOpacity: 1,
          ),
          body: !_modalUpdatePendingBalance.isNetworkStatus
              ? _modalUpdatePendingBalance.boolNodata
                  ? containerNoData
                  : AbsorbPointer(
                      child: new Stack(
                        children: [
                          containerBillPreview,
                          inkwellPending,
                          inkwellReceived,
                          inkwellTotal,
                          new Align(
                              alignment: Alignment.center,
                              child: containerCircularLoader),
                        ],
                      ),
                      absorbing:
                          _modalUpdatePendingBalance.loadingEnableDisable,
                    )
              : centerContainerNoNetwork,
        ),
        onWillPop: () {
          setState(() {
            navigateBaseRouting(12);
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
      _modalUpdatePendingBalance.loadingEnableDisable = true;
      _modalUpdatePendingBalance.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modalUpdatePendingBalance.loadingEnableDisable = false;
      _modalUpdatePendingBalance.loadingCircularBar = 0.0;
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
        apiCallBack(0);
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

  void apiCallBack(int event) {
    setState(() {
      if (event == 0) {
        showDialog();
        getOverAllDetailsReportList();
      } else if (event == 1) {
        updatePendingBalance();
      }
    });
  }

  void getOverAllDetailsReportList() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterOrderDetailReportList.getOrderDetailsReportList();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  void updatePendingBalance() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterUpdatePendingBalance.hitPostUpdatePendingDataCall();
        });
      } else {
        setState(() {
          updateInternetConnectivity(true);
        });
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
    return null;
  }

  void updateNoDataController() {
    if (overAllDetailReports.length > 0) {
      updateNoData(false);
    } else {
      updateNoData(true);
    }
  }

  void clearBillingSessionData() {
    BaseSingleton.shared.billingProductList = [];
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

  @override
  String getCustomerId() {
    return overAllParamModel.customerId;
  }

  @override
  String getOrderId() {
    return overAllParamModel.orderId;
  }

  @override
  void onFailureResponseGetOverAllDetailsOrderList(String statusCode) {
    setState(() {
      dismissLoadingDialog();
      showErrorAlert(statusCode);
      updateNoDataController();
    });
  }

  @override
  void onSuccessResponseGetOverAllDetailsOrderList(
      OrderDetailsReportResponseModel orderDetailsReportResponseModel) {
    setState(() {
      dismissLoadingDialog();
      if (orderDetailsReportResponseModel != null) {
        this.orderDetailsReportResponseModel = orderDetailsReportResponseModel;
        this.overAllDetailReports =
            (orderDetailsReportResponseModel.overAllDetailReports)
                .map((datas) => new OverAllDetailReports.fromMap(datas))
                .toList();
        this.customerDetails = orderDetailsReportResponseModel.customerDetails;
        updateNoDataController();
      }
    });
  }

  @override
  Map parseGetProductDetailsRequestData() {
    return {'order_id': getOrderId(), 'customer_id': getCustomerId()};
  }

  @override
  void onTapAlertReceivedCalculationListener(
      ModelBalanceReceived modelBalanceReceived) {
    // TODO: implement onTapAlertReceivedCalculationListener
  }

  @override
  void errorValidationMgs(String error) {
    setState(() {});
  }

  @override
  String getOrderPendingHistoryPendingAmount() {
    return modelUpdatePending.orderPendinghistoryPendingCost.toString();
  }

  @override
  String getOrderPendingHistoryReceivedAmount() {
    return modelUpdatePending.orderPendinghistoryReceivedCost.toString();
  }

  @override
  String getOrderSummaryId() {
    return overAllParamModel.orderSummaryId.trim();
  }

  @override
  String getOrderSummaryPendingAmount() {
    return modelUpdatePending.orderSummaryPendingCost.toString();
  }

  @override
  String getPendingAmount() {
    return modelUpdatePending.pendingCost.toString();
  }

  @override
  String getReceivedAmount() {
    return modelUpdatePending.receivedCost.toString();
  }

  @override
  void onFailureMessageUpdatePendingBalance(String error) {
    setState(() {
      dismissLoadingDialog();
      showErrorAlert(error);
    });
  }

  @override
  void onSuccessResponseUpdatePendingBalance(String msg) {
    setState(() {
      dismissLoadingDialog();
      showToast(msg);
      navigateBaseRouting(12);
    });
  }

  @override
  Map parseUpdatePendingBalanceData() {
    return {
      "order_summary_id": getOrderSummaryId(),
      "pending_amount": getPendingAmount(),
      "received_amount": getReceivedAmount(),
      "order_summary_pending_amount": getOrderSummaryPendingAmount(),
      "order_pending_history_received": getOrderPendingHistoryReceivedAmount(),
      "order_pending_history_pending": getOrderPendingHistoryPendingAmount()
    };
  }

  @override
  void postUpdatePendingBalanceData() {
    setState(() {});
  }
}
