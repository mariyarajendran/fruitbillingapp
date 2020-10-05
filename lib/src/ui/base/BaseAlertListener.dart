import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';

abstract class BaseAlertListener {
  void onTapAlertOkayListener();

  void onTapAlertQuitAppListener();

  void onTapAlertProductCalculationListener(ProductDetails productDetails);
}
