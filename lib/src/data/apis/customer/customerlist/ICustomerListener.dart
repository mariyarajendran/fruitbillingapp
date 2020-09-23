import 'package:IGO/src/models/responsemodel/customer/customerresponsemodel/CustomerListResponseModel.dart';


abstract class ICustomerListener {
  void onSuccessResponseGetCustomerList(
      CustomerListResponseModel customerListResponseModel);

  void onFailureResponseGetCustomerList(String statusCode);

  String getPageCount();

  String getSearchkeyword();

  Map parseGetCustomerDetailsRequestData();
}
