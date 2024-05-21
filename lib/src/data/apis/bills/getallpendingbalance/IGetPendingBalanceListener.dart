import 'package:IGO/src/models/responsemodel/bills/getallpendingbalance/GetPendingBalanceResponseModel.dart';

abstract class IGetPendingBalanceListener {
  void onSuccessResponseGetAllPendingBalanceList(
      List<PendingBalanceDetails> listPendingBalanceDetails);

  void onFailureResponseGetAllPendingBalance(String statusCode);

  String getSearchkeyword();

  String getFromDate();

  String getToDate();

  Map parseGetAllPendingBalanceRequestData();
}
