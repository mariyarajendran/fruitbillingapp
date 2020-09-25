import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';

abstract class IOrderDetailReportListener {
  void onSuccessResponseGetOverAllDetailsOrderList(
      List<OverAllDetailReports> listOverAllDetailReports);

  void onFailureResponseGetOverAllDetailsOrderList(String statusCode);

  String getOrderId();

  Map parseGetProductDetailsRequestData();
}
