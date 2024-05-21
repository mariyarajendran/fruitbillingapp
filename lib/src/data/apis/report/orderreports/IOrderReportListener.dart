import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';

abstract class IOrderReportListener {
  void onSuccessResponseGetOverAllOrderList(
      List<OverAllReports> listOverAllReports);

  void onFailureResponseGetOverAllOrderList(String statusCode);

  String getPageCount();

  String getSearchkeyword();

  String getCustomerId();

  String getPageLimits();

  String getFromDate();

  String getToDate();

  int eventId();

  Map parseGetOverAllOrderRequestData();
}
