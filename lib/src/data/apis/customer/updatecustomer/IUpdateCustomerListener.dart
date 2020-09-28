import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';

abstract class IUpdateCustomerListener {
  String getCustonerId();

  String getCustomerNameUpdate();

  String getCustomerBillingNameUpdate();

  String getCustomerAddressUpdate();

  String getCustomerMobileNo();

  String getCustomerWhatsAppNo();

  String getCustomerStatus();

  Map parseUpdateCustomerData();

  void postUpdateCustomerData();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdateCustomer(
      UpdateCustomerResponseModel updateCustomerResponseModel);

  void onFailureMessageUpdateCustomer(String error);
}
