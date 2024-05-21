import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/bills/updatependingbalance/PresenterUpdatePendingBalance.dart';
import 'package:IGO/src/di/di.dart';

class IntractorUpdatePendingBalance {
  PresenterUpdatePendingBalance _presenterUpdatePendingBalance;
  AllApiRepository _allApiRepository;

  IntractorUpdatePendingBalance(
      PresenterUpdatePendingBalance _presenterUpdatePendingBalance) {
    this._presenterUpdatePendingBalance = _presenterUpdatePendingBalance;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitUpdatePendingBalanceCall(Map mapProductData) {
    _allApiRepository.updatePendingBalance(mapProductData, 0).then((data) {
      if (data.success) {
        _presenterUpdatePendingBalance
            .onSuccessResponseUpdatePendingBalance(data.message);
      } else {
        _presenterUpdatePendingBalance
            .onFailureMessageUpdatePendingBalance(data.message);
      }
    }).catchError((error) {
      _presenterUpdatePendingBalance.onFailureMessageUpdatePendingBalance(
          FetchDataException(error).toString());
    });
  }
}
