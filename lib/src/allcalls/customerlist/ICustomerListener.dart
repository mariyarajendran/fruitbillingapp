import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customerresponsemodel/CustomerListResponseModel.dart';

abstract class ICustomerListener {
  void onSuccessResponseGetCustomerList(
      CustomerListResponseModel customerListResponseModel);

  void onFailureResponseGetCustomerList(String statusCode);

  String getPageCount();

  String getSearchkeyword();

  Map parseGetCustomerDetailsRequestData();
}
