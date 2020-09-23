

import 'package:IGO/src/models/responsemodel/product/calllogresponsemodel/ProductListResponseModel.dart';

abstract class BaseAlertListener {
  void onTapAlertOkayListener();

  void onTapAlertQuitAppListener();

  void onTapAlertProductCalculationListener(ProductDetails productDetails);
}
