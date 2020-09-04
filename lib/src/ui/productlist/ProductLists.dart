import 'package:IGO/src/allcalls/logout/ILogoutListener.dart';
import 'package:IGO/src/allcalls/logout/PresenterLogout.dart';
import 'package:IGO/src/allcalls/productlist/IProductListListener.dart';
import 'package:IGO/src/allcalls/productlist/PresenterProductList.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';
import 'ModaProductLists.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';
import 'package:IGO/src/ui/base/BaseAlertListener.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:IGO/src/utils/Connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import './../../utils/AppConfig.dart';
import './../../constants/ConstantCommon.dart';
import './../../constants/ConstantColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ProductListsScreen());

int organizationID;
String organizationName;
String organizationName2;
String eventStartDate;
double eventLatitude;
double eventLongitude;

class ProductListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListsScreenStateful(),
    );
  }
}

class ProductListsScreenStateful extends StatefulWidget {
  ProductListsScreenStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ProductListsScreenState createState() => ProductListsScreenState();
}

class ProductListsScreenState
    extends BaseStateStatefulState<ProductListsScreenStateful>
    with TickerProviderStateMixin
    implements
        ViewContractConnectivityListener,
        IProductListListener,
        BaseAlertListener,
        ILogoutListener {
  AppConfig appConfig;
  ScrollController _RefreshController;
  Connectivitys _connectivity = Connectivitys.instance;
  ModaProductLists _modaProductLists;
  PresenterProductList _presenterProductList;
  PresenterLogout _presenterLogout;

  AnimationController _animationController;
  Map _sourceConnectionStatus = {ConnectivityResult.none: false};
  List<ProductDetails> callLogImportInfo = [];
  List<ProductDetails> duplicateCallLogImportInfo = [];

  //Keys//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchcontroller = new TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  ProductListsScreenState() {
    this._modaProductLists = new ModaProductLists();
    this._connectivity = new Connectivitys(this);
    this._presenterProductList = new PresenterProductList(this);
    this._presenterLogout = new PresenterLogout(this);
  }

  void checkInternetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessageAlert(
        AppLocalizations.instance.text('key_no_network'),
        AppLocalizations.instance.text('key_retry'),
        0));
  }

  void updateInternetConnectivity(bool networkStatus) {
    _modaProductLists.isNetworkStatus = networkStatus;
  }

  void updateNoData(bool status) {
    _modaProductLists.boolNodata = status;
  }

  void updateEventCircularLoader(bool status) {
    _modaProductLists.eventCircularLoader = status;
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
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: new Text(
                                              AppLocalizations.instance
                                                  .text('key_select_kg'),
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
                                                top: appConfig.rHP(3)),
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
                                                  .text('key_total_cost'),
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
                                                top: appConfig.rHP(3)),
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
                                    children: [
                                      new Expanded(
                                        child: new Align(
                                          child: new Container(
                                            child: FlatButton(
                                              child: Text(
                                                  "${item.totalKiloGrams} Kg",
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
                                                  showProductCalculationAlertDialog(
                                                      item.productName,
                                                      AppLocalizations.instance
                                                          .text('key_done'),
                                                      AppLocalizations.instance
                                                          .text('key_clear'),
                                                      1,
                                                      item,
                                                      this);
                                                });
                                              },
                                            ),
                                            margin: EdgeInsets.only(
                                                top: appConfig.rHP(3),
                                                bottom: appConfig.rHP(3)),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: Align(
                                          child: new Container(
                                            child: new Text(
                                              "₹ ${item.totalCost}",
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
                                                top: appConfig.rHP(3),
                                                bottom: appConfig.rHP(3)),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      new Container(
                                          height: 40,
                                          alignment: Alignment.topRight,
                                          margin: EdgeInsets.only(
                                              bottom: appConfig.rHP(3)),
                                          child: FloatingActionButton.extended(
                                              heroTag: item.productId,
                                              backgroundColor:
                                                  ConstantColor.COLOR_APP_BASE,
                                              elevation: 5.0,
                                              onPressed: () {
                                                dismissKeyboard();
                                                setState(() {
                                                  if (item.totalCost == 0) {
                                                    showToast(AppLocalizations
                                                        .instance
                                                        .text(
                                                            'key_select_kilos'));
                                                  } else {
                                                    ///add to bill array
                                                    ///
                                                    ///

                                                    if (checkDuplicateBillInCart(
                                                        item)) {
                                                      runShakeAnimation();
                                                      vibratePhone();
                                                      BaseSingleton.shared
                                                          .billingProductList
                                                          .add(item);
                                                      showToast(AppLocalizations
                                                          .instance
                                                          .text(
                                                              'key_added_cart'));
                                                    } else {
                                                      showToast(AppLocalizations
                                                          .instance
                                                          .text(
                                                              'key_already_in_cart'));
                                                    }
                                                  }
                                                });
                                              },
                                              label: Text(
                                                AppLocalizations.instance
                                                    .text('key_add_to_bill'),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: ConstantColor
                                                        .COLOR_CORE,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: ConstantCommon
                                                        .BASE_FONT),
                                              ))),
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
                    AppLocalizations.instance.text('key_user_product_list'),
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
                  color: ConstantColor.COLOR_APP_BASE,
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
                              hintText: AppLocalizations.instance
                                  .text('key_search_hint'),
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
        value: _modaProductLists.loadingCircularBar,
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
            actions: <Widget>[
//              new InkWell(
//                  child: new Container(
//                    padding: EdgeInsets.only(right: appConfig.rWP(4)),
//                    child: Image.asset(
//                      "assets/images/profiles.png",
//                      width: 35,
//                      height: 40,
//                    ),
//                  ),
//                  onTap: () {
//                    setState(() {
//                      getLocalSessionDatas();
//                      showAlertDialog(
//                          AppLocalizations.instance.text('key_are_you_logout'),
//                          AppLocalizations.instance.text('key_okay'),
//                          AppLocalizations.instance.text('key_cancel'),
//                          0,
//                          this);
//                    });
//                  }),

              new InkWell(
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: -.1)
                      .chain(CurveTween(curve: Curves.elasticIn))
                      .animate(_animationController),
                  child: new Container(
                    padding: EdgeInsets.only(
                        right: appConfig.rW(5), top: appConfig.rHP(1)),
                    child: new Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        new Container(
                          child: new IconButton(
                            icon: new Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: null,
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
                                    BaseSingleton
                                        .shared.billingProductList.length
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
                  ),
                ),
                onTap: () {
                  navigateBaseRouting(5);
                },
              ),
            ],
            bottomOpacity: 1,
          ),
          body: !_modaProductLists.isNetworkStatus
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
                                                _modaProductLists.boolNodata
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
                          absorbing: _modaProductLists.loadingEnableDisable,
                        ),
                      ),
                    ],
                  ),
                  onRefresh: refreshList)
              : centerContainerNoNetwork,
        ),
        onWillPop: () {
          setState(() {
            showAlertDialog(
                AppLocalizations.instance.text('key_exit'),
                AppLocalizations.instance.text('key_quit'),
                AppLocalizations.instance.text('key_cancel'),
                1,
                this);
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
      _modaProductLists.loadingEnableDisable = true;
      _modaProductLists.loadingCircularBar = null;
    });
  }

  void dismissLoadingDialog() {
    setState(() {
      _modaProductLists.loadingEnableDisable = false;
      _modaProductLists.loadingCircularBar = 0.0;
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

  void logoutUser() {
    checkConnectivityResponse().then((data) {
      if (data) {
        setState(() {
          updateInternetConnectivity(false);
          _presenterLogout.logoutUser();
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
      } else if (event == 7) {
        showDialog();
        logoutUser();
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
      callLogImportInfo = (productListResponseModel.productDetails as List)
          .map((datas) => new ProductDetails.fromMap(datas))
          .toList();
      duplicateCallLogImportInfo =
          (productListResponseModel.productDetails as List)
              .map((datas) => new ProductDetails.fromMap(datas))
              .toList();
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
      apiCallBack(7);
    });
  }

  @override
  void onFailureResponseGetUserLogout(String statusCode) {
    setState(() {
      dismissLoadingDialog();
    });
  }

  @override
  void onSuccessResponseUserLogout(LogoutResponseModel logoutResponseModel) {
    setState(() {
      dismissLoadingDialog();
      resetAppClearLocalAndSessionData();
    });
  }

  @override
  int getUserId() {
    return BaseSingleton.shared.userID;
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
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Map parseGetProductDetailsRequestData() {
    return _modaProductLists.mapProductDetDetailsData = {
      "search_keyword": getSearchkeyword().trim(),
      "page_count": getPageCount().trim(),
      "page_limits": BaseSingleton.shared.pageLimits
    };
  }

  @override
  void onTapAlertProductCalculationListener(ProductDetails productDetails) {
    setState(() {});
  }
}
