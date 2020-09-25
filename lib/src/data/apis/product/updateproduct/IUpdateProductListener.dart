abstract class IUpdateProductListener {
  String getProductId();

  String getProductName();

  String getProductCost();

  String getProductStockKg();

  String getProductCode();

  String getProductStatus();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdateProduct(String msg);

  void onFailureMessageUpdateProduct(String error);
}
