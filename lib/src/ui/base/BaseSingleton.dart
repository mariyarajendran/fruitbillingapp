import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';

class BaseSingleton {
  static final BaseSingleton _baseSingleton = new BaseSingleton._internal();

  factory BaseSingleton() {
    return _baseSingleton;
  }

  BaseSingleton._internal();

  static BaseSingleton get shared => _baseSingleton;

  var jwtToken = "";
  var subscribeID = "";
  var loginSession = "";
  bool firstTimeOfApp = false;
  var appLocalLang = "ta";
  var userEmailId = "";
  int userID = 0;
  List<ProductDetails> billingProductList = [];
  int pageLimits = 100;
  List<CustomerDetails> customerDetails = [];

  void clearBillSessionAndCustomerSession() {
    billingProductList = [];
    customerDetails = [];
  }

  void clearAllBaseSingleton() {
    jwtToken = "";
    subscribeID = "";
    loginSession = "";
    appLocalLang = "ta";
    userEmailId = "";
    userID = 0;
  }
}
