import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/ui/bills/billpreviewscreen/ModelBalanceReceived.dart';

abstract class BaseAlertListener {
  void onTapAlertOkayListener();

  void onTapAlertQuitAppListener();

  void onTapAlertProductCalculationListener(ProductDetails productDetails);

  void onTapAlertReceivedCalculationListener(ModelBalanceReceived modelBalanceReceived);
}
