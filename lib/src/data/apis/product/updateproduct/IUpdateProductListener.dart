
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';

abstract class IUpdateProductListener {
  String getProductId();

  String getProductName();

  String getProductCost();

  String getProductStockKg();

  String getProductCode();

  String getProductStatus();

  Map parseUpdateProductData();

  void postUpdateProductData();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdateProduct(ProductDetailsUpdate productDetails);

  void onFailureMessageUpdateProduct(String error);
}
