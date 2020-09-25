import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';

abstract class IUpdateCustomerListener {
  String getCustonerId();

  String getCustomerName();

  String getCustomerBillingName();

  String getCustomerAddress();

  String getCustomerMobileNo();

  String getCustomerWhatsAppNo();

  String getCustomerStatus();

  Map parseUpdateCustomerData();

  void postUpdateCustomerData();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdateCustomer(
      CustomerDetailsUpdate customerDetailsUpdate);

  void onFailureMessageUpdateCustomer(String error);
}
