import 'dart:io';
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalance/GetPendingBalanceResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalancehistory/GetPendingBalanceHistoryResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/savebill/SaveBillResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/updatependingbalance/UpdatePendBalanceResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/addcustomer/AddCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/dashboard/dashboarddetails/DashboardDetailsResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/addproduct/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';
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
      print("requestData: " + body);
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
      print("request: " + body.toString());
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print("Response: ${response.body}");
      customerListResponseModel =
          new CustomerListResponseModel.fromMap(responseBody);
      if (statusCode != 201 && statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return customerListResponseModel;
  }

  static const String UPDATE_PRODUCT =
      FRUIT_BILLING_BASE_URL + "api/json/updateProduct";

  @override
  Future<UpdateProductResponseModel> postUpdateProductDatas(
      Map requestData, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    UpdateProductResponseModel updateProductResponseModel =
        new UpdateProductResponseModel();
    var body = json.encode(requestData);
    await HttpClientHelper.post(UPDATE_PRODUCT,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + UPDATE_PRODUCT);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      updateProductResponseModel =
          new UpdateProductResponseModel.fromMap(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return updateProductResponseModel;
  }

  static const String UPDATE_CUSTOMER =
      FRUIT_BILLING_BASE_URL + "api/json/updateCustomer";

  @override
  Future<UpdateCustomerResponseModel> postUpdateCustomerDatas(
      Map requestData, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    UpdateCustomerResponseModel updateCustomerResponseModel =
        new UpdateCustomerResponseModel();
    var body = json.encode(requestData);
    await HttpClientHelper.post(UPDATE_CUSTOMER,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + UPDATE_CUSTOMER);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      updateCustomerResponseModel =
          new UpdateCustomerResponseModel.fromMap(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return updateCustomerResponseModel;
  }

  static const String DASHBOARD_DETAILS =
      FRUIT_BILLING_BASE_URL + "api/json/getDashboardDetails";

  @override
  Future<DashboardDetailsResponseModel> getDashboardDetailsDatas(
      Map requestData, int event) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    DashboardDetailsResponseModel dashboardDetailsResponseModel =
        new DashboardDetailsResponseModel();
    var body = json.encode(requestData);
    await HttpClientHelper.post(DASHBOARD_DETAILS,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + DASHBOARD_DETAILS);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      dashboardDetailsResponseModel =
          new DashboardDetailsResponseModel.fromMap(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return dashboardDetailsResponseModel;
  }

  @override
  Future<OrderReportResponseModel> getOverAllOrderReports(
      Map requestData, int event) async {
    String OVER_ALL_REPORT =
        FRUIT_BILLING_BASE_URL + "api/json/getOverAllOrderReports";

    OrderReportResponseModel orderReportResponseModel =
        new OrderReportResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(OVER_ALL_REPORT,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + OVER_ALL_REPORT);
      print("header: " + headers.toString());
      print("request: " + body);
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print("Response: ${response.body}");
      orderReportResponseModel =
          new OrderReportResponseModel.fromMap(responseBody);
      if (statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return orderReportResponseModel;
  }

  @override
  Future<OrderDetailsReportResponseModel> getOverAllOrderDetailedReports(
      Map requestData, int event) async {
    String OVER_ALL_DETAIL_REPORT =
        FRUIT_BILLING_BASE_URL + "api/json/getOverAllOrderDetailedReports";

    OrderDetailsReportResponseModel orderDetailsReportResponseModel =
        new OrderDetailsReportResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(OVER_ALL_DETAIL_REPORT,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + OVER_ALL_DETAIL_REPORT);
      print("Request: " + body.toString());
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      orderDetailsReportResponseModel =
          new OrderDetailsReportResponseModel.fromMap(responseBody);
      if (statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return orderDetailsReportResponseModel;
  }

  @override
  Future<GetPendingBalanceResponseModel> getPendingBalance(
      Map requestData, int event) async {
    String GET_PENDING_BALANCE =
        FRUIT_BILLING_BASE_URL + "api/json/getPendingBalance";

    GetPendingBalanceResponseModel getPendingBalanceResponseModel =
        new GetPendingBalanceResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(GET_PENDING_BALANCE,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + GET_PENDING_BALANCE);
      print("header: " + body);
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      getPendingBalanceResponseModel =
          new GetPendingBalanceResponseModel.fromMap(responseBody);
      if (statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return getPendingBalanceResponseModel;
  }

  @override
  Future<SaveBillResponseModel> postPlaceOrder(
      Map requestData, int event) async {
    String POST_PLACE_ORDER = FRUIT_BILLING_BASE_URL + "api/json/placeOrder";

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    SaveBillResponseModel saveBillResponseModel = new SaveBillResponseModel();
    var body = json.encode(requestData);
    await HttpClientHelper.post(POST_PLACE_ORDER,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + POST_PLACE_ORDER);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      saveBillResponseModel =
          new SaveBillResponseModel.fromMapStatus(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return saveBillResponseModel;
  }

  @override
  Future<UpdatePendBalanceResponseModel> updatePendingBalance(
      Map requestData, int event) async {
    String UPDATE_PENDING_BALANCE =
        FRUIT_BILLING_BASE_URL + "api/json/updatePendingBalance";

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': BaseSingleton.shared.jwtToken,
    };

    UpdatePendBalanceResponseModel updatePendBalanceResponseModel =
        new UpdatePendBalanceResponseModel();
    var body = json.encode(requestData);
    await HttpClientHelper.post(UPDATE_PENDING_BALANCE,
            body: body,
            headers: headers,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 5))
        .then((response) {
      print("url:" + UPDATE_PENDING_BALANCE);
      print("requestData: " + body);
      final statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      updatePendBalanceResponseModel =
          new UpdatePendBalanceResponseModel.fromMapStatus(responseBody);
      if (statusCode != HttpStatus.STATUS_200 || response.body == null) {
        throw new FetchDataException("$statusCode");
      }
    });
    return updatePendBalanceResponseModel;
  }

  @override
  Future<GetPendingBalanceHistoryResponseModel> getPendingBalanceHistory(
      Map requestData, int event) async {
    String GET_PENDING_BALANCE_HISTORY =
        FRUIT_BILLING_BASE_URL + "api/json/getPendingBalanceHistory";

    GetPendingBalanceHistoryResponseModel
        getPendingBalanceHistoryResponseModel =
        new GetPendingBalanceHistoryResponseModel();

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var body = json.encode(requestData);
    await HttpClientHelper.post(GET_PENDING_BALANCE_HISTORY,
            headers: headers,
            body: body,
            timeRetry: Duration(milliseconds: 100),
            retries: 3,
            timeLimit: Duration(seconds: 10))
        .then((response) {
      print("url: " + GET_PENDING_BALANCE_HISTORY);
      print("header: " + body);
      int statusCode = response.statusCode;
      final Map responseBody = json.decode(response.body);
      print("status code: $statusCode");
      print(response.body);
      getPendingBalanceHistoryResponseModel =
          new GetPendingBalanceHistoryResponseModel.fromMap(responseBody);
      if (statusCode != 200 && responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]  Message : $responseBody");
      }
    });
    return getPendingBalanceHistoryResponseModel;
  }

/////////////////////////////////////////

}
