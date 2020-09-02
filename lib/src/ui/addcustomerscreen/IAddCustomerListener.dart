
abstract class IAddCustomerListener {
  String getCustomerName();

  String getCustomerBillingName();

  String getCustomerAddress();

  String getCustomerPhoneNumber();

  String getCustomerWhatsAppNumberNumber();

  void errorValidationMgs(String error);
}
