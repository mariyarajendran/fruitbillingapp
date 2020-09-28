import 'package:IGO/src/data/apis/bills/getallpendingbalance/IGetPendingBalanceListener.dart';
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalance/GetPendingBalanceResponseModel.dart';
import 'IntractorGetPendingBalanceList.dart';

class PresenterPendingBalanceList {
  IGetPendingBalanceListener _getPendingBalanceListener;
  IntractorGetPendingBalanceList _intractorGetPendingBalanceList;

  PresenterPendingBalanceList(this._getPendingBalanceListener) {
    _intractorGetPendingBalanceList = new IntractorGetPendingBalanceList(this);
  }

  void getPendingBalance() {
    _intractorGetPendingBalanceList.getPendingBalance(
        _getPendingBalanceListener.parseGetAllPendingBalanceRequestData());
  }

  void onSuccessResponseGetOrderReportList(
      GetPendingBalanceResponseModel getPendingBalanceResponseModel) {
    if (getPendingBalanceResponseModel.isSuccess) {
      List<PendingBalanceDetails> pendingBalanceDetails = [];
      pendingBalanceDetails = (getPendingBalanceResponseModel.balanceDetails)
          .map((datas) => new PendingBalanceDetails.fromMap(datas))
          .toList();
      _getPendingBalanceListener
          .onSuccessResponseGetAllPendingBalanceList(pendingBalanceDetails);
    } else {
      _getPendingBalanceListener.onFailureResponseGetAllPendingBalance(
          getPendingBalanceResponseModel.message);
    }
  }

  void onFailureResponseGetOrderReportList(String statusCode) {
    _getPendingBalanceListener
        .onFailureResponseGetAllPendingBalance(statusCode);
  }
}
