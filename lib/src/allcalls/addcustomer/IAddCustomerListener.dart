abstract class IAddCustomerListener {
  String getCustomerName();

  String getCustomerBillingName();

  String getCustomerAddress();

  String getCustomerPhoneNumber();

  String getCustomerWhatsAppNumberNumber();

  void errorValidationMgs(String error);

  void onSuccessResponseAddProduct(String msg);

  void onFailureMessageAddProduct(String error);

  Map parseAddCustomerData();

  void hitPostAddCustomerData();

  void clearAllEditTextDatas();
}
