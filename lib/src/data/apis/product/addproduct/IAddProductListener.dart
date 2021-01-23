abstract class IAddProductListener {
  String getProductName();

  String getProductPrice();

  String getProductCode();

  void postAddProductData();

  String getProductKg();

  String getProductPreviousBalanceFlag();

  Map parseAddProductData();

  void errorValidationMgs(String error);

  void onSuccessResponseAddProduct(String msg);

  void onFailureMessageAddProduct(String error);

  void clearAllEditTextDatas();
}
