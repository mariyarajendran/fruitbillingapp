import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';

abstract class BaseAlertListener {
  void onTapAlertOkayListener();

  void onTapAlertQuitAppListener();

  void onTapAlertProductCalculationListener(ProductDetails productDetails);
}
