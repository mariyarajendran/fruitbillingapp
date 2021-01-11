import 'package:IGO/src/models/responsemodel/bills/getallpendingbalancehistory/GetPendingBalanceHistoryResponseModel.dart';

abstract class IGetPendingBalanceHistoryListener {
  void onSuccessResponseGetAllPendingBalanceHistory(
      List<PendingBalanceHistoryDetails> pendingBalanceHistoryDetails);

  void onFailureResponseGetAllPendingBalanceHistory(String statusCode);

  Map parseGetAllPendingBalanceHistoryRequestData();
}
