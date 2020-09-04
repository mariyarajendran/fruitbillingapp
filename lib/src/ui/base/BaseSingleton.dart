import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customerresponsemodel/CustomerListResponseModel.dart';

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
  int userID=0;
  List<ProductDetails> billingProductList = [];
  int pageLimits=100;
  List<CustomerDetails> customerDetails=[];

  void clearAllBaseSingleton() {
    jwtToken = "";
    subscribeID = "";
    loginSession = "";
    appLocalLang = "ta";
    userEmailId = "";
    userID=0;
  }
}
