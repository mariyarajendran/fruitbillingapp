import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';

abstract class IOrderDetailReportListener {
  void onSuccessResponseGetOverAllDetailsOrderList(
      OrderDetailsReportResponseModel orderDetailsReportResponseModel);

  void onFailureResponseGetOverAllDetailsOrderList(String statusCode);

  String getOrderId();

  String getCustomerId();

  String getOrderSummaryId();

  Map parseGetProductDetailsRequestData();
}
