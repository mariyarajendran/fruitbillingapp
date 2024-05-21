import 'package:IGO/src/data/apis/bills/updatependingbalance/IUpdatePendingBalanceListener.dart';
import '../../../../utils/localizations.dart';
import 'IntractorUpdatePendingBalance.dart';


class PresenterUpdatePendingBalance {
  IUpdatePendingBalanceListener _iUpdatePendingBalanceListener;
  IntractorUpdatePendingBalance _intractorUpdatePendingBalance;

  PresenterUpdatePendingBalance(this._iUpdatePendingBalanceListener) {
    _intractorUpdatePendingBalance = new IntractorUpdatePendingBalance(this);
  }

  void onSuccessResponseUpdatePendingBalance(String msg) {
    _iUpdatePendingBalanceListener.onSuccessResponseUpdatePendingBalance(msg);
  }

  void onFailureMessageUpdatePendingBalance(String error) {
    _iUpdatePendingBalanceListener.onFailureMessageUpdatePendingBalance(error);
  }

  void hitPostUpdatePendingDataCall() {
    _intractorUpdatePendingBalance.hitUpdatePendingBalanceCall(
        _iUpdatePendingBalanceListener.parseUpdatePendingBalanceData());
  }

  void validateUpdatePendingBalanceData() {
    if (_iUpdatePendingBalanceListener.getOrderSummaryId().isEmpty) {
      _iUpdatePendingBalanceListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_name'));
    } else if (_iUpdatePendingBalanceListener.getPendingAmount().isEmpty) {
      _iUpdatePendingBalanceListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_cost'));
    } else if (_iUpdatePendingBalanceListener.getReceivedAmount().isEmpty) {
      _iUpdatePendingBalanceListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_code'));
    } else {
      _iUpdatePendingBalanceListener.postUpdatePendingBalanceData();
    }
  }
}
