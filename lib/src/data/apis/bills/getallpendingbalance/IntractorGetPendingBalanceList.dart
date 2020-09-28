import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/bills/getallpendingbalance/PresenterPendingBalanceList.dart';
import 'package:IGO/src/di/di.dart';

class IntractorGetPendingBalanceList {
  PresenterPendingBalanceList _presenterPendingBalanceList;
  AllApiRepository _allApiRepository;

  IntractorGetPendingBalanceList(
      PresenterPendingBalanceList _presenterPendingBalanceList) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterPendingBalanceList = _presenterPendingBalanceList;
  }

  void getPendingBalance(Map requestData) {
    _allApiRepository.getPendingBalance(requestData, 0).then((data) {
      _presenterPendingBalanceList.onSuccessResponseGetOrderReportList(data);
    }).catchError((error) {
      _presenterPendingBalanceList.onFailureResponseGetOrderReportList(
          new FetchDataException(error.toString()).toString());
    });
  }
}
