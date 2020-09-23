
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';

abstract class ICustomerListener {
  void onSuccessResponseGetCustomerList(
      CustomerListResponseModel customerListResponseModel);

  void onFailureResponseGetCustomerList(String statusCode);

  String getPageCount();

  String getSearchkeyword();

  Map parseGetCustomerDetailsRequestData();
}
