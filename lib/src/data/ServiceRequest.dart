import 'dart:io';
import 'package:IGO/src/models/responsemodel/addcustomerresponsedata/AddCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/addproductresponsemodel/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customerresponsemodel/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';
import 'package:IGO/src/models/responsemodel/resetpasswordresponsemodel/ResetResponseModel.dart';
import 'package:IGO/src/models/responsemodel/signupresponsemodel/SignUpResponseModel.dart';
import 'package:IGO/src/ui/base/BaseSingleton.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'AllApiRepository.dart';
import './FetchDataException.dart';
import './HttpStatus.dart';

class ServiceRequest implements AllApiRepository {
  static const String PBX_BASE_URL =
      "https://pbxbackofficedevapi.azurewebsites.net/";

  static const String FRUIT_BILLING_BASE_URL =
      "https://dev.fruitbilling.cabelsoft.in/";

  static const String FRUIT_BILLING_LOCAL_SERVER =
      "http://192.168.43.11/fruitbilling/";

  static const String ADD_PRODUCT =
      FRUIT_BILLING_BASE_URL + "api/json/addNewProduct";

  @override
  Future<AddProductResponseModel> postAddProductDatas(
      Map loginDatas, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    AddProductResponseModel addProductResponseModel;
    var body = json.encode(loginDatas);
    await HttpClientHelper.post(ADD_PRODUCT,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + ADD_PRODUCT);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      addProductResponseModel =
          new AddProductResponseModel.fromMapStatus(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return addProductResponseModel;
  }

  static const String RESET_PASSWORD = PBX_BASE_URL + "api/Login/ResetPassword";

  @override
  Future<ResetResponseModel> postResetPasswordDatas(
      Map resetDatas, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    ResetResponseModel resetResponseModel;
    var body = json.encode(resetDatas);
    await HttpClientHelper.post(RESET_PASSWORD,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + RESET_PASSWORD);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      resetResponseModel = new ResetResponseModel.fromMap(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return resetResponseModel;
  }

  @override
  Future<ProductListResponseModel> getProductListData(
      Map requestData, int event) async {
    String GET_PRODUCT_LIST =
        FRUIT_BILLING_BASE_URL + "api/json/getAllProducts";

    ProductListResponseModel productListResponseModel =
        new ProductListResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(GET_PRODUCT_LIST,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + GET_PRODUCT_LIST);
      print("header: " + headers.toString());
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print("Response: $responseBody");
      productListResponseModel =
          new ProductListResponseModel.fromMap(responseBody);
      if (statusCode != 201 && statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return productListResponseModel;
  }

  @override
  Future<LogoutResponseModel> logoutUser(int userID, int event) async {
    String LOGOUT =
        PBX_BASE_URL + "api/Login/UpdateOnlineUser?UserId=$userID&IsLogin=N";

    LogoutResponseModel logoutResponseModel = new LogoutResponseModel();
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    await HttpClientHelper.post(LOGOUT,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + LOGOUT);
      print("header: " + headers.toString());
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      logoutResponseModel = new LogoutResponseModel.fromMap(responseBody);
      if (statusCode != 200 || responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return logoutResponseModel;
  }

  static const String ADD_CUSTOMER =
      FRUIT_BILLING_BASE_URL + "api/json/addNewCustomer";

  @override
  Future<AddCustomerResponseModel> postAddCustomerDatas(
      Map customerDatas, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    AddCustomerResponseModel addCustomerResponseModel;
    var body = json.encode(customerDatas);
    await HttpClientHelper.post(ADD_CUSTOMER,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + ADD_CUSTOMER);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      addCustomerResponseModel =
          new AddCustomerResponseModel.fromMapStatus(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return addCustomerResponseModel;
  }

  @override
  Future<CustomerListResponseModel> getCustomerListData(
      Map requestData, int event) async {
    String GET_CUSTOMER_LIST =
        FRUIT_BILLING_BASE_URL + "api/json/getAllCustomer";

    CustomerListResponseModel customerListResponseModel =
        new CustomerListResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(GET_CUSTOMER_LIST,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + GET_CUSTOMER_LIST);
      print("header: " + headers.toString());
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print("Response: $responseBody");
      customerListResponseModel =
          new CustomerListResponseModel.fromMap(responseBody);
      if (statusCode != 201 && statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return customerListResponseModel;
  }

/////////////////////////////////////////

}
