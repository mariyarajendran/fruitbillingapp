
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalancehistory/GetPendingBalanceHistoryResponseModel.dart';
import 'IGetPendingBalanceHistoryListener.dart';
import 'IntractorGetPendingBalanceHistory.dart';

class PresenterPendingBalanceHistory {
  IGetPendingBalanceHistoryListener _getPendingBalanceHistoryListener;
  IntractorGetPendingBalanceHistory _intractorGetPendingBalanceHistory;

  PresenterPendingBalanceHistory(this._getPendingBalanceHistoryListener) {
    _intractorGetPendingBalanceHistory =
        new IntractorGetPendingBalanceHistory(this);
  }

  void getPendingBalanceHistory() {
    _intractorGetPendingBalanceHistory.getPendingBalanceHistory(
        _getPendingBalanceHistoryListener
            .parseGetAllPendingBalanceHistoryRequestData());
  }

  void onSuccessResponseGetOrderReportHistory(
      GetPendingBalanceHistoryResponseModel
          getPendingBalanceHistoryResponseModel) {
    List<PendingBalanceHistoryDetails> pendingBalanceHistoryDetails = [];
    pendingBalanceHistoryDetails =
        (getPendingBalanceHistoryResponseModel.balanceDetails)
            .map((datas) => new PendingBalanceHistoryDetails.fromMap(datas))
            .toList();
    _getPendingBalanceHistoryListener
        .onSuccessResponseGetAllPendingBalanceHistory(
            pendingBalanceHistoryDetails);
  }

  void onFailureResponseGetOrderReportHistory(String statusCode) {
    _getPendingBalanceHistoryListener
        .onFailureResponseGetAllPendingBalanceHistory(statusCode);
  }
}
