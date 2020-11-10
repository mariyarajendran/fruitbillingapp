import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/bills/getallpendingbalance/PresenterPendingBalanceList.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterPendingBalanceHistory.dart';

class IntractorGetPendingBalanceHistory {
  PresenterPendingBalanceHistory _presenterPendingBalanceHistory;
  AllApiRepository _allApiRepository;

  IntractorGetPendingBalanceHistory(
      PresenterPendingBalanceHistory _presenterPendingBalanceHistory) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterPendingBalanceHistory = _presenterPendingBalanceHistory;
  }

  void getPendingBalanceHistory(Map requestData) {
    _allApiRepository.getPendingBalanceHistory(requestData, 0).then((data) {
      _presenterPendingBalanceHistory
          .onSuccessResponseGetOrderReportHistory(data);
    }).catchError((error) {
      _presenterPendingBalanceHistory.onFailureResponseGetOrderReportHistory(
          new FetchDataException(error.toString()).toString());
    });
  }
}
